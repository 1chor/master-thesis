package com.example.anwender.empaticae4.EWS;

import java.util.ArrayList;
import java.util.List;

/*
 * This class should isolate the good period on which an good IBI signal was registered.
 * As Input are present: Whole BVP, InitalTime --> calculation of difference, IBITime on which was registered and IBI duration
 * Output: List<Double> with only the good period of point for further analysis.
 */
public class SBPTargetPeriod {
    private List<Float> TargetPeriod = new ArrayList<>();

    public SBPTargetPeriod(List<Float> BVP,float IBI){
        writeTimeStamp(BVP,IBI);
    }

    public List<Float> getTargetPeriod() {
        return TargetPeriod;
    }

    private void writeTimeStamp(List<Float> BVP, float IBI){
        int numerOfPoints = Math.round(IBI*(64));
        for(int i = numerOfPoints-1; i<BVP.size();i++){
            TargetPeriod.add(BVP.get(i));
        }
    }
}
