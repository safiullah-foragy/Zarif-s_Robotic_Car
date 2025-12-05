/*
 * Zarif's Robotic Car - Arduino Code
 * L293D Motor Driver Control with Obstacle Avoidance
 * 
 * Pin Connections:
 * L293D Motor Driver:
 * - IN1 (Motor A) -> Pin 5
 * - IN2 (Motor A) -> Pin 6
 * - IN3 (Motor B) -> Pin 9
 * - IN4 (Motor B) -> Pin 10
 * 
 * Ultrasonic Sensor:
 * - TRIG -> Pin 12
 * - ECHO -> Pin 11
 * 
 * Servo Motor:
 * - Signal -> Pin 3
 * 
 * Communication with ESP8266:
 * - RX -> Pin 0 (ESP8266 TX)
 * - TX -> Pin 1 (ESP8266 RX)
 */

#include <Servo.h>

// Motor pins
#define MOTOR_A_IN1 5
#define MOTOR_A_IN2 6
#define MOTOR_B_IN3 9
#define MOTOR_B_IN4 10

// Ultrasonic sensor pins
#define TRIG_PIN 12
#define ECHO_PIN 11

// Servo pin
#define SERVO_PIN 3

// Distance threshold (in cm)
#define OBSTACLE_DISTANCE 20

Servo myServo;

// Control mode
bool manualMode = false;
String currentCommand = "STOP";
unsigned long lastCommandTime = 0;
const unsigned long COMMAND_TIMEOUT = 100; // 100ms timeout for continuous commands

void setup() {
  // Initialize serial communication with ESP8266
  Serial.begin(9600);
  
  // Initialize motor pins
  pinMode(MOTOR_A_IN1, OUTPUT);
  pinMode(MOTOR_A_IN2, OUTPUT);
  pinMode(MOTOR_B_IN3, OUTPUT);
  pinMode(MOTOR_B_IN4, OUTPUT);
  
  // Initialize ultrasonic sensor pins
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  
  // Initialize servo
  myServo.attach(SERVO_PIN);
  myServo.write(90); // Center position
  
  // Initial stop
  stopMotors();
  
  delay(1000);
}

void loop() {
  // Check for commands from ESP8266
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n');
    command.trim();
    processCommand(command);
  }
  
  // Check for command timeout in manual mode
  if (manualMode && (millis() - lastCommandTime > COMMAND_TIMEOUT)) {
    if (currentCommand == "FORWARD" || currentCommand == "BACKWARD" || 
        currentCommand == "LEFT" || currentCommand == "RIGHT") {
      stopMotors();
      currentCommand = "STOP";
    }
  }
  
  // Auto mode: obstacle avoidance
  if (!manualMode) {
    autoMode();
  }
}

void processCommand(String command) {
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
  }
}

void autoMode() {
  long distance = getDistance();
  
  if (distance > OBSTACLE_DISTANCE) {
    // Path is clear, move forward
    moveForward();
  } else {
    // Obstacle detected, stop and scan
    stopMotors();
    delay(300);
    
    // Scan left
    myServo.write(160);
    delay(500);
    long leftDistance = getDistance();
    
    // Scan right
    myServo.write(20);
    delay(500);
    long rightDistance = getDistance();
    
    // Return to center
    myServo.write(90);
    delay(300);
    
    // Decide direction
    if (leftDistance > rightDistance && leftDistance > OBSTACLE_DISTANCE) {
      // Turn left
      turnLeft();
      delay(600);
    } else if (rightDistance > OBSTACLE_DISTANCE) {
      // Turn right
      turnRight();
      delay(600);
    } else {
      // Both sides blocked, reverse and turn
      moveBackward();
      delay(500);
      turnRight();
      delay(700);
    }
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
  digitalWrite(MOTOR_A_IN1, HIGH);
  digitalWrite(MOTOR_A_IN2, LOW);
  digitalWrite(MOTOR_B_IN3, HIGH);
  digitalWrite(MOTOR_B_IN4, LOW);
}

void moveBackward() {
  digitalWrite(MOTOR_A_IN1, LOW);
  digitalWrite(MOTOR_A_IN2, HIGH);
  digitalWrite(MOTOR_B_IN3, LOW);
  digitalWrite(MOTOR_B_IN4, HIGH);
}

void turnLeft() {
  digitalWrite(MOTOR_A_IN1, LOW);
  digitalWrite(MOTOR_A_IN2, HIGH);
  digitalWrite(MOTOR_B_IN3, HIGH);
  digitalWrite(MOTOR_B_IN4, LOW);
}

void turnRight() {
  digitalWrite(MOTOR_A_IN1, HIGH);
  digitalWrite(MOTOR_A_IN2, LOW);
  digitalWrite(MOTOR_B_IN3, LOW);
  digitalWrite(MOTOR_B_IN4, HIGH);
}

void stopMotors() {
  digitalWrite(MOTOR_A_IN1, LOW);
  digitalWrite(MOTOR_A_IN2, LOW);
  digitalWrite(MOTOR_B_IN3, LOW);
  digitalWrite(MOTOR_B_IN4, LOW);
}
