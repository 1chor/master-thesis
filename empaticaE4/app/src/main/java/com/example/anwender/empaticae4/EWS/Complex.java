package com.example.anwender.empaticae4.EWS;
//This class declares a complex number. This number is going to be needed for the FFT calculation.
//It's contains besides the getters and setters, 4 basic functions: +,-,*,||
public class Complex {
    double r;
    double i;

    //Constructor
    public Complex(double real, double imag){
        this.r=real;
        this.i=imag;
    }

    public double getI() {
        return i;
    }

    public double getR() {
        return r;
    }

    public void setI(double i) {
        this.i = i;
    }

    public void setR(double r) {
        this.r = r;
    }

    public Complex plus(Complex secondNumb){
        return new Complex(r+secondNumb.getR(),i+secondNumb.getI());
    }

    public double abs(){
        double result;
        result = Math.sqrt(Math.pow(r,2)+Math.pow(i,2));
        return result;
    }

}
