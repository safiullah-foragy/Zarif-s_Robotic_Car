/*
 * Ultrasonic Sensor Test
 * Use this to verify your HC-SR04 is working
 * 
 * Wiring:
 * VCC -> 5V
 * GND -> GND
 * TRIG -> Pin 2
 * ECHO -> Pin 3
 */

#define TRIG_PIN 2
#define ECHO_PIN 3

void setup() {
  Serial.begin(9600);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  
  Serial.println("Ultrasonic Sensor Test");
  Serial.println("Wave your hand in front of sensor...");
  delay(2000);
}

void loop() {
  // Clear trigger
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  
  // Send 10us pulse
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  
  // Read echo with timeout
  long duration = pulseIn(ECHO_PIN, HIGH, 30000);
  
  // Calculate distance
  long distance = duration * 0.034 / 2;
  
  // Print results
  Serial.print("Duration: ");
  Serial.print(duration);
  Serial.print(" us | Distance: ");
  
  if (duration == 0) {
    Serial.println("NO ECHO - Check wiring!");
  } else {
    Serial.print(distance);
    Serial.println(" cm");
  }
  
  delay(500);
}
