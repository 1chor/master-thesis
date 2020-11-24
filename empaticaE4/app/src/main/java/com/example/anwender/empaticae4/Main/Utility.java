package com.example.anwender.empaticae4.Main;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import com.example.anwender.empaticae4.EWS.ConnectOximeter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Scanner;

public final class Utility {


    public static void toastie(Context context, String s) {
        Toast.makeText(context, s, Toast.LENGTH_SHORT).show();
    }

    //Check if external Storage can be written to
    public static boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            return true;
        }
        Log.e("isExtStorageWritable", "Can´t write to Ext. Storage");
        return false;
    }

    //Get the path to the Documents Folder
    public static File getStorageDir(String folderName) {
        // Get the directory for the user's public documents directory.
        File documents = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);
        //path will be storage/sdcard/documents/foldername
        File path = new File(documents, folderName);
        Log.d("getStorageDir", path.toString());
        if (!path.mkdirs()) {
            Log.e("getStorageDir", "E4 Directory not created");
        }
        return path;
    }

    //Write to File
    public static void writetoCSV(Context context,File path, String Filename , String Data){

        if (isExternalStorageWritable()) {
            try {
                //Create a new file @ path/filename
                File file = new File(path, Filename);

                //1st Parameter = filepath, 2nd Paramter true=append
                FileWriter fw = new FileWriter(file, true);
                BufferedWriter out = new BufferedWriter(fw);
                out.write(Data);
                out.close();
                //toastie(context,"Entry Saved");
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }
        else{
            Log.e("WriteToCsv", "Cannot write to storage!");
        }
    }


    public static boolean checkBluetooth(BluetoothAdapter bluetoothAdapter) {
        return !(bluetoothAdapter == null || !bluetoothAdapter.isEnabled());
    }

    public static void requestUserBluetooth(Activity activity) {
        Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
        activity.startActivityForResult(enableBtIntent, ConnectOximeter.REQUEST_ENABLE_BT);
    }

    //TODO Utility class is not intended to be instantiated
    public BluetoothDevice deviceOxi;
    public Utility(BluetoothDevice bluetoothDevice) {
        this.deviceOxi = bluetoothDevice;
    }

    // get Nonin device name
    public String getName() {
        return deviceOxi.getName();
    }


    //EDIT CSV -------> used only for the historical record
    public static void editCSV(File path, String Filename, ArrayList<Float> minMaxMed, ArrayList<String> dateStart) {

        if (isExternalStorageWritable()) {
            File oldfile = new File(path, Filename);
            File newfile = new File(path, "temp.csv");
            String existingDate;
            String existingTime;
            String minSBP;
            String minTemp;
            String minHR;
            String minRR;
            String maxSBP;
            String maxTemp;
            String maxHR;
            String maxRR;
            boolean time_found = false;

            try {
                FileWriter fw = new FileWriter(newfile, true);
                BufferedWriter bw = new BufferedWriter(fw);
                PrintWriter pw = new PrintWriter(bw);
                Scanner x = new Scanner(new File(path, Filename));
                x.useDelimiter("[,\n]");

                while (x.hasNext() && !time_found) {
                    existingDate = x.next();
                    existingTime = x.next();
                    minSBP = x.next();
                    minTemp = x.next();
                    minHR = x.next();
                    minRR = x.next();
                    maxSBP = x.next();
                    maxTemp = x.next();
                    maxHR = x.next();
                    maxRR = x.next();

                    // if exist data for the current session, rewrite those data
                    if (existingDate.equals(dateStart.get(0)) && existingTime.equals(dateStart.get(1))) {
                        time_found = true;
                        pw.println(dateStart.get(0) + "," + dateStart.get(1) + "," +
                                minMaxMed.get(0) + "," + minMaxMed.get(1) + "," + minMaxMed.get(2) + "," +
                                minMaxMed.get(3) + "," + minMaxMed.get(4) + "," + minMaxMed.get(5) + "," +
                                minMaxMed.get(6) + "," + minMaxMed.get(7));
                    } else {
                        pw.println(existingDate + "," + existingTime + "," +
                                minSBP + "," + minTemp + "," + minHR + "," + minRR + "," +
                                maxSBP + "," + maxTemp + "," + maxHR + "," + maxRR);
                    }
                }

                // if there are no data for the session, create those data
                if (!time_found)
                {
                    pw.println(dateStart.get(0) + "," + dateStart.get(1) + "," +
                            minMaxMed.get(0) + "," + minMaxMed.get(1) + "," + minMaxMed.get(2) + "," +
                            minMaxMed.get(3) + "," + minMaxMed.get(4) + "," + minMaxMed.get(5) + "," +
                            minMaxMed.get(6) + "," + minMaxMed.get(7));
                }
                x.close();
                pw.flush();
                pw.close();
                oldfile.delete();
                File dump = new File(path, Filename);
                newfile.renameTo(dump);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        else {
            Log.e("WriteToCsv", "Cannot write to storage!");
        }
    }

    //SCAN CSV --------> used only for uploading the data on the historical record
    public static String scanCSV(File path, String Filename, String existDate) {

        String existingDate;
        String existingTime;
        String minSBP;
        String minTemp;
        String minHR;
        String minRR;
        String maxSBP;
        String maxTemp;
        String maxHR;
        String maxRR;
        StringBuilder availableText = new StringBuilder();

        try {
            Scanner x = new Scanner(new File(path, Filename));
            x.useDelimiter("[,\n]");

            while (x.hasNext()) {
                existingDate = x.next();
                existingTime = x.next();
                minSBP = x.next();
                minTemp = x.next();
                minHR = x.next();
                minRR = x.next();
                maxSBP = x.next();
                maxTemp = x.next();
                maxHR = x.next();
                maxRR = x.next();

                if (existingDate.equals(existDate)) {
                    availableText.append("\nSession started at: ").append(existingTime).append("\n\nMINIMUM VALUES").
                            append("\nSB Pressure: ").append(minSBP).append(" mmHg\nTemperature: ").append(minTemp).
                            append(" ºC\nHeart Rate: ").append(minHR).append(" bpm\nRR: ").append(minRR).
                            append(" bpm\n\nMAXIMUM VALUES").append("\nSB Pressure: ").append(maxSBP).
                            append(" mmHg\nTemperature: ").append(maxTemp).append(" ºC\nHeart Rate: ").
                            append(maxHR).append(" bpm\nRR: ").append(maxRR).append(" bpm\n\n");
                }
            }
            x.close();

        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        }
        return availableText.toString();
    }

}
