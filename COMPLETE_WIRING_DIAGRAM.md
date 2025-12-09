# 🔌 ZARIF'S ROBOTIC CAR - Complete Wiring Diagram

## 📋 Components List

### Main Components:
1. **Arduino UNO** - Main controller
2. **L293D Motor Driver IC** - Controls 4 DC motors
3. **ESP8266 NodeMCU** - WiFi communication
4. **HC-SR04 Ultrasonic Sensor** - Obstacle detection
5. **SG90 Servo Motor** - Sensor rotation
6. **4x DC Motors** - Wheels
7. **9V Battery** - Power supply
8. **Switch** - Power on/off

---

## 🔴 ARDUINO UNO CONNECTIONS

```
ARDUINO UNO PIN LAYOUT:
┌─────────────────────────────────────┐
│  DIGITAL PINS          ANALOG PINS  │
│  ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐   │
│  │13│12│11│10│9 │8 │7 │6 │5 │4 │   │
│  └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘   │
│                                     │
│  ┌──┬──┬──┬──┬──┬──┬──┬──┐         │
│  │3 │2 │TX│RX│   │A0│A1│A2│...     │
│  └──┴──┴──┴──┘   └──┴──┴──┘         │
└─────────────────────────────────────┘
```

### Pin Assignments:

| Arduino Pin | Connected To | Function |
|-------------|--------------|----------|
| **Pin 0 (RX)** | ESP8266 TX (GPIO1) | Serial receive from ESP8266 |
| **Pin 1 (TX)** | ESP8266 RX (GPIO3) | Serial transmit to ESP8266 |
| **Pin 3** | Servo Signal | Servo motor control |
| **Pin 5** | L293D Pin 2 (Input 1) | Motor 1 control |
| **Pin 6** | L293D Pin 7 (Enable 1) | Motor 1/2 speed (PWM) |
| **Pin 9** | L293D Pin 10 (Input 3) | Motor 2 control |
| **Pin 10** | L293D Pin 15 (Enable 2) | Motor 3/4 speed (PWM) |
| **Pin 11** | HC-SR04 TRIG | Ultrasonic trigger |
| **Pin 12** | HC-SR04 ECHO | Ultrasonic echo |
| **5V** | Multiple | Power to sensors |
| **GND** | Multiple | Common ground |

---

## 🔷 L293D MOTOR DRIVER IC CONNECTIONS

```
L293D IC PIN LAYOUT (Top View):
        ┌────────────┐
Enable1 │1  ┌────┐ 16│ VCC (+5V)
Input1  │2  │L293│ 15│ Enable2
Output1 │3  │ D  │ 14│ Input4
GND     │4  │    │ 13│ Output4
GND     │5  │    │ 12│ GND
Output2 │6  │    │ 11│ Output3
Input2  │7  └────┘ 10│ Input3
VCC2    │8         9 │ Enable (unused)
        └────────────┘
```

### L293D Pin Connections:

| L293D Pin | Number | Connected To | Function |
|-----------|--------|--------------|----------|
| **Enable 1** | 1 | Arduino Pin 6 | Motor 1&2 speed control (PWM) |
| **Input 1** | 2 | Arduino Pin 5 | Motor 1 direction control |
| **Output 1** | 3 | Motor 1 Terminal A | Motor 1 output |
| **GND** | 4, 5, 12, 13 | Battery GND | Ground |
| **Output 2** | 6 | Motor 1 Terminal B | Motor 1 output |
| **Input 2** | 7 | Arduino Pin 9 | Motor 1 direction control |
| **VCC2 (Motor)** | 8 | Battery +9V | Motor power supply |
| **Input 3** | 10 | Arduino Pin 10 | Motor 2 direction control |
| **Output 3** | 11 | Motor 2 Terminal A | Motor 2 output |
| **Output 4** | 14 | Motor 2 Terminal B | Motor 2 output |
| **Input 4** | 15 | L293D Pin 15 (Enable 2) | Motor 2 direction control |
| **VCC (Logic)** | 16 | Arduino 5V | Logic power supply |

### Motor Connections to L293D:

```
LEFT SIDE MOTORS:
Motor 1 (Front Left):
  Terminal A → L293D Output 1 (Pin 3)
  Terminal B → L293D Output 2 (Pin 6)

Motor 2 (Rear Left):
  Terminal A → L293D Output 3 (Pin 11)
  Terminal B → L293D Output 4 (Pin 14)

RIGHT SIDE MOTORS:
Motor 3 (Front Right):
  Connect to second L293D IC (same pin pattern)
  OR parallel with Motor 1

Motor 4 (Rear Right):
  Connect to second L293D IC (same pin pattern)
  OR parallel with Motor 2
```

---

## 📡 ESP8266 NodeMCU CONNECTIONS

```
ESP8266 NodeMCU PIN LAYOUT:
┌─────────────────────────────┐
│  D0  D1  D2  D3  D4  D5...  │
│  TX  RX  ...                │
└─────────────────────────────┘
```

### ESP8266 Pin Connections:

| ESP8266 Pin | GPIO | Connected To | Function |
|-------------|------|--------------|----------|
| **TX** | GPIO1 | Arduino RX (Pin 0) | Send commands to Arduino |
| **RX** | GPIO3 | Arduino TX (Pin 1) | Receive status from Arduino |
| **GND** | - | Arduino GND | Common ground |
| **VIN/3.3V** | - | Battery +5V (via regulator) | Power supply |

### ⚠️ Important:
- ESP8266 works at **3.3V logic** but can be powered by 5V on VIN pin
- Use voltage divider on Arduino TX → ESP8266 RX if needed
- Or use logic level converter

---

## 🎯 HC-SR04 ULTRASONIC SENSOR

```
HC-SR04 Sensor:
┌──────────────────┐
│  VCC GND TRIG ECHO│
│   │   │   │    │  │
│  [●] [●] [●]  [●] │
└──────────────────┘
```

### Ultrasonic Connections:

| HC-SR04 Pin | Connected To | Function |
|-------------|--------------|----------|
| **VCC** | Arduino 5V | Power supply |
| **GND** | Arduino GND | Ground |
| **TRIG** | Arduino Pin 11 | Trigger pulse |
| **ECHO** | Arduino Pin 12 | Echo receive |

### Mounting:
- Mount on **Servo Motor** for 180° scanning
- Servo rotates sensor left (20°) and right (160°)

---

## 🔄 SG90 SERVO MOTOR

```
SG90 Servo Wires:
┌────────────────┐
│ RED  BRN  ORG  │
│  │    │    │   │
│ +5V  GND  SIG  │
└────────────────┘
```

### Servo Connections:

| Servo Wire | Color | Connected To | Function |
|------------|-------|--------------|----------|
| **Power** | Red | Arduino 5V | Power supply |
| **Ground** | Brown/Black | Arduino GND | Ground |
| **Signal** | Orange/Yellow | Arduino Pin 3 | PWM control |

### Function:
- Rotates ultrasonic sensor
- Scans left (20°) and right (160°)
- Center position: 90°

---

## 🔋 POWER SUPPLY CONNECTIONS

```
POWER DISTRIBUTION:
                    ┌─── Switch ───┐
9V Battery (+) ─────┤              ├──→ L293D VCC2 (Pin 8)
                    └──────────────┘
                           │
                           ├──→ Arduino VIN
                           │
                           └──→ ESP8266 VIN (via 5V regulator)

9V Battery (−) ──────────────────→ Common GND
```

### Power Connections:

| Component | Power Source | Voltage |
|-----------|--------------|---------|
| **Arduino UNO** | Battery via VIN | 9V → 5V regulated |
| **L293D Logic (Pin 16)** | Arduino 5V | 5V |
| **L293D Motors (Pin 8)** | Battery direct | 9V |
| **ESP8266** | Battery via regulator | 9V → 5V → 3.3V |
| **Servo** | Arduino 5V | 5V |
| **Ultrasonic** | Arduino 5V | 5V |

### ⚠️ Power Notes:
- Use **9V battery** or **7.4V LiPo** (2S)
- Add **switch** between battery and system
- **Capacitor (100µF)** across L293D power pins (optional but recommended)
- ESP8266 may need separate 5V regulator if battery voltage > 6V

---

## 📊 COMPLETE WIRING DIAGRAM

```
                    ┌─────────────────┐
                    │   9V BATTERY    │
                    └────┬────────┬───┘
                         │        │
                      Switch      │
                         │        │
                    ┌────▼────┐   │
                    │ Arduino │   │
                    │   UNO   │   │
                    └─────────┘   │
                         │        │
   ┌─────────────────────┼────────┼─────────────────────┐
   │                     │        │                     │
   │  Pin 0 (RX) ────────┼────────┼────── ESP8266 TX   │
   │  Pin 1 (TX) ────────┼────────┼────── ESP8266 RX   │
   │  Pin 3 ─────────────┼────────┼────── Servo Signal │
   │  Pin 5 ─────────────┼────────┼────── L293D Pin 2  │
   │  Pin 6 ─────────────┼────────┼────── L293D Pin 7  │
   │  Pin 9 ─────────────┼────────┼────── L293D Pin 10 │
   │  Pin 10 ────────────┼────────┼────── L293D Pin 15 │
   │  Pin 11 ────────────┼────────┼────── HC-SR04 TRIG │
   │  Pin 12 ────────────┼────────┼────── HC-SR04 ECHO │
   │  5V ────────────────┼────────┼────── Sensors VCC  │
   │  GND ───────────────┼────────┴────── Common GND   │
   └─────────────────────┼───────────────────────────┘
                         │
                    ┌────▼────┐
                    │  L293D  │───→ Motor 1 (Front Left)
                    │ Driver  │───→ Motor 2 (Rear Left)
                    │   IC    │───→ Motor 3 (Front Right)
                    └─────────┘───→ Motor 4 (Rear Right)
                         │
                    ┌────▼────────┐
                    │   Motors    │
                    │  (4x DC)    │
                    └─────────────┘
```

---

## 🎨 COLOR CODING GUIDE

Use this color scheme for organized wiring:

| Connection Type | Wire Color | Usage |
|-----------------|------------|-------|
| **Power (+)** | 🔴 Red | Battery +, VCC, 5V |
| **Ground (−)** | ⚫ Black | All ground connections |
| **Motor Control** | 🟡 Yellow | Arduino → L293D pins |
| **Signal** | 🟢 Green | Sensor signals |
| **Data** | 🔵 Blue | Serial communication |

---

## ✅ STEP-BY-STEP WIRING INSTRUCTIONS

### Step 1: Power Connections
1. Connect battery **positive (+)** to **switch**
2. Connect switch output to:
   - Arduino **VIN** pin
   - L293D **Pin 8** (VCC2)
3. Connect battery **negative (−)** to **common ground bus**
4. Connect Arduino **GND** to ground bus

### Step 2: L293D Motor Driver
1. Connect L293D **Pin 16** (VCC) to Arduino **5V**
2. Connect L293D **Pin 8** (VCC2) to battery **+9V**
3. Connect L293D **Pins 4, 5, 12, 13** (GND) to ground bus
4. Connect Arduino **Pin 5** → L293D **Pin 2** (Input1)
5. Connect Arduino **Pin 6** → L293D **Pin 1** (Enable1)
6. Connect Arduino **Pin 9** → L293D **Pin 7** (Input2)
7. Connect Arduino **Pin 10** → L293D **Pin 10** (Input3)
8. Connect L293D **Pin 15** (Enable2) to Arduino **5V**

### Step 3: DC Motors
1. Connect Motor 1:
   - Terminal A → L293D **Pin 3** (Output1)
   - Terminal B → L293D **Pin 6** (Output2)
2. Connect Motor 2:
   - Terminal A → L293D **Pin 11** (Output3)
   - Terminal B → L293D **Pin 14** (Output4)
3. Repeat for Motors 3 & 4 with second L293D (or parallel)

### Step 4: HC-SR04 Ultrasonic Sensor
1. Connect **VCC** → Arduino **5V**
2. Connect **GND** → Arduino **GND**
3. Connect **TRIG** → Arduino **Pin 11**
4. Connect **ECHO** → Arduino **Pin 12**

### Step 5: SG90 Servo Motor
1. Connect **Red wire** → Arduino **5V**
2. Connect **Brown wire** → Arduino **GND**
3. Connect **Orange wire** → Arduino **Pin 3**
4. Mount ultrasonic sensor on servo horn

### Step 6: ESP8266 NodeMCU
1. Connect ESP8266 **TX (GPIO1)** → Arduino **RX (Pin 0)**
2. Connect ESP8266 **RX (GPIO3)** → Arduino **TX (Pin 1)**
3. Connect ESP8266 **GND** → Arduino **GND**
4. Connect ESP8266 **VIN** → Battery **+9V** (via 5V regulator)

---

## 🧪 TESTING PROCEDURE

### 1. Visual Inspection
- ✅ Check all connections match diagram
- ✅ Verify polarity (+ and −)
- ✅ Ensure no short circuits
- ✅ Check motor connections are secure

### 2. Power Test (No Code)
- ✅ Turn on power switch
- ✅ Arduino power LED should light up
- ✅ ESP8266 blue LED should blink briefly
- ✅ No smoke or burning smell
- ✅ Measure voltages with multimeter

### 3. Upload Arduino Code
- ✅ Disconnect ESP8266 TX/RX temporarily
- ✅ Upload `arduino_car.ino`
- ✅ Reconnect ESP8266

### 4. Upload ESP8266 Code
- ✅ Disconnect Arduino TX/RX temporarily
- ✅ Upload `esp8266_wifi.ino`
- ✅ Reconnect Arduino

### 5. Component Tests
- ✅ Servo sweeps on startup
- ✅ Motors respond to commands
- ✅ Ultrasonic reads distance
- ✅ WiFi hotspot "Zarifs Car" appears

### 6. Full System Test
- ✅ Connect phone to "Zarifs Car" WiFi
- ✅ Open Flutter app
- ✅ Test AUTO mode
- ✅ Test MANUAL mode controls

---

## ⚠️ TROUBLESHOOTING

### Motors Not Moving:
- Check L293D power connections (Pins 8 and 16)
- Verify motor wires are connected
- Test motors with direct battery connection
- Check Arduino PWM pins (5, 6, 9, 10)

### Servo Not Moving:
- Check power (5V and GND)
- Verify signal wire on Pin 3
- Test with simple servo sweep code

### Ultrasonic Not Working:
- Check TRIG on Pin 11, ECHO on Pin 12
- Verify 5V and GND connections
- Measure distance with Serial Monitor

### ESP8266 Not Connecting:
- Check TX/RX connections (crossed)
- Verify GND connection
- Test WiFi hotspot without Arduino
- Check baud rate (9600)

### App Can't Connect:
- Ensure phone connected to "Zarifs Car" WiFi
- Ping 192.168.4.1 from phone
- Check ESP8266 power LED
- Restart ESP8266

---

## 📝 BILL OF MATERIALS (BOM)

| Component | Quantity | Specifications |
|-----------|----------|----------------|
| Arduino UNO | 1 | ATmega328P |
| L293D Motor Driver | 2 | 4-channel H-bridge |
| ESP8266 NodeMCU | 1 | WiFi module |
| HC-SR04 Ultrasonic | 1 | Distance sensor |
| SG90 Servo Motor | 1 | 180° rotation |
| DC Motors | 4 | 3-6V |
| 9V Battery | 1 | Or 7.4V LiPo 2S |
| Switch | 1 | SPST toggle |
| Jumper Wires | 40+ | Male-Male, Male-Female |
| Breadboard (optional) | 1 | 830 points |
| Battery Holder | 1 | 9V snap connector |
| Robot Chassis | 1 | 4WD car kit |

---

## 🎓 CODE REFERENCES

### Arduino Code: `arduino_car.ino`
- Motor control functions
- Ultrasonic distance measurement
- Servo scanning logic
- Serial communication with ESP8266
- AUTO/MANUAL mode switching

### ESP8266 Code: `esp8266_wifi.ino`
- WiFi Access Point setup
- Web server (192.168.4.1)
- REST API endpoints
- Serial bridge to Arduino

### Flutter App: `FlutterApp/`
- User interface
- WiFi connectivity
- Control buttons
- Status display

---

## 📸 FINAL ASSEMBLY

```
Top View of Robotic Car:
        ┌─────────────────┐
        │  Ultrasonic     │ (on servo)
        │   Sensor        │
        └─────────────────┘
              │
        ┌─────┴─────┐
        │  Servo    │
        └───────────┘
              │
        ┌─────┴─────┐
        │  Arduino  │
        │    UNO    │
        └───────────┘
              │
        ┌─────┴─────┐
        │  ESP8266  │
        └───────────┘
              │
    ┌─────────┴─────────┐
    │     L293D         │
    │  Motor Driver     │
    └───────────────────┘
         │   │   │   │
      [M1][M2][M3][M4]  ← Motors
```

---

## ✨ PROJECT COMPLETE!

Your Zarif's Robotic Car is now fully wired and ready to roll! 🚗💨

**Next Steps:**
1. Double-check all connections
2. Upload both codes (Arduino & ESP8266)
3. Install Flutter app on phone
4. Connect to "Zarifs Car" WiFi
5. Test AUTO and MANUAL modes
6. Have fun! 🎉

---

**Created by:** GitHub Copilot
**Project:** Zarif's Robotic Car
**Date:** December 6, 2025
