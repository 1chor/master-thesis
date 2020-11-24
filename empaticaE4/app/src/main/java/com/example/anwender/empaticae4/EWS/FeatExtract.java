package com.example.anwender.empaticae4.EWS;

import java.util.ArrayList;
import java.util.List;

/**
 * This class analyzed the filtered BVP signal.
 * It contains two steps:
 * The first one search for the peaks y extract the peaks
 * On the second it computes the fm signal and resample the signal
 * The output is the resampled fm signal
 */

public class FeatExtract {
    private List<float[]> rsFM;

    public FeatExtract(float[] filteredBVP){
        List<float[]> criticalV = getCriticalPoints(filteredBVP);
        List<float[]> posPeaks = removeThroughs(criticalV);
        criticalV.clear();
        List<float[]> peaks = separatePeaks(posPeaks);
        posPeaks.clear();
        List<float[]> fm = fmExtraction(peaks);
        this.rsFM = resampleFm(fm);
        fm.clear();
    }

    public List<float[]> getRsFM() {return this.rsFM;}

    /**
     *
     * @param bvp signal value. From it, the peaks should be extracted
     * @return double array[] = {critical point, position in the array}
     */
    private List<float[]> getCriticalPoints(float[] bvp){
        List<float[]> criticalValues = new ArrayList<>();
        for(int i=1;i<bvp.length-1;i++){
            //Positive peaks
            if((bvp[i-1]<bvp[i])&(bvp[i]>bvp[i+1])){
                criticalValues.add(new float[]{bvp[i],(float)(i+1)/64});
            }
            //negative Peaks
            if((bvp[i-1]>bvp[i])&(bvp[i]<bvp[i+1])){
                criticalValues.add(new float[]{bvp[i],(float)(i+1)/64});
            }
        }
        return criticalValues;
    }

    /**
     *
     * @param criticalV double[]={peak,pos} containing pos and neg peaks
     * @return List with double[]={Pospeak,pos} containing pos peaks
     */
    private List<float[]> removeThroughs(List<float[]> criticalV){
        List<float[]> posPeaks = new ArrayList<>();
        for (int i=1;i<criticalV.size()-1;i++){
            if((criticalV.get(i)[0]>criticalV.get(i-1)[0])&(criticalV.get(i)[0]>criticalV.get(i+1)[0])){
                posPeaks.add(criticalV.get(i));
            }
        }
        return posPeaks;
    }

    /**
     *
     * @param posPeaks float[]={Pospeak,pos} containing pos peaks
     * @return float[]={peaks,pos} containing valid peaks only
     */
    private List<float[]> separatePeaks(List<float[]> posPeaks){
        List<float[]> peaks = new ArrayList<>();
        peaks.add(posPeaks.get(0));
        for (int i=1;i<posPeaks.size()-1;i++){
            if((posPeaks.get(i)[1]-peaks.get(peaks.size()-1)[1])>0.4){
                if(((posPeaks.get(i)[0])<(posPeaks.get(i+1)[0]))&((posPeaks.get(i+1)[1]-posPeaks.get(i)[1])<0.4)){
                    peaks.add(posPeaks.get(i+1));
                }else {
                    peaks.add(posPeaks.get(i));
                }

            }
        }
        return peaks;
    }

    /**
     *
     * @param peaks {peaks,pos} containing valid peaks only
     * @return fm {fm.v,fm.t} containing the extracted fm
     */
    private List<float[]> fmExtraction(List<float[]> peaks){
        List<float[]> fm = new ArrayList<>();
        float[] distance = new float[peaks.size()-1];
        float[] distanceTime = new float[distance.length];
        float distanceMean;
        for(int i=1;i<peaks.size();i++){
            distance[i-1] = (peaks.get(i)[1]-peaks.get(i-1)[1]) / 64.0f;
            distanceTime[i-1]=(peaks.get(i)[1]+peaks.get(i)[1])/2f;
        }
        distanceMean = calculateMeanValue(distance);
        for(int u=0;u<distance.length;u++){
            fm.add(new float[]{distance[u]/distanceMean,distanceTime[u]});
        }
        return fm;
    }

    /**
     *
     * @param distance: array with the distance between peaks
     * @return the mean value of the distance array
     */
    private float calculateMeanValue(float[] distance){
        float result = 0;
        for (float v : distance) {
            result = result + v;
        }
        return result / (float)distance.length;
    }

    /**
     *
     * @param fm ArrayList of float[]={fm.v,fm.t}
     * @return resampled array float[]={rsFm.v,rsFm.t}
     */
    private List<float[]> resampleFm (List<float[]> fm){
        RS resampling = new RS(fm);
        return resampling.getRsFM();
    }
}
