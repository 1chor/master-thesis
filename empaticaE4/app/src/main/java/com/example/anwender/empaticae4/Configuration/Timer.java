package com.example.anwender.empaticae4.Configuration;

import android.content.Context;
import android.os.SystemClock;
import android.widget.Toast;

import com.example.anwender.empaticae4.Main.Utility;

public class Timer {
    private long startTime = 0;
    private long endTime = 0;
    private Context context = null;

    public Timer(Context context) {
    this.context = context;
    }

    public void setStartTime() {
        this.startTime = SystemClock.elapsedRealtime();
    }

    public void setEndTime() {
        this.endTime = SystemClock.elapsedRealtime();
    }

    public String getTimer() {
        long elapsedMilliSeconds = this.endTime - this.startTime;
        double elapsedSeconds = elapsedMilliSeconds / 1000.0;

        return String.valueOf(elapsedSeconds);
    }

    public String getTimerMilli() {
        long elapsedMilliSeconds = this.endTime - this.startTime;

        return String.valueOf(elapsedMilliSeconds);
    }

    public void toastie(String text) {
        String printtext = text + " took " + this.getTimer() + " seconds.\n" +
        text + " took " + this.getTimerMilli() + " milliseconds.";
        Utility.toastie(this.context, printtext, Toast.LENGTH_LONG);
    }
}
