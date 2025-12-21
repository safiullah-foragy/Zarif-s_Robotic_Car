/*
 * Zarif's Robotic Car - Arduino Code
 * Adafruit Motor Shield v1 with Obstacle Avoidance
 * 
 * Hardware:
 * - Adafruit Motor Shield v1 (uses AFMotor library)
 * - Motors: M1 (Front Left), M2 (Rear Left), M3 (Front Right), M4 (Rear Right)
 * 
 * Shield uses pins: 4, 7, 8, 11, 12 (shift register)
 * Shield uses: A0, A1, A2, A3 (motor PWM - don't use for sensors!)
 * 
 * Ultrasonic Sensor:
 * - TRIG -> Pin 2
 * - ECHO -> Pin 3
 * 
 * ESP8266 WiFi Module:
 * - ESP8266 TX -> Arduino RX (Pin 0)
 * - ESP8266 RX -> Arduino TX (Pin 1)
 * - ESP8266 GND -> Arduino GND
 * - ESP8266 VIN -> Arduino 5V
 * 
 * Commands via Serial (from ESP8266):
 * - FORWARD, BACKWARD, LEFT, RIGHT, STOP
 * - MODE:AUTO, MODE:MANUAL
 */

#include <AFMotor.h>

// Create motor objects (connected to M1, M2, M3, M4 on shield)
// M1 = Front Left, M2 = Rear Left, M3 = Front Right, M4 = Rear Right
AF_DCMotor motorFrontLeft(1);   // M1
AF_DCMotor motorRearLeft(2);    // M2
AF_DCMotor motorFrontRight(3);  // M3
AF_DCMotor motorRearRight(4);   // M4

// Motor speed (0-255)
#define MOTOR_SPEED 200  // Adjust this value (150-255)

// Ultrasonic sensor pins
#define TRIG_PIN 2
#define ECHO_PIN 3

// Distance threshold (in cm)
#define OBSTACLE_DISTANCE 30

// Control mode
bool manualMode = false;
String currentCommand = "STOP";
unsigned long lastCommandTime = 0;
const unsigned long COMMAND_TIMEOUT = 200; // 200ms timeout for continuous commands

void setup() {
  // Initialize serial communication with ESP8266
  Serial.begin(9600);
  
  // Set motor speeds - ALL 4 motors
  motorFrontLeft.setSpeed(MOTOR_SPEED);
  motorRearLeft.setSpeed(MOTOR_SPEED);
  motorFrontRight.setSpeed(MOTOR_SPEED);
  motorRearRight.setSpeed(MOTOR_SPEED);
  
  // Initialize ultrasonic sensor pins
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  
  // Stop motors first
  stopMotors();
  delay(500);
  
  Serial.println("Setup complete - Ready");
}

void loop() {
  // Check for commands from ESP8266
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n');
    command.trim();
    processCommand(command);
  }
  
  // Auto mode: obstacle avoidance
  if (!manualMode) {
    autoMode();
  }
}

void processCommand(String command) {
  Serial.print("Received: ");
  Serial.print(command);
  Serial.print(" | Mode: ");
  Serial.println(manualMode ? "MANUAL" : "AUTO");
  
  if (command == "MODE:AUTO") {
    manualMode = false;
    currentCommand = "STOP";
    Serial.println("ACK:AUTO");
  } 
  else if (command == "MODE:MANUAL") {
    manualMode = true;
    stopMotors();
    Serial.println("ACK:MANUAL");
  } 
  else if (manualMode) {
    // Manual control commands
    if (command == "FORWARD") {
      moveForward();
      currentCommand = "FORWARD";
      lastCommandTime = millis();
    } 
    else if (command == "BACKWARD") {
      moveBackward();
      currentCommand = "BACKWARD";
      lastCommandTime = millis();
    } 
    else if (command == "LEFT") {
      turnLeft();
      currentCommand = "LEFT";
      lastCommandTime = millis();
    } 
    else if (command == "RIGHT") {
      turnRight();
      currentCommand = "RIGHT";
      lastCommandTime = millis();
    } 
    else if (command == "STOP") {
      stopMotors();
      currentCommand = "STOP";
    }
  } else {
    Serial.println("Ignored - not in manual mode");
  }
}

void autoMode() {
  long distance = getDistance();
  
  if (distance > OBSTACLE_DISTANCE) {
    // Path is clear, move forward
    moveForward();
  } else {
    // Obstacle detected, STOP and GO BACKWARD FIRST
    stopMotors();
    delay(200);
    
    Serial.println("Obstacle detected! Reversing...");
    moveBackward();
    delay(500); // Reverse a bit
    stopMotors();
    delay(300);
    
    // Turn left and check
    Serial.println("Turning left to check...");
    turnLeft();
    delay(600);
    stopMotors();
    delay(300);
    
    long leftDistance = getDistance();
    Serial.print("Left distance: ");
    Serial.println(leftDistance);
    
    if (leftDistance > OBSTACLE_DISTANCE) {
      // Path is clear on left, continue
      Serial.println("Left path clear");
    } else {
      // Obstacle on left, turn right to check
      Serial.println("Obstacle on left, turning right...");
      turnRight();
      delay(1200); // Turn right (back to center + more)
      stopMotors();
      delay(300);
      
      long rightDistance = getDistance();
      Serial.print("Right distance: ");
      Serial.println(rightDistance);
      
      if (rightDistance <= OBSTACLE_DISTANCE) {
        // Both sides blocked, reverse more
        Serial.println("Both sides blocked, reversing more...");
        moveBackward();
        delay(700);
        stopMotors();
        delay(200);
        // Turn right to try different direction
        turnRight();
        delay(700);
      }
    }
    
    stopMotors();
    delay(200);
  }
}

long getDistance() {
  // Clear the trigger pin
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  
  // Send 10us pulse
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  
  // Read echo pin
  long duration = pulseIn(ECHO_PIN, HIGH, 30000); // 30ms timeout
  
  // Calculate distance in cm
  long distance = duration * 0.034 / 2;
  
  // Return valid distance or max value
  if (distance == 0) {
    return 400; // Max range
  }
  return distance;
}

void moveForward() {
  motorRearLeft.run(FORWARD);      // M2 - Call FIRST
  delayMicroseconds(50);
  motorFrontLeft.run(FORWARD);
  delayMicroseconds(50);
  motorFrontRight.run(FORWARD);
  delayMicroseconds(50);
  motorRearRight.run(FORWARD);
}

void moveBackward() {
  motorRearLeft.run(BACKWARD);     // M2 - Call FIRST
  delayMicroseconds(50);
  motorFrontLeft.run(BACKWARD);
  delayMicroseconds(50);
  motorFrontRight.run(BACKWARD);
  delayMicroseconds(50);
  motorRearRight.run(BACKWARD);
}

void turnLeft() {
  motorRearLeft.run(BACKWARD);     // M2 - Call FIRST
  delayMicroseconds(50);
  motorFrontLeft.run(BACKWARD);
  delayMicroseconds(50);
  motorFrontRight.run(FORWARD);
  delayMicroseconds(50);
  motorRearRight.run(FORWARD);
}

void turnRight() {
  motorRearLeft.run(FORWARD);      // M2 - Call FIRST
  delayMicroseconds(50);
  motorFrontLeft.run(FORWARD);
  delayMicroseconds(50);
  motorFrontRight.run(BACKWARD);
  delayMicroseconds(50);
  motorRearRight.run(BACKWARD);
}

void stopMotors() {
  motorRearLeft.run(RELEASE);      // M2 - Call FIRST
  delayMicroseconds(50);
  motorFrontLeft.run(RELEASE);
  delayMicroseconds(50);
  motorFrontRight.run(RELEASE);
  delayMicroseconds(50);
  motorRearRight.run(RELEASE);
}
