package com.example.anwender.empaticae4.EWS;

import android.util.Log;

import com.example.anwender.empaticae4.Configuration.ConfigActivity;
import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.Main.Utility;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

public class SpectralAnalysis {
    private int signalSize;
    private double argConstantPart;
    private double domF;
    private float norm_abs;

    private List<double[]> expSPD;

    //Constructor: Requires input signal
    public SpectralAnalysis(List<float[]> inputSignal) {

        //variable declaration
        Complex[] dft;
        Complex[] dft_sw;
        List<double[]> spd;

        //variable declaration for file generation
        File file;
        boundaries bound;

        float max_range_value;
        float min_range_value;

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
                //input data files (hex)
                String xdft_input_file = "xdft_input.txt";

                String xdft_output_file = "xdft_output.txt";

                //real output data files (hex)
                //String xdft_real_file = "xdft_real.txt";

                //imaginary output data files (hex)
                //String xdft_imag_file = "xdft_imag.txt";

                //check if file exists and delete it
                //input data files (hex)
                if (checkFileExists(MainActivity.path, xdft_input_file, true))
                    Log.i("Input data", "Deleted " + xdft_input_file + " !");

                //output data file (hex)
                if (checkFileExists(MainActivity.path, xdft_output_file, true))
                    Log.i("Output data", "Deleted " + xdft_output_file + " !");

                /*
                //real output data files (hex)
                if (checkFileExists(MainActivity.path, xdft_real_file, true))
                    Log.i("Output data", "Deleted " + xdft_real_file + " !");

                //imaginary output data files (hex)
                if (checkFileExists(MainActivity.path, xdft_imag_file, true))
                    Log.i("Output data", "Deleted " + xdft_imag_file + " !");
                */

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
                for (int i = 0; i < signalSize; i++) {
                    float norm_fval = 2 * inputSignal.get(i)[0] / norm_abs; //normalise input value, range [-1 1]

                    //Convert float to hex string
                    int norm_intval = Float.floatToRawIntBits(norm_fval); //normalised integer value

                    String norm_st = String.format("%16s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xdft_input_file, norm_st);
                }
                Log.i("Input data", "Created input hex data: " + xdft_input_file + " !");

                //wait until output file exists
                file = new File(MainActivity.path, xdft_output_file);
                while (!file.exists()) {
                    try {
                        //Thread.Sleep(1000);
                        java.lang.Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

                //get FFT results
                dft = readDataFromFile(MainActivity.path, xdft_output_file, true);

                //delete output file
                if (checkFileExists(MainActivity.path, xdft_output_file, true))
                    Log.i("Output data", "Deleted " + xdft_output_file + " !");

                /*
                dft_sw = calculateDFT(inputSignal);

                for (int i = 0; i < signalSize; i++) {
                if (! String.format("%1.3f", dft[i].getR()).equals(String.format("%1.3f", dft_sw[i].getR())))
                Log.d("Compare", "Real[" + i + "]: " + String.format("%1.3f", dft[i].getR()) + " vs " + String.format("%1.3f", dft_sw[i].getR()));
                if (! String.format("%1.3f", dft[i].getI()).equals(String.format("%1.3f", dft_sw[i].getI())))
                Log.d("Compare", "Imag[" + i + "]: " + String.format("%1.3f", dft[i].getI()) + " vs " + String.format("%1.3f", dft_sw[i].getI()));
                }

                //Write output values to files
                for (int i = 0; i < signalSize; i++) {
                    //Real component
                    double norm_dval = 2 * dft[i].getR() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    int norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xdft_real_file, norm_st);

                    //Imaginary component
                    norm_dval = 2 * dft[i].getI() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xdft_imag_file, norm_st);

                }
                Log.i("Output data", "Created real output data: " + xdft_real_file + " !");
                Log.i("Output data", "Created imaginary output data: " + xdft_imag_file + " !");
                */

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "XFFT": //Hardware Xilinx FFT  (floating-point)
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;

                //define file names
                //input data files (hex)
                String xfft_input_file = "xfft_input.txt";

                String xfft_output_file = "xfft_output.txt";

                //real output data files (hex)
                //String xfft_real_file = "xfft_real.txt";

                //imaginary output data files (hex)
                //String xfft_imag_file = "xfft_imag.txt";

                //check if file exists and delete it
                //input data files (hex)
                if (checkFileExists(MainActivity.path, xfft_input_file, true))
                    Log.i("Input data", "Deleted " + xfft_input_file + " !");

                //output data file (hex)
                if (checkFileExists(MainActivity.path, xfft_output_file, true))
                    Log.i("Output data", "Deleted " + xfft_output_file + " !");

                /*
                //real output data files (hex)
                if (checkFileExists(MainActivity.path, xfft_real_file, true))
                    Log.i("Output data", "Deleted " + xfft_real_file + " !");

                //imaginary output data files (hex)
                if (checkFileExists(MainActivity.path, xfft_imag_file, true))
                    Log.i("Output data", "Deleted " + xfft_imag_file + " !");
                 */

                //Write input values to file
                for (int i = 0; i < signalSize; i++) {
                    float fval = inputSignal.get(i)[0]; //get input value

                    //Convert float to hex string
                    int intval = Float.floatToRawIntBits(fval); //integer value

                    String st = String.format("%16s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string

                    //Write hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xfft_input_file, st);
                }
                Log.i("Input data", "Created input hex data: " + xfft_input_file + " !");

                //wait until output file exists
                file = new File(MainActivity.path, xfft_output_file);
                while (!file.exists()) {
                    try {
                        //Thread.Sleep(1000);
                        java.lang.Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

                //get FFT results
                dft = readDataFromFile(MainActivity.path, xfft_output_file, false);

                //delete output file
                if (checkFileExists(MainActivity.path, xfft_output_file, true))
                    Log.i("Output data", "Deleted " + xfft_output_file + " !");

                /*
                dft_sw = calculateDFT(inputSignal);

                for (int i = 0; i < signalSize; i++) {
                    if (! String.format("%1.3f", dft[i].getR()).equals(String.format("%1.3f", dft_sw[i].getR())))
                        Log.d("Compare", "Real[" + i + "]: " + String.format("%1.3f", dft[i].getR()) + " vs " + String.format("%1.3f", dft_sw[i].getR()));
                    if (! String.format("%1.3f", dft[i].getI()).equals(String.format("%1.3f", dft_sw[i].getI())))
                        Log.d("Compare", "Imag[" + i + "]: " + String.format("%1.3f", dft[i].getI()) + " vs " + String.format("%1.3f", dft_sw[i].getI()));
                }

                //Write output values to files
                for (int i=0; i<signalSize; i++) {
                    //Real component
                    double dval = dft[i].getR(); //get real output value

                    //Convert double to hex string
                    int intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision

                    String st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string

                    //Write hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xfft_real_file, st);

                    //Imaginary component
                    dval = dft[i].getI(); //get imaginary output value

                    //Convert double to hex string
                    intval = Float.floatToRawIntBits((float)dval); //integer value, convert to float for IEEE 754 float single precision

                    st = String.format("%8s", Integer.toHexString(intval)).replace(' ', '0') + "\n"; //hex string

                    //Write hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xfft_imag_file, st);
                }
                Log.i("Output data", "Created real output data: " + xfft_real_file + " !");
                Log.i("Output data", "Created imaginary output data: " + xfft_imag_file + " !");
                */

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "XFFT_fixed": //Hardware Xilinx FFT (fixed-point)
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;

                bound = new boundaries(inputSignal); //search for boundaries

                //define file names
                //input data files (hex)
                String xfft_fixed_input_file = "xfft_fixed_input.txt";

                String xfft_fixed_output_file = "xfft_fixed_output.txt";

                //real output data files (hex)
                //String xfft_fixed_real_file = "xfft_fixed_real.txt";

                //imaginary output data files (hex)
                //String xfft_fixed_imag_file = "xfft_fixed_imag.txt";

                //check if file exists and delete it
                //input data files (hex)
                if (checkFileExists(MainActivity.path, xfft_fixed_input_file, true))
                    Log.i("Input data", "Deleted " + xfft_fixed_input_file + " !");

                //output data file (hex)
                if (checkFileExists(MainActivity.path, xfft_fixed_output_file, true))
                    Log.i("Output data", "Deleted " + xfft_fixed_output_file + " !");

                /*
                //real output data files (hex)
                if (checkFileExists(MainActivity.path, xfft_fixed_real_file, true))
                    Log.i("Output data", "Deleted " + xfft_fixed_real_file + " !");

                //imaginary output data files (hex)
                if (checkFileExists(MainActivity.path, xfft_fixed_imag_file, true))
                    Log.i("Output data", "Deleted " + xfft_fixed_imag_file + " !");
                */

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
                for (int i = 0; i < signalSize; i++) {
                    float norm_fval = 2 * inputSignal.get(i)[0] / norm_abs; //normalise input value, range [-1, 1]

                    //Convert float to hex string
                    int norm_intval = Float.floatToRawIntBits(norm_fval); //normalised integer value

                    String norm_st = String.format("%16s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xfft_fixed_input_file, norm_st);
                }
                Log.i("Input data", "Created input hex data: " + xfft_fixed_input_file + " !");

                //wait until output file exists
                file = new File(MainActivity.path, xfft_fixed_output_file);
                while (!file.exists()) {
                    try {
                        //Thread.Sleep(1000);
                        java.lang.Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

                //get FFT results
                dft = readDataFromFile(MainActivity.path, xfft_fixed_output_file, true);

                //delete output file
                if (checkFileExists(MainActivity.path, xfft_fixed_output_file, true))
                    Log.i("Output data", "Deleted " + xfft_fixed_output_file + " !");

                /*
                dft_sw = calculateDFT(inputSignal);

                for (int i = 0; i < signalSize; i++) {
                if (! String.format("%1.3f", dft[i].getR()).equals(String.format("%1.3f", dft_sw[i].getR())))
                    Log.d("Compare", "Real[" + i + "]: " + String.format("%1.3f", dft[i].getR()) + " vs " + String.format("%1.3f", dft_sw[i].getR()));
                if (! String.format("%1.3f", dft[i].getI()).equals(String.format("%1.3f", dft_sw[i].getI())))
                    Log.d("Compare", "Imag[" + i + "]: " + String.format("%1.3f", dft[i].getI()) + " vs " + String.format("%1.3f", dft_sw[i].getI()));
                }

                //Write output values to files
                for (int i=0; i<signalSize; i++) {
                    //Real component
                    double norm_dval = 2 * dft[i].getR() / norm_abs; //normalise real output value, range [-1, 1]

                    //Convert double to hex string
                    int norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xfft_fixed_real_file, norm_st);

                    //Imaginary component
                    norm_dval = 2 * dft[i].getI() / norm_abs; //normalise imaginary output value, range [-1, 1]

                    //Convert double to hex string
                    norm_intval = Float.floatToRawIntBits((float)norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, xfft_fixed_imag_file, norm_st);
                }
                Log.i("Output data", "Created real output data: " + xfft_fixed_real_file + " !");
                Log.i("Output data", "Created imaginary output data: " + xfft_fixed_imag_file + " !");
                */

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "INTFFTK": //Hardware Fully pipelined integer unscaled FFT
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;

                bound = new boundaries(inputSignal); //search for boundaries

                //define file names
                //input data files (hex)
                String intfftk_input_file = "intfftk_input.txt";

                String intfftk_output_file = "intfftk_output.txt";

                //real output data files (hex)
                //String intfftk_real_file = "intfftk_real.txt";

                //imaginary output data files (hex)
                //String intfftk_imag_file = "intfftk_imag.txt";

                //check if file exists and delete it
                //input data files (hex)
                if (checkFileExists(MainActivity.path, intfftk_input_file, true))
                    Log.i("Input data", "Deleted " + intfftk_input_file + " !");

                //output data file (hex)
                if (checkFileExists(MainActivity.path, intfftk_output_file, true))
                    Log.i("Output data", "Deleted " + intfftk_output_file + " !");

                /*
                //real output data files (hex)
                if (checkFileExists(MainActivity.path, intfftk_real_file, true))
                    Log.i("Output data", "Deleted " + intfftk_real_file + " !");

                //imaginary output data files (hex)
                if (checkFileExists(MainActivity.path, intfftk_imag_file, true))
                    Log.i("Output data", "Deleted " + intfftk_imag_file + " !");
                */

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
                for (int i = 0; i < signalSize; i++) {
                    float norm_fval = 2 * inputSignal.get(i)[0] / norm_abs; //normalise input value, range [-1 1]

                    //Convert float to hex string
                    int norm_intval = Float.floatToRawIntBits(norm_fval); //normalised integer value

                    String norm_st = String.format("%16s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, intfftk_input_file, norm_st);
                }
                Log.i("Input data", "Created input hex data: " + intfftk_input_file + " !");

                //wait until output file exists
                file = new File(MainActivity.path, intfftk_output_file);
                while (!file.exists()) {
                    try {
                        //Thread.Sleep(1000);
                        java.lang.Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

                //get FFT results
                dft = readDataFromFile(MainActivity.path, intfftk_output_file, true);

                //delete output file
                if (checkFileExists(MainActivity.path, intfftk_output_file, true))
                    Log.i("Output data", "Deleted " + intfftk_output_file + " !");

                /*
                dft_sw = calculateDFT(inputSignal);

                for (int i = 0; i < signalSize; i++) {
                if (! String.format("%1.3f", dft[i].getR()).equals(String.format("%1.3f", dft_sw[i].getR())))
                Log.d("Compare", "Real[" + i + "]: " + String.format("%1.3f", dft[i].getR()) + " vs " + String.format("%1.3f", dft_sw[i].getR()));
                if (! String.format("%1.3f", dft[i].getI()).equals(String.format("%1.3f", dft_sw[i].getI())))
                Log.d("Compare", "Imag[" + i + "]: " + String.format("%1.3f", dft[i].getI()) + " vs " + String.format("%1.3f", dft_sw[i].getI()));
                }

                //Write output values to files
                for (int i = 0; i < signalSize; i++) {
                    //Real component
                    double norm_dval = 2 * dft[i].getR() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    int norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, intfftk_real_file, norm_st);

                    //Imaginary component
                    norm_dval = 2 * dft[i].getI() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path,intfftk_imag_file, norm_st);

                }
                Log.i("Output data", "Created real output data: " + intfftk_real_file + " !");
                Log.i("Output data", "Created imaginary output data: " + intfftk_imag_file + " !");
                */

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "INTFFT_SPDF": //Hardware Integer unscaled Radix-2 Single Path Delay Feedback FFT
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;

                bound = new boundaries(inputSignal); //search for boundaries

                //define file names
                //input data files (hex)
                String intfft_spdf_input_file = "intfft_spdf_input.txt";

                String intfft_spdf_output_file = "intfft_spdf_output.txt";

                //real output data files (hex)
                //String intfft_spdf_real_file = "intfft_spdf_real.txt";

                //imaginary output data files (hex)
                //String intfft_spdf_imag_file = "intfft_spdf_imag.txt";

                //check if file exists and delete it
                //input data files (hex)
                if (checkFileExists(MainActivity.path, intfft_spdf_input_file, true))
                    Log.i("Input data", "Deleted " + intfft_spdf_input_file + " !");

                //output data file (hex)
                if (checkFileExists(MainActivity.path, intfft_spdf_output_file, true))
                    Log.i("Output data", "Deleted " + intfft_spdf_output_file + " !");

                /*
                //real output data files (hex)
                if (checkFileExists(MainActivity.path, intfft_spdf_real_file, true))
                    Log.i("Output data", "Deleted " + intfft_spdf_real_file + " !");

                //imaginary output data files (hex)
                if (checkFileExists(MainActivity.path, intfft_spdf_imag_file, true))
                    Log.i("Output data", "Deleted " + intfft_spdf_imag_file + " !");
                */

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
                for (int i = 0; i < signalSize; i++) {
                    float norm_fval = 2 * inputSignal.get(i)[0] / norm_abs; //normalise input value, range [-1 1]

                    //Convert float to hex string
                    int norm_intval = Float.floatToRawIntBits(norm_fval); //normalised integer value

                    String norm_st = String.format("%16s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, intfft_spdf_input_file, norm_st);
                }
                Log.i("Input data", "Created input hex data: " + intfft_spdf_input_file + " !");

                //wait until output file exists
                file = new File(MainActivity.path, intfft_spdf_output_file);
                while (!file.exists()) {
                    try {
                        //Thread.Sleep(1000);
                        java.lang.Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

                //get FFT results
                dft = readDataFromFile(MainActivity.path, intfft_spdf_output_file, true);

                //delete output file
                if (checkFileExists(MainActivity.path, intfft_spdf_output_file, true))
                    Log.i("Output data", "Deleted " + intfft_spdf_output_file + " !");

                /*
                dft_sw = calculateDFT(inputSignal);

                for (int i = 0; i < signalSize; i++) {
                if (! String.format("%1.3f", dft[i].getR()).equals(String.format("%1.3f", dft_sw[i].getR())))
                Log.d("Compare", "Real[" + i + "]: " + String.format("%1.3f", dft[i].getR()) + " vs " + String.format("%1.3f", dft_sw[i].getR()));
                if (! String.format("%1.3f", dft[i].getI()).equals(String.format("%1.3f", dft_sw[i].getI())))
                Log.d("Compare", "Imag[" + i + "]: " + String.format("%1.3f", dft[i].getI()) + " vs " + String.format("%1.3f", dft_sw[i].getI()));
                }

                //Write output values to files
                for (int i = 0; i < signalSize; i++) {
                    //Real component
                    double norm_dval = 2 * dft[i].getR() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    int norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, intfft_spdf_real_file, norm_st);

                    //Imaginary component
                    norm_dval = 2 * dft[i].getI() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path,intfft_spdf_imag_file, norm_st);

                }
                Log.i("Output data", "Created real output data: " + intfft_spdf_real_file + " !");
                Log.i("Output data", "Created imaginary output data: " + intfft_spdf_imag_file + " !");
                */

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
                break;

            case "DBLCLKFFT": //Hardware Generic Pipelined FFT
                this.signalSize = inputSignal.size();
                this.argConstantPart = (Math.PI * 2) / signalSize;

                bound = new boundaries(inputSignal); //search for boundaries

                //define file names
                //input data files (hex)
                String dblclkfft_input_file = "dblclkfft_input.txt";

                String dblclkfft_output_file = "dblclkfft_output.txt";

                //real output data files (hex)
                //String dblclkfft_real_file = "dblclkfft_real.txt";

                //imaginary output data files (hex)
                //String dblclkfft_imag_file = "dblclkfft_imag.txt";

                //check if file exists and delete it
                //input data files (hex)
                if (checkFileExists(MainActivity.path, dblclkfft_input_file, true))
                    Log.i("Input data", "Deleted " + dblclkfft_input_file + " !");

                //output data file (hex)
                if (checkFileExists(MainActivity.path, dblclkfft_output_file, true))
                    Log.i("Output data", "Deleted " + dblclkfft_output_file + " !");

                /*
                //real output data files (hex)
                if (checkFileExists(MainActivity.path, dblclkfft_real_file, true))
                    Log.i("Output data", "Deleted " + dblclkfft_real_file + " !");

                //imaginary output data files (hex)
                if (checkFileExists(MainActivity.path, dblclkfft_imag_file, true))
                    Log.i("Output data", "Deleted " + dblclkfft_imag_file + " !");
                */

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
                for (int i = 0; i < signalSize; i++) {
                    float norm_fval = 2 * inputSignal.get(i)[0] / norm_abs; //normalise input value, range [-1 1]

                    //Convert float to hex string
                    int norm_intval = Float.floatToRawIntBits(norm_fval); //normalised integer value

                    String norm_st = String.format("%16s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, dblclkfft_input_file, norm_st);
                }
                Log.i("Input data", "Created input hex data: " + dblclkfft_input_file + " !");

                //wait until output file exists
                file = new File(MainActivity.path, dblclkfft_output_file);
                while (!file.exists()) {
                    try {
                        //Thread.Sleep(1000);
                        java.lang.Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

                //get FFT results
                dft = readDataFromFile(MainActivity.path, dblclkfft_output_file, true);

                //delete output file
                if (checkFileExists(MainActivity.path, dblclkfft_output_file, true))
                    Log.i("Output data", "Deleted " + dblclkfft_output_file + " !");

                /*
                dft_sw = calculateDFT(inputSignal);

                for (int i = 0; i < signalSize; i++) {
                if (! String.format("%1.3f", dft[i].getR()).equals(String.format("%1.3f", dft_sw[i].getR())))
                Log.d("Compare", "Real[" + i + "]: " + String.format("%1.3f", dft[i].getR()) + " vs " + String.format("%1.3f", dft_sw[i].getR()));
                if (! String.format("%1.3f", dft[i].getI()).equals(String.format("%1.3f", dft_sw[i].getI())))
                Log.d("Compare", "Imag[" + i + "]: " + String.format("%1.3f", dft[i].getI()) + " vs " + String.format("%1.3f", dft_sw[i].getI()));
                }

                //Write output values to files
                for (int i = 0; i < signalSize; i++) {
                    //Real component
                    double norm_dval = 2 * dft[i].getR() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    int norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    String norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path, dblclkfft_real_file, norm_st);

                    //Imaginary component
                    norm_dval = 2 * dft[i].getI() / norm_abs; //normalise output value, range [-1 1]

                    //Convert double to hex string
                    norm_intval = Float.floatToRawIntBits((float) norm_dval); //normalised integer value, convert to float for IEEE 754 float single precision

                    norm_st = String.format("%8s", Integer.toHexString(norm_intval)).replace(' ', '0') + "\n"; //normalised hex string

                    //Write normalised hex string to file (IEEE 754 float single precision format)
                    writeDataToFile(MainActivity.path,dblclkfft_imag_file, norm_st);

                }
                Log.i("Output data", "Created real output data: " + dblclkfft_real_file + " !");
                Log.i("Output data", "Created imaginary output data: " + dblclkfft_imag_file + " !");
                */

                spd = SPD(dft);
                this.expSPD = spd;
                this.domF = dominantFrequency(spd);
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

    //Write data to file
    private void writeDataToFile(File path, String Filename , String Data) {

        if (Utility.isExternalStorageWritable()) { //If it is writable, it is readable too
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
            Log.e("writeDataToFile", "Cannot write to storage!");
        }
    }

    //Read data from file
    private Complex[] readDataFromFile(File path, String Filename, boolean unnormalise){

        Complex[] value = new Complex[signalSize];

        if (Utility.isExternalStorageWritable()) { //If it is writable, it is readable too
            try {
                String line;
                String s_real;
                String s_imag;
                double real;
                double imag;
                //Complex temp = new Complex(0,0);
                //int linenumber = 0;

                //open file @ path/filename
                File file = new File(path, Filename);

                if (file.exists()) {
                    FileReader fr = new FileReader(file);
                    BufferedReader in = new BufferedReader(fr);

                    //read line
                    line = in.readLine();

                    //while (line != null) {
                    for (int linenumber = 0; linenumber < signalSize; linenumber++) {

                        if (line == null) {
                            Log.i("readDataFromFile", "EOF, linenumber: " + linenumber);

                            for (int i = 0; i < signalSize; i++) {
                                Complex zero = new Complex(0, 0);
                                zero.setR(0.0);
                                zero.setI(0.0);
                                value[i] = zero;
                            }
                            break;
                        }

                        Complex temp = new Complex(0,0);

                        s_real = line.substring(8);    //get real part
                        s_imag = line.substring(0, 8); //get imaginary part

                        //convert Strings to double values
                        real = Float.intBitsToFloat((int)Long.parseLong(s_real, 16));
                        imag = Float.intBitsToFloat((int)Long.parseLong(s_imag, 16));

                        //unnormalise data?
                        if (unnormalise) {
                            real = norm_abs * real / 2;
                            imag = norm_abs * imag / 2;
                        }

                        //set values
                        temp.setR(real); //set real part
                        temp.setI(imag); //set imaginary part
                        value[linenumber] = temp;

                        //Increment linenumber
                        //linenumber++;

                        //read next line
                        line = in.readLine();
                    }
                    in.close();
                    return value;
                }
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }
        else{
            Log.e("readDataFromFile", "Cannot read from storage!");
        }
        return value;
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
