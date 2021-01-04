package com.example.anwender.empaticae4.EWS;

import java.util.List;

public class boundaries {
    private float min_val;
    private float max_val;

    //Constructor: Requires input signal
    public boundaries(List<float[]> inputSignal){
        int signalSize = inputSignal.size();

        float temp_min = inputSignal.get(0)[0];
        float temp_max = inputSignal.get(0)[0];

        //search min/max boundaries
        for (int i = 1; i< signalSize; i++) {
            temp_min = Math.min(inputSignal.get(i)[0], temp_min);
            temp_max = Math.max(inputSignal.get(i)[0], temp_max);
        }

        //set boundaries
        this.min_val = temp_min;
        this.max_val = temp_max;
    }

    public float getMin() {
        return min_val;
    }

    public float getMax() {
        return max_val;
    }
}



