package com.example.anwender.empaticae4.EWS;

/*
 * Created by angel on 27/12/2017.
 */

import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothProfile;
import android.os.Handler;
import android.util.Log;

import com.example.anwender.empaticae4.Main.Utility;

import java.util.UUID;


class GattOxi {

    private Utility oxiUtility;
    private ConnectOximeter connectOxi;
    private Handler oxiHandler;

    private static final UUID OXIMETER_SERVICE_UUID = UUID.fromString("46A970E0-0D5F-11E2-8B5E-0002A5D5C51B");
    private static final UUID OXIMETER_CHARACTERISTIC_UUID = UUID.fromString("0AAD7EA0-0D60-11E2-8E3C-0002A5D5C51B");
    static boolean OxiIsConnected;

    private final BluetoothGattCallback oximGattback = new BluetoothGattCallback() {

        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            // this will get called when a device connects or disconnects
            if (status == BluetoothGatt.GATT_SUCCESS)
                Log.i("onConnectionStateChange", "GATT_SUCCESS");
            else
                Log.i("onConnectionStateChange", "GATT_FAILURE");
            switch (newState) {
                case BluetoothProfile.STATE_CONNECTED:
                    gatt.discoverServices();
                            ConnectOximeter.oxi_Name.setText(oxiUtility.getName());
                    break;
                case BluetoothProfile.STATE_DISCONNECTED:
                    oxiHandler.post(new Runnable(){
                        @Override
                        public void run(){
                            connectOxi.stopEverything();
                        }
                    });
                    break;
                default: {
                }
            }

        }

        @Override
        public void onServicesDiscovered(BluetoothGatt bGatt, int status) {
            // this will get called after the client initiates a BluetoothGatt.discoverServices() call
            Log.i("onServicesDiscovered", "" + status);
            BluetoothGattCharacteristic characteristic = bGatt.getService(OXIMETER_SERVICE_UUID).getCharacteristic(OXIMETER_CHARACTERISTIC_UUID);
            Log.i("characteristic found", characteristic.getUuid().toString());
            bGatt.setCharacteristicNotification(characteristic, true);
            for (BluetoothGattDescriptor descriptor : characteristic.getDescriptors()) {
                descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                bGatt.writeDescriptor(descriptor);
            }
            boolean valAv = bGatt.readCharacteristic(characteristic);
            if(!valAv){
                Log.e("onReadCharacteristic", "Read characteristic failed");
            }
        }

        @Override
        public void onCharacteristicRead(BluetoothGatt bGatt, BluetoothGattCharacteristic characteristic, int status) {
            final byte[] data = characteristic.getValue();
            if (data != null) {
                //if not, not enougth data
                if ((int)data[1] >= 9){
                    oxiHandler.post(new Runnable(){
                        @Override
                        public void run(){
                            connectOxi.updateData(data);
                        }
                    });
                }
                OxiIsConnected = true;
            }
            else{
                OxiIsConnected = false;
            }
        }

        @Override
        public void onCharacteristicChanged(BluetoothGatt bGatt, final BluetoothGattCharacteristic characteristic) {
            final byte[] data = characteristic.getValue();
            if (data != null) {
                oxiHandler.post(new Runnable(){
                    @Override
                    public void run(){
                        connectOxi.updateData(data);
                    }
                });
                OxiIsConnected = true;
            }
            else{
                OxiIsConnected = false;
            }
        }
    };

    GattOxi(ConnectOximeter connectOximeter, Utility oximeter){
        this.oxiUtility = oximeter;
        this.connectOxi = connectOximeter;
        this.oxiHandler = new Handler();
    }

    void execute(){
        oxiUtility.deviceOxi.connectGatt(connectOxi.getApplicationContext(), true, oximGattback);
    }
}
