package com.zarifscar.controller;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Set;
import java.util.UUID;

public class MainActivity extends AppCompatActivity {

    private static final UUID BT_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
    private static final int REQUEST_ENABLE_BT = 1;
    private static final int REQUEST_BT_PERMISSIONS = 2;
    
    private BluetoothAdapter bluetoothAdapter;
    private BluetoothSocket bluetoothSocket;
    private OutputStream outputStream;
    private boolean isConnected = false;
    
    private Switch modeSwitch;
    private Button btnForward, btnBackward, btnLeft, btnRight, btnConnect;
    private TextView tvStatus, tvTitle;
    private ImageView ivCar;
    private View manualControlPanel;
    
    private Handler handler;
    private Handler commandHandler;
    private Runnable commandRunnable;
    
    private boolean isManualMode = false;
    private boolean isSendingCommand = false;
    private String currentCommand = "STOP";
    
    private ObjectAnimator carAnimator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Initialize Bluetooth
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (bluetoothAdapter == null) {
            Toast.makeText(this, "Device doesn't support Bluetooth", Toast.LENGTH_LONG).show();
            finish();
            return;
        }
        
        // Initialize views
        initViews();
        
        // Initialize handlers
        handler = new Handler(Looper.getMainLooper());
        commandHandler = new Handler(Looper.getMainLooper());
        
        // Setup listeners
        setupListeners();
        
        // Start title animation
        startTitleAnimation();
        
        // Check Bluetooth permissions
        checkBluetoothPermissions();
    }
    
    private void initViews() {
        tvTitle = findViewById(R.id.tvTitle);
        modeSwitch = findViewById(R.id.modeSwitch);
        btnForward = findViewById(R.id.btnForward);
        btnBackward = findViewById(R.id.btnBackward);
        btnLeft = findViewById(R.id.btnLeft);
        btnRight = findViewById(R.id.btnRight);
        btnConnect = findViewById(R.id.btnConnect);
        tvStatus = findViewById(R.id.tvStatus);
        ivCar = findViewById(R.id.ivCar);
        manualControlPanel = findViewById(R.id.manualControlPanel);
        
        // Initially hide manual controls
        manualControlPanel.setVisibility(View.GONE);
        tvStatus.setText("Status: Not Connected");
    }
    
    private void checkBluetoothPermissions() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) 
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.BLUETOOTH_CONNECT, 
                                Manifest.permission.BLUETOOTH_SCAN},
                    REQUEST_BT_PERMISSIONS);
        } else {
            enableBluetooth();
        }
    }
    
    private void enableBluetooth() {
        if (!bluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) 
                    == PackageManager.PERMISSION_GRANTED) {
                startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
            }
        }
    }
    
    private void showDeviceList() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) 
                != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, "Bluetooth permission required", Toast.LENGTH_SHORT).show();
            return;
        }
        
        Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();
        ArrayList<String> deviceList = new ArrayList<>();
        final ArrayList<BluetoothDevice> devices = new ArrayList<>();
        
        for (BluetoothDevice device : pairedDevices) {
            deviceList.add(device.getName() + "\n" + device.getAddress());
            devices.add(device);
        }
        
        if (deviceList.isEmpty()) {
            Toast.makeText(this, "No paired devices. Pair with HC-05 in Bluetooth settings.", 
                    Toast.LENGTH_LONG).show();
            return;
        }
        
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Select Bluetooth Device");
        
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, 
                android.R.layout.simple_list_item_1, deviceList);
        
        builder.setAdapter(adapter, (dialog, which) -> {
            BluetoothDevice device = devices.get(which);
            connectToDevice(device);
        });
        
        builder.setNegativeButton("Cancel", null);
        builder.show();
    }
    
    private void connectToDevice(BluetoothDevice device) {
        new Thread(() -> {
            try {
                if (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) 
                        != PackageManager.PERMISSION_GRANTED) {
                    return;
                }
                
                bluetoothSocket = device.createRfcommSocketToServiceRecord(BT_UUID);
                bluetoothSocket.connect();
                outputStream = bluetoothSocket.getOutputStream();
                isConnected = true;
                
                runOnUiThread(() -> {
                    tvStatus.setText("Connected to " + device.getName());
                    btnConnect.setText("Disconnect");
                    Toast.makeText(this, "Connected successfully!", Toast.LENGTH_SHORT).show();
                });
                
            } catch (IOException e) {
                isConnected = false;
                runOnUiThread(() -> {
                    tvStatus.setText("Connection failed");
                    Toast.makeText(this, "Failed to connect: " + e.getMessage(), 
                            Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }
    
    private void disconnect() {
        try {
            if (bluetoothSocket != null) {
                bluetoothSocket.close();
            }
            if (outputStream != null) {
                outputStream.close();
            }
            isConnected = false;
            tvStatus.setText("Disconnected");
            btnConnect.setText("Connect");
            Toast.makeText(this, "Disconnected", Toast.LENGTH_SHORT).show();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private void setupListeners() {
        // Connect button listener
        btnConnect.setOnClickListener(v -> {
            if (isConnected) {
                disconnect();
            } else {
                showDeviceList();
            }
        });
        
        // Mode switch listener
        modeSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (!isConnected) {
                buttonView.setChecked(false);
                Toast.makeText(this, "Please connect to device first", Toast.LENGTH_SHORT).show();
                return;
            }
            
            if (isChecked) {
                switchToManualMode();
            } else {
                switchToAutoMode();
            }
        });
        
        // Forward button - continuous while pressed
        btnForward.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("FORWARD");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
        
        // Backward button - continuous while pressed
        btnBackward.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("BACKWARD");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
        
        // Left button - continuous while pressed
        btnLeft.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("LEFT");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
        
        // Right button - continuous while pressed
        btnRight.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("RIGHT");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
    }
    
    private void startTitleAnimation() {
        // Animate title with fade and scale
        ObjectAnimator fadeAnimator = ObjectAnimator.ofFloat(tvTitle, "alpha", 0.5f, 1.0f);
        fadeAnimator.setDuration(1500);
        fadeAnimator.setRepeatCount(ValueAnimator.INFINITE);
        fadeAnimator.setRepeatMode(ValueAnimator.REVERSE);
        fadeAnimator.start();
        
        // Animate car image rotation
        carAnimator = ObjectAnimator.ofFloat(ivCar, "rotation", -5f, 5f);
        carAnimator.setDuration(2000);
        carAnimator.setRepeatCount(ValueAnimator.INFINITE);
        carAnimator.setRepeatMode(ValueAnimator.REVERSE);
        carAnimator.start();
    }
    
    private void switchToManualMode() {
        sendBluetoothCommand("MODE:MANUAL");
        isManualMode = true;
        manualControlPanel.setVisibility(View.VISIBLE);
        tvStatus.setText("Mode: MANUAL");
        Toast.makeText(this, "Manual mode activated", Toast.LENGTH_SHORT).show();
    }
    
    private void switchToAutoMode() {
        sendBluetoothCommand("MODE:AUTO");
        isManualMode = false;
        manualControlPanel.setVisibility(View.GONE);
        tvStatus.setText("Mode: AUTO");
        stopContinuousCommand();
        Toast.makeText(this, "Auto mode activated", Toast.LENGTH_SHORT).show();
    }
    
    private void startContinuousCommand(String command) {
        currentCommand = command;
        isSendingCommand = true;
        
        commandRunnable = new Runnable() {
            @Override
            public void run() {
                if (isSendingCommand && isManualMode) {
                    sendBluetoothCommand(currentCommand);
                    commandHandler.postDelayed(this, 50); // Send every 50ms
                }
            }
        };
        
        commandHandler.post(commandRunnable);
    }
    
    private void stopContinuousCommand() {
        isSendingCommand = false;
        if (commandRunnable != null) {
            commandHandler.removeCallbacks(commandRunnable);
        }
        sendBluetoothCommand("STOP");
    }
    
    private void sendBluetoothCommand(String command) {
        if (!isConnected || outputStream == null) {
            return;
        }
        
        new Thread(() -> {
            try {
                outputStream.write((command + "\n").getBytes());
                outputStream.flush();
            } catch (IOException e) {
                runOnUiThread(() -> {
                    Toast.makeText(this, "Failed to send command", Toast.LENGTH_SHORT).show();
                    isConnected = false;
                    tvStatus.setText("Connection lost");
                });
            }
        }).start();
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (commandHandler != null && commandRunnable != null) {
            commandHandler.removeCallbacks(commandRunnable);
        }
        if (carAnimator != null) {
            carAnimator.cancel();
        }
        disconnect();
    }
}
