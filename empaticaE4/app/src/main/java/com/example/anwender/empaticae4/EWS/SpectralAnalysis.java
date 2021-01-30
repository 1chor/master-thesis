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
    public SpectralAnalysis(List<float[]> inputSignal) {

        //variable declaration
        Complex[] dft;
        List<double[]> spd;

        //variable declaration for file generation
        boundaries bound;

        float norm_abs = 0;
        float max_range_value = 0;
        float min_range_value = 0;

        switch (ConfigActivity.repo_name) {
            case "SDFT": //Software DFT
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;
                dft = calculateDFT(inputSignal);
                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "XDFT": //Hardware Xilinx DFT
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;

                bound = new boundaries(inputSignal); //search for boundaries

                //define file names
                //input TestData files (hex)
                String xdft_input_file = "xdft_input_TestData.txt";
                String xdft_input_norm_file = "xdft_input_TestData_norm.txt";

                //real output TestData files (hex)
                String xdft_real_file = "xdft_real_TestData.txt";
                String xdft_real_norm_file = "xdft_real_TestData_norm.txt";

                //imaginary output TestData files (hex)
                String xdft_imag_file = "xdft_imag_TestData.txt";
                String xdft_imag_norm_file = "xdft_imag_TestData_norm.txt";

                //check if TestData exists and delete it
                //input TestData files (hex)
                if (checkFileExists(MainActivity.path, xdft_input_file, true))
                    Log.i("TestData", "Deleted " + xdft_input_file + " !");
                if (checkFileExists(MainActivity.path, xdft_input_norm_file, true))
                    Log.i("TestData", "Deleted " + xdft_input_norm_file + " !");

                //real output TestData files (hex)
                if (checkFileExists(MainActivity.path, xdft_real_file, true))
                    Log.i("TestData", "Deleted " + xdft_real_file + " !");
                if (checkFileExists(MainActivity.path, xdft_real_norm_file, true))
                    Log.i("TestData", "Deleted " + xdft_real_norm_file + " !");

                //imaginary output TestData files (hex)
                if (checkFileExists(MainActivity.path, xdft_imag_file, true))
                    Log.i("TestData", "Deleted " + xdft_imag_file + " !");
                if (checkFileExists(MainActivity.path, xdft_imag_norm_file, true))
                    Log.i("TestData", "Deleted " + xdft_imag_norm_file + " !");

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
                    int intval = Float.floatToRawIntBits(fval); //integer value
                    int norm_intval = Float.floatToRawIntBits(norm_fval); //normalised integer value

                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_input_file, st);

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeTestDatatoFile(MainActivity.path, xdft_input_norm_file, norm_st);
                }
                Log.i("TestData", "Created input hex TestData: " + xdft_input_file + " & " + xdft_input_norm_file + " !");

                dft = calculateDFT(inputSignal);

                //Write output values to files
                for (int i=0; i<signalSize; i++) {
                    //Real component
                    double dval = dft[i].getR(); //get real output value
                    double norm_dval = 2 * dval / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    int intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision
                    int norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_real_file, st);

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeTestDatatoFile(MainActivity.path, xdft_real_norm_file, norm_st);

                    //Imaginary component
                    dval = dft[i].getI(); //get imaginary output value
                    norm_dval = 2 * dval / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision
                    norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_imag_file, st);

                    //Write normalised hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_imag_norm_file, norm_st);

                }
                Log.i("TestData", "Created real output TestData: " + xdft_real_file + " & " + xdft_real_norm_file  + " !");
                Log.i("TestData", "Created imaginary output TestData: " + xdft_imag_file + " & " + xdft_imag_norm_file + " !");

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "XFFT": //Hardware Xilinx FFT
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;

                bound = new boundaries(inputSignal); //search for boundaries

                //define file names
                //input TestData files (hex)
                String xfft_input_file = "xfft_input_TestData.txt";
                String xfft_input_norm_file = "xfft_input_TestData_norm.txt";

                //real output TestData files (hex)
                String xfft_real_file = "xfft_real_TestData.txt";
                String xfft_real_norm_file = "xfft_real_TestData_norm.txt";

                //imaginary output TestData files (hex)
                String xfft_imag_file = "xfft_imag_TestData.txt";
                String xfft_imag_norm_file = "xfft_imag_TestData_norm.txt";

                //check if TestData exists and delete it
                //input TestData files (hex)
                if (checkFileExists(MainActivity.path, xfft_input_file, true))
                    Log.i("TestData", "Deleted " + xfft_input_file + " !");
                if (checkFileExists(MainActivity.path, xfft_input_norm_file, true))
                    Log.i("TestData", "Deleted " + xfft_input_norm_file + " !");

                //real output TestData files (hex)
                if (checkFileExists(MainActivity.path, xfft_real_file, true))
                    Log.i("TestData", "Deleted " + xfft_real_file + " !");
                if (checkFileExists(MainActivity.path, xfft_real_norm_file, true))
                    Log.i("TestData", "Deleted " + xfft_real_norm_file + " !");

                //imaginary output TestData files (hex)
                if (checkFileExists(MainActivity.path, xfft_imag_file, true))
                    Log.i("TestData", "Deleted " + xfft_imag_file + " !");
                if (checkFileExists(MainActivity.path, xfft_imag_norm_file, true))
                    Log.i("TestData", "Deleted " + xfft_imag_norm_file + " !");

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
                    int intval = Float.floatToRawIntBits(fval); //integer value
                    int norm_intval = Float.floatToRawIntBits(norm_fval); //normalised integer value

                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xfft_input_file, st);

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeTestDatatoFile(MainActivity.path, xfft_input_norm_file, norm_st);
                }
                Log.i("TestData", "Created input hex TestData: " + xfft_input_file + " & " + xfft_input_norm_file + " !");

                dft = calculateDFT(inputSignal);

                //Write output values to files
                for (int i=0; i<signalSize; i++) {
                    //Real component
                    double dval = dft[i].getR(); //get real output value
                    double norm_dval = 2 * dval / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    int intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision
                    int norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xfft_real_file, st);

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeTestDatatoFile(MainActivity.path, xfft_real_norm_file, norm_st);

                    //Imaginary component
                    dval = dft[i].getI(); //get imaginary output value
                    norm_dval = 2 * dval / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision
                    norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xfft_imag_file, st);

                    //Write normalised hex string to file
                    writeTestDatatoFile(MainActivity.path, xfft_imag_norm_file, norm_st);
                }
                Log.i("TestData", "Created real output TestData: " + xfft_real_file + " & " + xfft_real_norm_file + " !");
                Log.i("TestData", "Created imaginary output TestData: " + xfft_imag_file + " & " + xfft_imag_norm_file + " !");

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
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
    private Complex[] calculateDFT(List<float[]> signal) {
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
    private List<double[]> SPD(Complex[] dft) {
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
    private double dominantFrequency(List<double[]> rsSPD) {
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
    private void writeTestDatatoFile(File path, String Filename , String Data) {

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
    private boolean checkFileExists(File path, String Filename, boolean delete) {

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
