package com.example.anwender.empaticae4.EWS;

import android.util.Log;

import com.example.anwender.empaticae4.Configuration.ConfigActivity;
import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.Main.Utility;

import org.apache.commons.math3.linear.DefaultIterativeLinearSolverEvent;

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
                this.argConstantPart = (Math.PI * 2) / signalSize;

                boundaries bound = new boundaries(inputSignal); //search for boundaries

                float norm_abs = 0;
                float max_range_value = 0;
                float min_range_value = 0;

                //define file names
                String input_file = "input_TestData.txt";
                String input_norm_file = "input_TestData_norm.txt";
                String input_norm_16_file = "input_TestData_norm16.txt";

                String input_float_file = "input_TestData_float.txt";
                String input_norm_float_file = "input_TestData_norm_float.txt";

                String real_out_file = "real_out_TestData.txt";
                String imag_out_file = "imag_out_TestData.txt";

                //check if TestData exists and delete it
                if (checkFileExists(MainActivity.path, input_file, true))
                    Log.i("TestData", "Deleted " + input_file + " !");
                if (checkFileExists(MainActivity.path, input_norm_file, true))
                    Log.i("TestData", "Deleted " + input_norm_file + " !");
                if (checkFileExists(MainActivity.path, input_norm_16_file, true))
                    Log.i("TestData", "Deleted " + input_norm_16_file + " !");

                if (checkFileExists(MainActivity.path, input_float_file, true))
                    Log.i("TestData", "Deleted " + input_float_file + " !");
                if (checkFileExists(MainActivity.path, input_norm_float_file, true))
                    Log.i("TestData", "Deleted " + input_norm_float_file + " !");

                if (checkFileExists(MainActivity.path, real_out_file, true))
                    Log.i("TestData", "Deleted " + real_out_file + " !");
                if (checkFileExists(MainActivity.path, imag_out_file, true))
                    Log.i("TestData", "Deleted " + imag_out_file + " !");

                //normalise input values to be between -1 and 1
                //original sign of the values are maintained
                if (Math.abs(bound.getMin()) > bound.getMax()) {
                    max_range_value = Math.abs(bound.getMin());
                    min_range_value = bound.getMin();
                } else {
                    max_range_value = bound.getMax();
                    min_range_value = -bound.getMax();
                }
                norm_abs = (max_range_value - min_range_value);

                //Write input values to file
                for (int i=0; i<signalSize; i++) {
                    float fval = inputSignal.get(i)[0]; //get input value
                    float norm_fval = 2 * fval / norm_abs; //normalise input value, range [-1 1]

                    //Convert float to hex string
                    int intval = Float.floatToRawIntBits(fval);
                    int norm_intval = Float.floatToRawIntBits(norm_fval);
                    int norm_intval16 = convert_to_fixed_1q15(norm_fval);
                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n";
                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n";
                    String norm_st16 = String.format("%4s", Integer.toHexString(norm_intval16)).replace(' ', '0') + "0000\n";

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, input_file, st);

                    //Write normalised hex string to file
                    writeTestDatatoFile(MainActivity.path, input_norm_file, norm_st);

                    //Write normalised 16 bit hex string to file
                    writeTestDatatoFile(MainActivity.path, input_norm_16_file, norm_st16);

                    //Write float values to file
                    writeTestDatatoFile(MainActivity.path, input_float_file, fval + "\n");

                    //Write normalised float values to file
                    writeTestDatatoFile(MainActivity.path, input_norm_float_file, norm_fval + "\n");
                }
                Log.i("TestData", "Created input hex TestData: " + input_file + " & " + input_norm_file + " & " + input_norm_16_file + " !");
                Log.i("TestData", "Created input float TestData: " + input_float_file + " & " + input_norm_float_file + " !");

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

    //convert float value to integer fixed 1q15 format
    private int convert_to_fixed_1q15(float num){
        return (int)(num * (1 << 15));
    }

    //convert integer fixed 1q15 format to float
    private float convert_1q15(int num){
        byte i = 0;
        byte shift_by = 0;
        byte invert = 0;

        float num_float = 0;

        //if num is negativ, num will be inverted (2's complement)
        if (num < 0) {
            invert = 1;

            num = ~num;
            num += 1;
        }

        //for the 1q15 format we have to start at 15
        //the smallest part is 2^⁻15
        for (i = 15; i > 0; i--) {

            // if lsb is 1
            if ( ( (num >> shift_by) & 1) == 1) {
                //then add 2^-i
                num_float += Math.pow(2, i*(-1));
            }
            shift_by += 1;

            //calculate integer part to the left of the comma
            if ((i == 1) && ((num >> shift_by) > 0)) {
                num_float += num >> shift_by;
            }
        }

        if (invert == 1) {
            num_float *= -1;
        }

        return num_float;
    }
}
