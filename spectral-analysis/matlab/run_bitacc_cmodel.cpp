// $Id: run_bitacc_cmodel.c,v 1.3 2011/05/17 14:44:42 rwalke Exp $
//
//  Copyright(C) 2007-2008 by Xilinx, Inc. All rights reserved.
//  This text/file contains proprietary, confidential
//  information of Xilinx, Inc., is distributed under license
//  from Xilinx, Inc., and may be used, copied and/or
//  disclosed only pursuant to the terms of a valid license
//  agreement with Xilinx, Inc.  Xilinx hereby grants you
//  a license to use this text/file solely for design, simulation,
//  implementation and creation of design files limited
//  to Xilinx devices or technologies. Use with non-Xilinx
//  devices or technologies is expressly prohibited and
//  immediately terminates your license unless covered by
//  a separate agreement.
//
//  Xilinx is providing this design, code, or information
//  "as is" solely for use in developing programs and
//  solutions for Xilinx devices.  By providing this design,
//  code, or information as one possible implementation of
//  this feature, application or standard, Xilinx is making no
//  representation that this implementation is free from any
//  claims of infringement.  You are responsible for
//  obtaining any rights you may require for your implementation.
//  Xilinx expressly disclaims any warranty whatsoever with
//  respect to the adequacy of the implementation, including
//  but not limited to any warranties or representations that this
//  implementation is free from claims of infringement, implied
//  warranties of merchantability or fitness for a particular
//  purpose.
//
//  Xilinx products are not intended for use in life support
//  appliances, devices, or systems. Use in such applications are
//  expressly prohibited.
//
//  This copyright and support notice must be retained as part
//  of this text at all times. (c) Copyright 2007 Xilinx, Inc.
//  All rights reserved.
//-------------------------------------------------------------------

#include <iostream>
#include <cstdlib>

using namespace std;

#include "dft_v4_0_bitacc_cmodel.h"

#define _USE_MATH_DEFINES 
#include <math.h>

#ifndef M_PI
const double M_PI = 3.14159265358979323846;
#endif

static void dft(double *dout_r, double *dout_i, double *din_r, double *din_i, int size, int fwdinv);
static void scale(int *dout_r, int *dout_i, int *din_r, int *din_i, int n, int shift);

int main()
{
  // Generic for the smoke test 
  const int C_DATA_WIDTH = 18;
  int FWDINV = 0;    // 0:Inverse DFT, 1:Forward DFT

  // Declare generic struct and set to generics to test
  xilinx_ip_dft_v4_0_generics generics = {"virtex5", C_DATA_WIDTH } ;
  generics.C_DATA_WIDTH   = C_DATA_WIDTH;

  // Create DFT state (must be destroyed in the end)

  xilinx_ip_dft_v4_0_bitacc_state* state = xilinx_ip_dft_v4_0_bitacc_create_state(generics); 
  if (!state)
  {
    cerr << "ERROR: could not create DFT state object";
    return 1;
  }

  // Create data structure for DFT input and output arrays
  xilinx_ip_dft_v4_0_inputs inputs;
  xilinx_ip_dft_v4_0_outputs outputs;

  ////////////////////////////////////////
  // Test data generation

  // The supported point size table as powers of 2, 3 and 5
  int pnt[][3] = {
    {2,1,0}, // = 12
    {3,1,0}, // = 24 
    {2,2,0}, // = 36
    {4,1,0}, // = 48
    {2,1,1}, // = 60
    {3,2,0}, // = 72
    {5,1,0}, // = 96
    {2,3,0}, // = 108
    {3,1,1}, // = 120
    {4,2,0}, // = 144
    {2,2,1}, // = 180
    {6,1,0}, // = 192
    {3,3,0}, // = 216
    {4,1,1}, // = 240
    {5,2,0}, // = 288
    {2,1,2}, // = 300
    {2,4,0}, // = 324 
    {3,2,1}, // = 360
    {7,1,0}, // = 384
    {4,3,0}, // = 432
    {5,1,1}, // = 480
    {2,3,1}, // = 540
    {6,2,0}, // = 576
    {3,1,2}, // = 600
    {3,4,0}, // = 648
    {4,2,1}, // = 720
    {8,1,0}, // = 768
    {5,3,0}, // = 864
    {2,2,2}, // = 900
    {6,1,1}, // = 960
    {2,5,0}, // = 972
    {3,3,1}, // = 1080
    {7,2,0}, // = 1152
    {4,1,2}, // = 1200
    {4,4,0}  // = 1296
  };

  int table_size = sizeof(pnt)/sizeof(int)/3;
  int n2,n3,n5;                  // powers of 2, 3 and 5 for each point size
  int size;                      // number of points in a transform
  double *dr, *di, *refr, *refi; // double precision arrays for reference

  for(int size_index=0; size_index<table_size; size_index++ )
  {
    n2 = pnt[size_index][0];
    n3 = pnt[size_index][1];
    n5 = pnt[size_index][2];
    size = (int)( pow(2.0,(double)n2) * pow(3.0,(double)n3)*pow(5.0,(double)n5));

    // The model requires both the size and the power values
    inputs.size = size;
    inputs.n2 = n2;
    inputs.n3 = n3;
    inputs.n5 = n5;
    inputs.direction = FWDINV;

    // Allocate memories for input and output data
    inputs.xn_re = new int[size];
    inputs.xn_im = new int[size];
    outputs.xk_re = new int[size];
    outputs.xk_im = new int[size];

    dr = new double[size];
    di = new double[size];
    refr = new double[size];
    refi = new double[size];

    // Generate input data
    // Random complex inputs bounded -1.0<=x<1.0 in fixed point format
    int i;
    for(i=0; i<size; i++ )
    {
      inputs.xn_re[i] = (rand() & ((1<<C_DATA_WIDTH)-1)) - (1<<(C_DATA_WIDTH-1));
      inputs.xn_im[i] = (rand() & ((1<<C_DATA_WIDTH)-1)) - (1<<(C_DATA_WIDTH-1));

      dr[i] = (double)inputs.xn_re[i];
      di[i] = (double)inputs.xn_im[i];

    }

    // Reference DFT 
    dft(refr,refi, dr,di, size, FWDINV );

    // Bit accurate simulation
    xilinx_ip_dft_v4_0_bitacc_simulate(state, inputs, &outputs);

    // replace the block floating point result with fixed point
    int shift = outputs.blk_exp;
    scale(outputs.xk_re, outputs.xk_im, outputs.xk_re, outputs.xk_im, size, shift);


    // Calculate the maximum difference between the double precision FFT and the results
    // from the model.
    double max = 0;       // Normalisation value
    double df, maxdf = 0; // Running difference and max. difference

    for( i=0; i<size; i++ )
    {
      if( fabs(refr[i]) > max ) max = fabs(refr[i]);
      if( fabs(refi[i]) > max ) max = fabs(refi[i]);

      df = fabs((double)(outputs.xk_re[i]) - refr[i]);
      if( df > maxdf ) maxdf = df;

      df = fabs((double)(outputs.xk_im[i]) - refi[i]);
      if( df > maxdf ) maxdf = df;
    }

    // Report the quantization error
    cout << "Npoint=" << size <<"\tError=" << maxdf/max <<endl;

    // Free memory
    delete[] inputs.xn_re;
    delete[] inputs.xn_im;
    delete[] outputs.xk_re;
    delete[] outputs.xk_im;
    delete[] dr;
    delete[] di;
    delete[] refr;
    delete[] refi;

  }

  // Free memory allocated for DFT state
  xilinx_ip_dft_v4_0_bitacc_destroy_state(state);
}

static void scale(int *dout_r, int *dout_i, int *din_r, int *din_i, int size, int shift)
{
  int i;
  int s;

  s = (1<<shift);

  for( i=0; i<size; i++ )
  {
    dout_r[i] = (din_r[i]<<shift);
    dout_i[i] = (din_i[i]<<shift);
  }
}

// A straightforward double precision DFT calculation
static void dft(double *dout_r, double *dout_i, double *din_r, double *din_i, int size, int fwdinv)
{
  int m,k;
  double c,s, sr,si;

  if( fwdinv == 1 )
  {
    /* Forward DFT */
    for( k=0; k<size; k++ ){
      sr = si = 0.0;
      for( m=0; m<size; m++ ){
        c = cos(2.0*M_PI*(double)(k*m)/(double)size );
        s = -sin(2.0*M_PI*(double)(k*m)/(double)size );

        sr += c*din_r[m] - s*din_i[m];
        si += s*din_r[m] + c*din_i[m];
      }
      dout_r[k] = sr;
      dout_i[k] = si;
    }
  }
  else
  {
    /* Inverse DFT */
    for( k=0; k<size; k++ ){
      sr = si = 0.0;
      for( m=0; m<size; m++ ){
        c = cos(2.0*M_PI*(double)(k*m)/(double)size );
        s = sin(2.0*M_PI*(double)(k*m)/(double)size );

        sr += c*din_r[m] - s*din_i[m];
        si += s*din_r[m] + c*din_i[m];
      }
      dout_r[k] = sr;
      dout_i[k] = si;
    }
  }
}
