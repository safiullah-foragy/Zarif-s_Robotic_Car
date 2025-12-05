# Zarif's Robotic Car - Complete Setup Guide

## 🚗 Project Overview
An obstacle-avoiding robotic car with manual control via Android app over WiFi hotspot.

## 📋 Components Required

### Hardware:
1. **Arduino UNO** (1x)
2. **ESP8266 NodeMCU** (1x)
3. **L293D Motor Driver IC** (1x)
4. **HC-SR04 Ultrasonic Sensor** (1x)
5. **SG90 Servo Motor** (1x)
6. **DC Motors** (2x) - for left and right wheels
7. **Robot Car Chassis** with wheels
8. **Battery Pack** (7.4V - 12V for motors)
9. **5V Power Supply** (for Arduino and ESP8266)
10. **Jumper Wires** (Male-to-Male, Male-to-Female)
11. **Breadboard** (optional, for prototyping)

---

## 🔌 Complete Wiring Diagram

### Arduino UNO Pin Connections:

#### L293D Motor Driver:
```
L293D Pin 1 (Enable 1)      -> 5V (Always enabled)
L293D Pin 2 (IN1)           -> Arduino Pin 5
L293D Pin 7 (IN2)           -> Arduino Pin 6
L293D Pin 10 (IN3)          -> Arduino Pin 9
L293D Pin 15 (IN4)          -> Arduino Pin 10
L293D Pin 16 (Vcc)          -> 5V
L293D Pin 8 (Motor Power)   -> Battery + (7.4V-12V)
L293D Pin 9 (Enable 2)      -> 5V (Always enabled)
L293D Pin 4,5,12,13 (GND)   -> Common Ground

Motor A (Left):
L293D Pin 3                 -> Left Motor +
L293D Pin 6                 -> Left Motor -

Motor B (Right):
L293D Pin 11                -> Right Motor +
L293D Pin 14                -> Right Motor -
```

#### HC-SR04 Ultrasonic Sensor:
```
VCC     -> Arduino 5V
TRIG    -> Arduino Pin 12
ECHO    -> Arduino Pin 11
GND     -> Arduino GND
```

#### SG90 Servo Motor:
```
Red (VCC)       -> Arduino 5V
Brown (GND)     -> Arduino GND
Orange (Signal) -> Arduino Pin 3
```

#### ESP8266 NodeMCU:
```
ESP8266 TX (GPIO1)  -> Arduino RX (Pin 0)
ESP8266 RX (GPIO3)  -> Arduino TX (Pin 1)
ESP8266 GND         -> Common Ground
ESP8266 VIN         -> 5V Power Supply
```

### Power Supply:
```
Battery Pack (7.4V-12V):
    (+) -> L293D Motor Power (Pin 8)
    (-) -> Common Ground

5V Regulator or USB:
    (+) -> Arduino 5V, ESP8266 VIN
    (-) -> Common Ground

Important: All grounds must be connected together!
```

---

## 📐 Pin Configuration Summary

### Arduino UNO:
| Pin | Connection | Function |
|-----|------------|----------|
| 0 | ESP8266 TX | Serial RX |
| 1 | ESP8266 RX | Serial TX |
| 3 | Servo Signal | Servo Control |
| 5 | L293D IN1 | Motor A Forward |
| 6 | L293D IN2 | Motor A Backward |
| 9 | L293D IN3 | Motor B Forward |
| 10 | L293D IN4 | Motor B Backward |
| 11 | HC-SR04 ECHO | Ultrasonic Echo |
| 12 | HC-SR04 TRIG | Ultrasonic Trigger |
| 5V | Power Rails | Power Supply |
| GND | Common Ground | Ground |

### ESP8266 NodeMCU:
| Pin | Connection | Function |
|-----|------------|----------|
| GPIO1 (TX) | Arduino Pin 0 | Serial TX |
| GPIO3 (RX) | Arduino Pin 1 | Serial RX |
| VIN | 5V Supply | Power |
| GND | Common Ground | Ground |

---

## 💻 Software Setup

### 1. Arduino IDE Setup:
1. Install Arduino IDE from [arduino.cc](https://www.arduino.cc/en/software)
2. Install ESP8266 Board Support:
   - Go to File → Preferences
   - Add to Additional Board URLs: `http://arduino.esp8266.com/stable/package_esp8266com_index.json`
   - Go to Tools → Board → Boards Manager
   - Search "ESP8266" and install

3. Install Required Libraries:
   - **Servo.h** (Built-in with Arduino IDE)
   - **ESP8266WiFi.h** (Included with ESP8266 board package)
   - **ESP8266WebServer.h** (Included with ESP8266 board package)

### 2. Upload Arduino Code:
1. Open `arduino_car.ino` in Arduino IDE
2. Select Board: **Arduino UNO**
3. Select correct COM Port
4. **IMPORTANT:** Disconnect ESP8266 TX/RX from Arduino Pins 0 & 1 before uploading
5. Click Upload
6. Reconnect ESP8266 TX/RX after upload

### 3. Upload ESP8266 Code:
1. Open `esp8266_wifi.ino` in Arduino IDE
2. Select Board: **NodeMCU 1.0 (ESP-12E Module)**
3. Select correct COM Port
4. Click Upload

### 4. Android App Setup:
1. Open Android Studio
2. Create new project and copy files from `AndroidApp` folder:
   - `MainActivity.java` → `app/src/main/java/com/zarifscar/controller/`
   - `activity_main.xml` → `app/src/main/res/layout/`
   - `AndroidManifest.xml` → `app/src/main/`
   - All drawable files → `app/src/main/res/drawable/`
   - All values files → `app/src/main/res/values/`
   - `build.gradle` → `app/`

3. Sync Gradle files
4. Build APK: Build → Build Bundle(s)/APK(s) → Build APK(s)
5. Install APK on Android device

---

## 🎮 How to Use

### Initial Setup:
1. Power on the robotic car
2. ESP8266 will create WiFi hotspot:
   - **SSID:** Zarifs Car
   - **Password:** 12344321

### Connecting:
1. On your Android phone, connect to "Zarifs Car" WiFi
2. Open the Zarif's Car app
3. The car starts in **AUTO MODE** (obstacle avoidance)

### Auto Mode:
- Car automatically avoids obstacles using ultrasonic sensor
- Scans left and right when obstacle detected
- Makes intelligent turning decisions

### Manual Mode:
1. Toggle the **Manual Mode** switch in the app
2. Use 4 directional buttons:
   - **↑ FORWARD:** Move forward (hold to continue)
   - **↓ BACKWARD:** Move backward (hold to continue)
   - **← LEFT:** Rotate left (hold to continue)
   - **→ RIGHT:** Rotate right (hold to continue)
3. Release button to stop movement

### Auto-Timeout:
- After **5 minutes** of inactivity in Manual Mode, the car automatically switches back to Auto Mode
- You'll see a timer countdown in the app
- Simply toggle Manual Mode again to resume control

---

## 🔧 Troubleshooting

### Car doesn't move:
- Check all motor connections to L293D
- Verify battery has sufficient charge
- Ensure L293D Enable pins are connected to 5V

### WiFi connection fails:
- Check ESP8266 power supply (needs stable 5V)
- Verify ESP8266 code uploaded successfully
- Check serial connections between Arduino and ESP8266

### Ultrasonic sensor not working:
- Verify TRIG and ECHO pin connections
- Ensure sensor has 5V power
- Check if servo is mounted properly (may block sensor)

### App can't connect:
- Ensure phone is connected to "Zarifs Car" WiFi
- Verify IP address in app is 192.168.4.1
- Check ESP8266 is powered and running

### Motors move erratically:
- Check all L293D input pins are connected correctly
- Verify common ground between Arduino, ESP8266, and battery
- Ensure motor power supply is adequate (7.4V-12V)

---

## 📱 Android App Features

✅ Animated title "ZARIF'S CAR"
✅ Animated car icon
✅ Real-time mode display (AUTO/MANUAL)
✅ Touch-and-hold control buttons
✅ 5-minute timeout countdown
✅ Automatic mode switching
✅ WiFi connection info display
✅ Beautiful gradient UI with rounded buttons

---

## 🎯 Technical Specifications

- **Control Range:** WiFi hotspot range (~30 meters)
- **Obstacle Detection:** 20 cm threshold
- **Ultrasonic Range:** 2 cm - 400 cm
- **Servo Scan Angles:** 20°, 90°, 160°
- **Command Update Rate:** 50ms (20 Hz)
- **Manual Mode Timeout:** 5 minutes
- **Power Requirements:** 
  - Motors: 7.4V - 12V
  - Electronics: 5V

---

## 📝 Notes

1. **Serial Communication:** Arduino uses pins 0 and 1 for communication with ESP8266. Disconnect these during Arduino code upload.

2. **Common Ground:** All components must share a common ground connection for proper operation.

3. **Power Supply:** Use separate power supplies or a regulated power system to avoid voltage drops affecting ESP8266.

4. **Motor Direction:** If motors rotate in wrong direction, swap the motor wire connections on L293D.

5. **Servo Mounting:** Mount servo on front of car with ultrasonic sensor attached to servo horn for scanning.

---

## 🚀 Future Enhancements

- Add speed control with PWM
- Implement FPV camera streaming
- Add LED indicators for status
- Include battery level monitoring
- Add voice control integration
- Implement path recording and playback

---

## 📄 License
This project is open-source and free to use for educational purposes.

## 👨‍💻 Created By
Zarif - Robotic Car Controller System

Enjoy your obstacle-avoiding robotic car! 🚗💨
