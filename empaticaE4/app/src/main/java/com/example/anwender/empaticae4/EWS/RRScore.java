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
    public RRScore(){}
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
            result[i] = specAn.getDomF(0) * 60;
        }
        return (int)Math.abs(resultRR(result));
    }

    public int[] runAnalysis_AIO (List<Float> BVP, int max, int run){
        int[] result = new int[max/run];
        double[] res = new double[max/run];

        @SuppressWarnings("unchecked")
        List<float[]>[] wdRsFM = new List[max/run];

        for (int i = 0; i < max/run; i++) { // separate data in runs, needed for some functions
            filteredBVP = BVP.subList(run*i, run+run*i);

            List<float[]> rsFM = featExtraction();
            List<int[]> wd = windows(rsFM.size());
            //result = new double[wd.size()];

            for(int j=0;j<wd.size();j++){
                List<float[]> temp = rsFM.subList(wd.get(j)[0],wd.get(j)[1]);
                wdRsFM[i] = temp; // save all list values in an array
            }
        }

        SpectralAnalysis specAn = new SpectralAnalysis(wdRsFM, max, run);

        for (int i = 0; i < max/run; i++) {
            res[i] = specAn.getDomF(i) * 60;
            result[i] = (int) Math.abs(resultRR_AIO(res[i]));
        }

        clearBuffer();

        return result;
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

    //Method to calculate the RR:
    private double resultRR_AIO(double results){
        double rrResult =5.0;
        rrResult = results + rrResult;
        return  rrResult;
    }

    //Method to clear the variables after the analysis is completed.
    public void clearBuffer(){
        this.filteredBVP.clear();
    }

}
