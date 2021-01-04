package com.example.anwender.empaticae4.EWS;

import android.util.Log;

import com.example.anwender.empaticae4.Configuration.ConfigActivity;
import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.Main.Utility;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

public class SpectralAnalysis {
    private int signalSize;
    private double argConstantPart;
    private double domF;

    private List<double[]> expSPD;

    //Constructor: Requires input signal
    public SpectralAnalysis(List<float[]> inputSignal){
        switch (ConfigActivity.repo_name) {
            case "SDFT": //Software DFT
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2)/signalSize;

                long result = 0;
                double res = 0;

                //define file names
                String input_file = "input_TestData.txt";
                String input_float_file = "input_TestData_float.txt";
                String real_out_file = "real_out_TestData.txt";
                String imag_out_file = "imag_out_TestData.txt";

                //check if TestData exists and delete it
                if (checkFileExists(MainActivity.path, input_file, true))
                    Log.i("TestData", "Deleted "+ input_file + " !");
                if (checkFileExists(MainActivity.path, input_float_file, true))
                    Log.i("TestData", "Deleted "+ input_float_file + " !");
                if (checkFileExists(MainActivity.path, real_out_file, true))
                    Log.i("TestData", "Deleted "+ real_out_file + " !");
                if (checkFileExists(MainActivity.path, imag_out_file, true))
                    Log.i("TestData", "Deleted "+ imag_out_file + " !");

                //Write input values to file
                for (int i=0; i<signalSize; i++) {
                    //Convert float to hex string
                    float fval = inputSignal.get(i)[0];
                    int intval = Float.floatToRawIntBits(fval);
                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n";

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, input_file, st);

                    //Write float values to file
                    writeTestDatatoFile(MainActivity.path, input_float_file, fval + "\n");

                    //zero extend to size of 108
                    //if (i == signalSize-1) {
                    //    for (int j=0; j<8; j++)
                    //        writeTestDatatoFile(MainActivity.path, input_file, "00000000\n");
                    //}

                    result = result + intval;
                    res = res + fval;

                }
                Log.i("TestData", "Created input TestData: "+ input_file + " & " + input_float_file + " !");

                String rst = String.format("%16s", Long.toHexString(result)).replace(' ', '0') + "\n";
                long lval = Double.doubleToRawLongBits(res);
                rst = String.format("%16s", Long.toHexString(lval)).replace(' ', '0') + "\n";

                Complex[] dft = calculateDFT(inputSignal);

                //Write output values to files
                for (int i=0; i<signalSize; i++) {
                    //Real component
                    //Convert double to hex string
                    double dval = dft[i].getR();
                    long intval = Double.doubleToRawLongBits(dval);
                    String st = String.format("%16s", Long.toHexString(intval)).replace(' ', '0') + "\n";

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, real_out_file, st);

                    //Imaginary component
                    //Convert double to hex string
                    dval = dft[i].getI();
                    intval = Double.doubleToRawLongBits(dval);
                    st = String.format("%16s", Long.toHexString(intval)).replace(' ', '0') + "\n";

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, imag_out_file, st);

                    //zero extend to size of 108
                    //if (i == signalSize-1) {
                    //    for (int j=0; j<8; j++) {
                    //        writeTestDatatoFile(MainActivity.path, real_out_file, "0000000000000000\n");
                    //        writeTestDatatoFile(MainActivity.path, imag_out_file, "0000000000000000\n");
                    //    }
                    //}
                }
                Log.i("TestData", "Created output TestData: "+ real_out_file + " & " + imag_out_file  + " !");

                List<double[]> spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "HDFT": //Hardware DFT
                break;

            case "HFFT": //Hardware FFT
                break;

            case "custom_FFT": //Custom FFT
                break;
        }
    }

    public double getDomF(){return this.domF;}
    public List<double[]> getExpSPD(){return this.expSPD;}

    /**
     * Function that calculate the discrete fourier transformed of a given signal
     * @param signal input signal in form float{peaks,timeValues}
     * @return Complex[] representing the fourier transformed of the signal
     */
    private Complex[] calculateDFT(List<float[]> signal){
        Complex[] result = new Complex[signalSize];
        for(int k=0;k<signalSize;k++){
            Complex freqComponent= new Complex(0,0);
            for(int n=0; n<signalSize;n++){
                Complex secondSumm = new Complex(0,0);
                secondSumm.setR(signal.get(n)[0]*Math.cos(argConstantPart*k*n));
                secondSumm.setI(-signal.get(n)[0]*Math.sin(argConstantPart*k*n));
                freqComponent = freqComponent.plus(secondSumm);
            }
            result[k]=freqComponent;
        }
        return result;
    }

    /**
     * Fuction that calculates the spectral power density of a given fourier transformation
     * @param dft discrete fourier transformed signal
     * @return real array with the spectral density
     */
    private List<double[]> SPD(Complex[] dft){
        double fs = 5;
        double[] resSPD = new double[1+dft.length/2];
        for(int i=0;i<resSPD.length;i++){
            if(i==0 || i==resSPD.length-1){
                resSPD[i]=Math.pow(1/(double)dft.length*fs,2)*(Math.pow(new Complex(dft[i].getR(),dft[i].getI()).abs(),2));
            }else{
                resSPD[i]=2*Math.pow(1/(double)dft.length*fs,2)*(Math.pow(new Complex(dft[i].getR(),dft[i].getI()).abs(),2));
            }
        }
        RS resample = new RS(resSPD);
        return resample.getRsSPD();
    }

    /**
     * Fuction that calculate the dominant frequency of a given power spectral density
     * @param rsSPD real arry with the power spectral density analysis
     * @return double that represent the dominant frequency
     */
    private double dominantFrequency(List<double[]> rsSPD){
        double[] f = new double[rsSPD.size()];
        for (int i=0;i<f.length;i++){
            f[i]=rsSPD.get(i)[1];
        }
        int pos=3;
        for(int i=3;i<f.length-1;i++){
            double max = Math.max(rsSPD.get(i)[0],rsSPD.get(i+1)[0]);
            if(max>rsSPD.get(pos)[0]){
                pos = i;
            }
        }
        return f[pos];
    }

    //Write TestData to File
    private void writeTestDatatoFile(File path, String Filename , String Data){

        if (Utility.isExternalStorageWritable()) {
            try {
                //Create a new file @ path/filename
                File file = new File(path, Filename);

                //1st Parameter = filepath, 2nd Paramter true=append
                FileWriter fw = new FileWriter(file, true);
                BufferedWriter out = new BufferedWriter(fw);
                out.write(Data);
                out.close();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }
        else{
            Log.e("writeTestDatatoFile", "Cannot write to storage!");
        }
    }

    //Check if file exists
    private boolean checkFileExists(File path, String Filename, boolean delete){

        if (Utility.isExternalStorageWritable()) { //same as read permission
            //Create a new file @ path/filename
            File file = new File(path, Filename);

            if (file.exists()) {
                if (delete)
                    file.delete(); //delete file if option is selected
                return true;
            } else
                return false;
        }
        else{
            Log.e("checkFileExists", "Cannot read from storage!");
            return false;
        }
    }
}
