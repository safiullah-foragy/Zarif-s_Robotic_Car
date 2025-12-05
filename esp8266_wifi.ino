/*
 * Zarif's Robotic Car - ESP8266 NodeMCU Code
 * WiFi Hotspot and Communication Bridge
 * 
 * Pin Connections:
 * ESP8266 NodeMCU:
 * - TX (GPIO1) -> Arduino RX (Pin 0)
 * - RX (GPIO3) -> Arduino TX (Pin 1)
 * - GND -> Arduino GND
 * 
 * WiFi Hotspot:
 * - SSID: Zarifs Car
 * - Password: 12344321
 * - IP: 192.168.4.1
 */

#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

// WiFi credentials
const char* ssid = "Zarifs Car";
const char* password = "12344321";

// Web server on port 80
ESP8266WebServer server(80);

// Control mode and timing
bool manualMode = false;
unsigned long lastManualActivityTime = 0;
const unsigned long MANUAL_TIMEOUT = 300000; // 5 minutes in milliseconds

void setup() {
  // Initialize serial communication
  Serial.begin(9600);
  
  // Wait for serial to initialize
  delay(100);
  
  // Configure WiFi as Access Point
  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid, password);
  
  // Get IP address
  IPAddress IP = WiFi.softAPIP();
  
  // Setup web server routes
  server.on("/", HTTP_GET, handleRoot);
  server.on("/mode", HTTP_POST, handleMode);
  server.on("/control", HTTP_POST, handleControl);
  server.on("/status", HTTP_GET, handleStatus);
  server.enableCORS(true);
  
  // Start server
  server.begin();
  
  // Send initial mode to Arduino
  Serial.println("MODE:AUTO");
}

void loop() {
  // Handle client requests
  server.handleClient();
  
  // Check manual mode timeout (5 minutes)
  if (manualMode && (millis() - lastManualActivityTime > MANUAL_TIMEOUT)) {
    // Auto-switch to AUTO mode after 5 minutes of inactivity
    manualMode = false;
    Serial.println("MODE:AUTO");
  }
}

void handleRoot() {
  String html = "<!DOCTYPE html><html><head>";
  html += "<meta name='viewport' content='width=device-width, initial-scale=1.0'>";
  html += "<title>Zarif's Car</title></head><body>";
  html += "<h1>Zarif's Robotic Car Control</h1>";
  html += "<p>WiFi: " + String(ssid) + "</p>";
  html += "<p>IP: 192.168.4.1</p>";
  html += "<p>Connect via Android App</p>";
  html += "</body></html>";
  
  server.send(200, "text/html", html);
}

void handleMode() {
  if (server.hasArg("mode")) {
    String mode = server.arg("mode");
    
    if (mode == "AUTO") {
      manualMode = false;
      Serial.println("MODE:AUTO");
      server.send(200, "text/plain", "OK:AUTO");
    } 
    else if (mode == "MANUAL") {
      manualMode = true;
      lastManualActivityTime = millis();
      Serial.println("MODE:MANUAL");
      server.send(200, "text/plain", "OK:MANUAL");
    } 
    else {
      server.send(400, "text/plain", "Invalid mode");
    }
  } else {
    server.send(400, "text/plain", "Missing mode parameter");
  }
}

void handleControl() {
  if (!manualMode) {
    server.send(403, "text/plain", "Manual mode not active");
    return;
  }
  
  if (server.hasArg("command")) {
    String command = server.arg("command");
    lastManualActivityTime = millis(); // Reset timeout
    
    if (command == "FORWARD" || command == "BACKWARD" || 
        command == "LEFT" || command == "RIGHT" || command == "STOP") {
      Serial.println(command);
      server.send(200, "text/plain", "OK");
    } else {
      server.send(400, "text/plain", "Invalid command");
    }
  } else {
    server.send(400, "text/plain", "Missing command parameter");
  }
}

void handleStatus() {
  String status = "{";
  status += "\"mode\":\"" + String(manualMode ? "MANUAL" : "AUTO") + "\",";
  status += "\"clients\":" + String(WiFi.softAPgetStationNum()) + ",";
  
  if (manualMode) {
    unsigned long remainingTime = MANUAL_TIMEOUT - (millis() - lastManualActivityTime);
    status += "\"timeout\":" + String(remainingTime / 1000);
  } else {
    status += "\"timeout\":0";
  }
  
  status += "}";
  
  server.send(200, "application/json", status);
}
