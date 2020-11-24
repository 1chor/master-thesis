package com.example.anwender.empaticae4.EWS;

import java.util.List;

public class SBP {

    private float sbp;

    public SBP(List<Float> BVP, Float IBI){
        SBPTargetPeriod sbpTargetPeriod = new SBPTargetPeriod(BVP,IBI);
        List<Float> targetPeriod = sbpTargetPeriod.getTargetPeriod();
        double min = minSearch(targetPeriod);
        double max = maxSearch(targetPeriod);
        setSbp(SBPuniformModel(max,min));
    }

    private void setSbp(float sbp) {
        this.sbp = sbp;
    }

    public float getSbp() {
        return sbp;
    }

    private double minSearch(List<Float> bvp){
        double past = 0.0;
        for (Float point :
                bvp) {
            if(point<past){
                past = point;
            }
        }
        return past;
    }

    private double maxSearch(List<Float> bvp){
        double last = 0.0;
        for (Float point :
                bvp) {
            if (point > last){
                last = point;
            }
        }
        return  last;
    }

    private float SBPuniformModel(Double max, Double min){
        float result = (float)(115.6 + ((0.754)*Math.abs(max-3)));
        return result;
    }
}
