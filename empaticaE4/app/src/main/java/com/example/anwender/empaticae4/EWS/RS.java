package com.example.anwender.empaticae4.EWS;

import org.apache.commons.math3.analysis.interpolation.LinearInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

import java.util.ArrayList;
import java.util.List;

/*This class resample the fm feature extracted and returns the new sampled fm feature.
* The main purpose is to resample the time and value of the FM.
* 1 - Resample method
* 2 - Interpolation method
* @param:
*       double[] fmTime
*       double[] fmValues
* @return
*       double[] fmTimesResampled
*       double[] fmValuesResampled
 */
public class RS {


    private List<float[]> rsFM = new ArrayList<>();
    private List<double[]> rsSPD = new ArrayList<>();

    public RS(List<float[]> fm){

        double[] fmTime = new double[fm.size()];
        double[] fmValues = new double[fm.size()];
        for(int i=0;i<fm.size();i++){
            fmTime[i] = fm.get(i)[1];
            fmValues[i] = fm.get(i)[0];
        }
        double[] fmTimesResampled = resample(fmTime,5);
        double[] fmValuesResampled = interpolation(fmTime,fmValues,fmTimesResampled);
        for(int v=0;v<fmValuesResampled.length;v++){
            this.rsFM.add(new float[]{(float)fmValuesResampled[v],(float)fmTimesResampled[v]});
        }
    }

    public RS(double[] spd){
        double[] fmTime = new double[spd.length];
        for (int i=0;i<fmTime.length;i++){
            if (i==0){
                fmTime[0]=0d;
            }else{
                fmTime[i] = fmTime[i-1] + ((double)2.5/fmTime.length);
            }
        }
        double[] fmTimesResampled = resample(fmTime,51.2d);
        double[] fmValuesResampled = interpolation(fmTime,spd,fmTimesResampled);
        for(int v=0;v<fmValuesResampled.length;v++){
            this.rsSPD.add(new double[]{fmValuesResampled[v],fmTimesResampled[v]});
        }
    }

    public List<float[]> getRsFM(){return this.rsFM;}
    public List<double[]> getRsSPD(){return this.rsSPD;}

    /**
     *
     * @param fmTime original time serie
     * @return At 5Hz resampled time serie
     */
    private double[] resample(double[] fmTime,double fs) {
        int mTimeSeriesSize = (int) ((fmTime[fmTime.length - 1] - fmTime[0]) * fs) ;
        double[] rsBuffer = new double[mTimeSeriesSize];
        rsBuffer[0] = fmTime[0];
        for (int i = 1; i < mTimeSeriesSize; i++) {
            rsBuffer[i] = rsBuffer[i - 1] + 1 / fs;
        }
        return rsBuffer;
    }

    /**
     *
     * @param fmTime original times values
     * @param fmValues original fm values
     * @param fmTimesResampled resampled times series
     * @return resampled fm values at the given time serie
     */
    private double[] interpolation(double[] fmTime,double[] fmValues, double[] fmTimesResampled){
        LinearInterpolator li = new LinearInterpolator();
        PolynomialSplineFunction psf = li.interpolate(fmTime,fmValues);

        double[] rsFmValues = new double[fmTimesResampled.length];
        for(int i=0;i<rsFmValues.length;i++){
            rsFmValues[i] = psf.value(fmTimesResampled[i]);
        }
        return rsFmValues;
    }
}
