package com.example.anwender.empaticae4.EWS;
/*
    Created by Cayetano on 10.02.2020
 */

import com.example.anwender.empaticae4.Configuration.ConfigActivity;

import java.util.ArrayList;
import java.util.List;

//this class should analyze a window and return the std AM,BW and FM and the RR.
public class RRScore{

    private List<Float> filteredBVP;
    //Constructor
    public RRScore(List<Float> BVP){
        filteredBVP=BVP;
    }

    public int runAnalysis (){
        List<float[]> rsFM = featExtraction();
        List<int[]> wd = windows(rsFM.size());
        double[] result = new double[wd.size()];
        for(int i=0;i<wd.size();i++){
            List<float[]> wdRsFM = rsFM.subList(wd.get(i)[0],wd.get(i)[1]);
            SpectralAnalysis specAn = new SpectralAnalysis(wdRsFM);
            result[i] = specAn.getDomF() * 60;
        }
        return (int)Math.abs(resultRR(result));
    }

    //detect the peaks and save the location and the peak's values.
    private List<float[]> featExtraction (){
        float[] bvp = new float[filteredBVP.size()];
        for(int i=0;i<bvp.length;i++){
            bvp[i] = filteredBVP.get(i);
        }
        FeatExtract featEx = new FeatExtract(bvp);
        return featEx.getRsFM();
    }

    private List<int[]> windows(int rsFmSize){

        List<int[]> wd = new ArrayList<>();
        int windowSize = ConfigActivity.windowSize;
        for(int i=0;i<rsFmSize/windowSize;i++){
            wd.add(new int[]{(i*(windowSize)),(windowSize+i*(windowSize))});
        }
        return wd;
    }

    //Method to calculate the RR:
    private double resultRR(double[] results){
        double rrResult =5.0;
        for (double v :
                results) {
            rrResult=v+rrResult;
        }
        rrResult = rrResult/results.length;
        return  rrResult;
    }

    //Method to clear the variables after the analysis is completed.
    public void clearBuffer(){
        this.filteredBVP.clear();
    }

}
