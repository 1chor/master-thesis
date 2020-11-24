package com.example.anwender.empaticae4.Main;


import java.io.FileReader;

import uk.me.berndporr.iirj.Butterworth;


public class FilterBVPData {

    //Sample frequency
    private double fBVP =64;

    //Filter to apply
    private Butterworth LowPassFilter = new Butterworth();
    private Butterworth HighPassFilter = new Butterworth();


    //Constructor
    public FilterBVPData(){
        LowPassFilter.lowPass(4, fBVP,5);
        HighPassFilter.highPass(4, fBVP,0.05);

    }


    //apply the Bandpass and return the filtered value
    public float filteredData(float bvp){
        float output=0;
        float firstFilter = filterSignal(bvp,HighPassFilter);
        output = filterSignal(firstFilter, LowPassFilter);
        return output;
    }

    /**
    *Private method to increase the readiness from code. It apply the given filter to the given
    *double value
     **/
    private float filterSignal(float bvpItem, Butterworth filter){
        return (float) filter.filter(bvpItem);
    }
}
