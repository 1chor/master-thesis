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
                String xdft_input_norm_16_file = "xdft_input_TestData_norm16.txt";

                //input TestData files (float)
                String xdft_input_float_file = "xdft_input_TestData_float.txt";
                String xdft_input_norm_float_file = "xdft_input_TestData_norm_float.txt";

                //real output TestData files (hex)
                String xdft_real_file = "xdft_real_TestData.txt";
                String xdft_real_norm_file = "xdft_real_TestData_norm.txt";
                String xdft_real_norm_32_file = "xdft_real_TestData_norm32.txt";

                //imaginary output TestData files (hex)
                String xdft_imag_file = "xdft_imag_TestData.txt";
                String xdft_imag_norm_file = "xdft_imag_TestData_norm.txt";
                String xdft_imag_norm_32_file = "xdft_imag_TestData_norm32.txt";

                //check if TestData exists and delete it
                //input TestData files (hex)
                if (checkFileExists(MainActivity.path, xdft_input_file, true))
                    Log.i("TestData", "Deleted " + xdft_input_file + " !");
                if (checkFileExists(MainActivity.path, xdft_input_norm_file, true))
                    Log.i("TestData", "Deleted " + xdft_input_norm_file + " !");
                if (checkFileExists(MainActivity.path, xdft_input_norm_16_file, true))
                    Log.i("TestData", "Deleted " + xdft_input_norm_16_file + " !");

                //input TestData files (float)
                if (checkFileExists(MainActivity.path, xdft_input_float_file, true))
                    Log.i("TestData", "Deleted " + xdft_input_float_file + " !");
                if (checkFileExists(MainActivity.path, xdft_input_norm_float_file, true))
                    Log.i("TestData", "Deleted " + xdft_input_norm_float_file + " !");

                //real output TestData files (hex)
                if (checkFileExists(MainActivity.path, xdft_real_file, true))
                    Log.i("TestData", "Deleted " + xdft_real_file + " !");
                if (checkFileExists(MainActivity.path, xdft_real_norm_file, true))
                    Log.i("TestData", "Deleted " + xdft_real_norm_file + " !");
                if (checkFileExists(MainActivity.path, xdft_real_norm_32_file, true))
                    Log.i("TestData", "Deleted " + xdft_real_norm_32_file + " !");

                //imaginary output TestData files (hex)
                if (checkFileExists(MainActivity.path, xdft_imag_file, true))
                    Log.i("TestData", "Deleted " + xdft_imag_file + " !");
                if (checkFileExists(MainActivity.path, xdft_imag_norm_file, true))
                    Log.i("TestData", "Deleted " + xdft_imag_norm_file + " !");
                if (checkFileExists(MainActivity.path, xdft_imag_norm_32_file, true))
                    Log.i("TestData", "Deleted " + xdft_imag_norm_32_file + " !");

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
                    int norm_intval16 = convert_to_fixed_1q15(norm_fval); //normalised integer value in 1q15 format

                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string
                    String norm_st16 = String.format("%4s", Integer.toHexString(norm_intval16)).replace(' ', '0') + "0000\n"; //normalised hex string in 1q15 format

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_input_file, st);

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeTestDatatoFile(MainActivity.path, xdft_input_norm_file, norm_st);

                    //Write normalised 1q15 format hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_input_norm_16_file, norm_st16);

                    //Write float values to file
                    writeTestDatatoFile(MainActivity.path, xdft_input_float_file, fval + "\n");

                    //Write normalised float values to file
                    writeTestDatatoFile(MainActivity.path, xdft_input_norm_float_file, norm_fval + "\n");
                }
                Log.i("TestData", "Created input hex TestData: " + xdft_input_file + " & " + xdft_input_norm_file + " & " + xdft_input_norm_16_file + " !");
                Log.i("TestData", "Created input float TestData: " + xdft_input_float_file + " & " + xdft_input_norm_float_file + " !");

                dft = calculateDFT(inputSignal);

                //Write output values to files
                for (int i=0; i<signalSize; i++) {
                    //Real component
                    double dval = dft[i].getR(); //get real output value
                    double norm_dval = 2 * dval / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    int intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision
                    int norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision
                    long norm_intval32 = convert_to_fixed_9q23(norm_dval); //normalised integer value in 9q23 format

                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string
                    String norm_st32 = String.format("%8s", Integer.toHexString((int)norm_intval32)).replace(' ', '0') + "\n"; //normalised hex string in 9q23 format

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_real_file, st);

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeTestDatatoFile(MainActivity.path, xdft_real_norm_file, norm_st);

                    //Write normalised 1q15 format hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_real_norm_32_file, norm_st32);

                    //Imaginary component
                    dval = dft[i].getI(); //get imaginary output value
                    norm_dval = 2 * dval / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision
                    norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision
                    norm_intval32 = convert_to_fixed_9q23(norm_dval); //normalised integer value in 9q23 format

                    st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string
                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string
                    norm_st32 = String.format("%8s", Integer.toHexString((int)norm_intval32)).replace(' ', '0') + "00000000\n"; //normalised hex string in 9q23 format

                    //Write hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_imag_file, st);

                    //Write normalised hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_imag_norm_file, norm_st);

                    //Write normalised 1q15 format hex string to file
                    writeTestDatatoFile(MainActivity.path, xdft_imag_norm_32_file, norm_st32);
                }
                Log.i("TestData", "Created real output TestData: " + xdft_real_file + " & " + xdft_real_norm_file  + " & " + xdft_real_norm_32_file  +" !");
                Log.i("TestData", "Created imaginary output TestData: " + xdft_imag_file + " & " + xdft_imag_norm_file  + " & " + xdft_imag_norm_32_file  +" !");

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "XFFT": //Hardware Xilinx FFT
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

    //convert float value to integer fixed 1q15 format
    private int convert_to_fixed_1q15(float num) {
        return (int)(num * (1 << 15));
    }

    //convert double value to integer fixed 9q23 format
    private long convert_to_fixed_9q23(double num) {
        return (long)(num * (1 << 23));
    }

    //convert integer fixed 1q15 format to float
    private float convert_1q15(int num) {
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

    //convert integer fixed 9q23 format to double
    private double convert_9q23(long num) {
        byte i = 0;
        byte shift_by = 0;
        byte invert = 0;

        double num_float = 0;

        //if num is negativ, num will be inverted (2's complement)
        if (num < 0) {
            invert = 1;

            num = ~num;
            num += 1;
        }

        //num_float += num >> 23;

        //for the 9q23 format we have to start at 23
        //the smallest part is 2^⁻23
        for (i = 23; i > 0; i--) {

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
