package com.example.anwender.empaticae4.Configuration;

import android.content.Context;
import android.os.SystemClock;
import android.widget.Toast;

import com.example.anwender.empaticae4.Main.Utility;

public class Timer {
    private long[] startTime;
    private long[] endTime;
    private Context context = null;

    public Timer(int timer, Context context) {
        this.startTime = new long[timer];
        this.endTime = new long[timer];
        this.context = context;
    }

    public void setStartTime(int timer) {
        this.startTime[timer] = SystemClock.elapsedRealtime();
    }

    public void setEndTime(int timer) {
        this.endTime[timer] = SystemClock.elapsedRealtime();
    }

    public String getTimer(int timer) {
        long elapsedMilliSeconds = this.endTime[timer] - this.startTime[timer];
        double elapsedSeconds = elapsedMilliSeconds / 1000.0;

        return String.valueOf(elapsedSeconds);
    }

    public String getTimerMilli(int timer) {
        long elapsedMilliSeconds = this.endTime[timer] - this.startTime[timer];

        return String.valueOf(elapsedMilliSeconds);
    }

    public void toastie(String text, int timer) {
        String printtext = text + " took " + this.getTimer(timer) + " seconds.\n" +
        text + " took " + this.getTimerMilli(timer) + " milliseconds.";
        Utility.toastie(this.context, printtext, Toast.LENGTH_LONG);
    }
}
