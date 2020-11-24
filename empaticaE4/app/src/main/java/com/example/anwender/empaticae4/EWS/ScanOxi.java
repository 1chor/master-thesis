package com.example.anwender.empaticae4.EWS;

/*
 * Created by angel on 27/12/2017.
 */

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.os.Handler;

import com.example.anwender.empaticae4.Main.Utility;

import java.util.ArrayList;
import java.util.Calendar;

public class ScanOxi {

    private ConnectOximeter connectOximeter;

    private BluetoothAdapter mBluetoothAdapter;
    private boolean mScanning;
    private Handler mHandler;
    private Utility oximeter;
    private GattOxi oximeterGatt;

    private long scanPeriod;
    private int signalStrength;

    ScanOxi(ConnectOximeter connectOximeter1, long scanPeriod, int signalStrength){
        connectOximeter = connectOximeter1;

        mHandler = new Handler();

        this.scanPeriod = scanPeriod;
        this.signalStrength = signalStrength;

        final BluetoothManager bluetoothManager =
                (BluetoothManager) connectOximeter.getSystemService(Context.BLUETOOTH_SERVICE);

        assert bluetoothManager != null;
        mBluetoothAdapter = bluetoothManager.getAdapter();
    }

    boolean isScanning(){
        return mScanning;
    }

    public void start(){
        if(!Utility.checkBluetooth(mBluetoothAdapter)){
            Utility.requestUserBluetooth(connectOximeter);
            stop();
        }
        else{
            scanNonin(true);
        }
    }

    void stop(){
        scanNonin(false);
    }

    private void scanNonin(final boolean enable){
        if(enable && !mScanning) {
            mHandler.postDelayed(new Runnable(){
                @Override
                public void run(){
                    mScanning = false;
                    mBluetoothAdapter.stopLeScan(mLeScanCallback);
                    stop();
                }
            }, scanPeriod);

            mScanning = true;
            mBluetoothAdapter.startLeScan(mLeScanCallback);
        }
    }
    static ArrayList<String> dateStart = new ArrayList<>();


    private BluetoothAdapter.LeScanCallback mLeScanCallback =
            new BluetoothAdapter.LeScanCallback(){
                @Override
                public void onLeScan(final BluetoothDevice device, int rssi, byte[] scanRecord){
                    String deviceName = device.getName();
                    if(rssi > signalStrength && deviceName != null && deviceName.contains("Nonin3230")){
                        mHandler.post(new Runnable(){
                            @Override
                            public void run(){
                                if(oximeter == null) {
                                    oximeter = new Utility(device);
                                    stop();
                                    oximeterGatt = new GattOxi(connectOximeter,oximeter);
                                    oximeterGatt.execute();

                                    //GET SESSION START TIME
                                    Calendar calendar = Calendar.getInstance();
                                    dateStart.clear();
                                    dateStart.add(String.valueOf(calendar.get(Calendar.DAY_OF_MONTH) + "/" +
                                            (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR)));
                                    dateStart.add(String.valueOf(calendar.get(Calendar.HOUR) + ":" +calendar.get(Calendar.MINUTE)));
                                }
                            }
                        });
                    }
                }
            };
}