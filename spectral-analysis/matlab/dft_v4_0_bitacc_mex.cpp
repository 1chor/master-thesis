//  (c) Copyright 2007-2011 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by        
//  Xilinx, and to the maximum extent permitted by applicable     
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND     
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES   
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING     
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-        
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and      
//  (2) Xilinx shall not be liable (whether in contract or tort,  
//  including negligence, or under any other theory of            
//  liability) for any loss or damage of any kind or nature       
//  related to, arising under or in connection with these         
//  materials, including for any direct, or any indirect,         
//  special, incidental, or consequential loss or damage          
//  (including loss of data, profits, goodwill, or any type of    
//  loss or damage suffered as a result of any action brought     
//  by a third party) even if such damage or loss was             
//  reasonably foreseeable or Xilinx had been advised of the      
//  possibility of the same.                                      
//                                                                
//  CRITICAL APPLICATIONS                                         
//  Xilinx products are not designed or intended to be fail-      
//  safe, or for use in any application requiring fail-safe       
//  performance, such as life-support or safety devices or        
//  systems, Class III medical devices, nuclear facilities,       
//  applications related to the deployment of airbags, or any     
//  other applications that could lead to death, personal         
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical                    
//  Applications"). Customer assumes the sole risk and           
//  liability of any use of Xilinx products in Critical           
//  Applications, subject only to applicable laws and             
//  regulations governing limitations on product liability.
//                                                                
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS      
//  PART OF THIS FILE AT ALL TIMES.                               
//                                     
//-----------------------------------------------------------------------------
//  C model for dft_v4_0.  Matlab MEX interface example.
//-----------------------------------------------------------------------------
/*
* MATLAB MEX interface for dft_v4_0
* Only for MEX library generation
*
* How to compile - see make_mex_dft.m
*
*/

#include "dft_v4_0_bitacc_cmodel.h"
#include "mex.h"
#include "matrix.h"
#include <math.h>

// MATLAB function call: [dout blk_exp] = dft_v4_0(din,n2,n3,n5,fwdinv=0,precision=18);
void mexFunction( int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[] )
{
  const int MAX_DFT_POINTS = 1536; // the size is increased for future versions
  int C_DATA_WIDTH = 18;           // Default precision

  xilinx_ip_dft_v4_0_bitacc_state state, *dft_v4_0_state; 
  xilinx_ip_dft_v4_0_inputs  inputs;
  xilinx_ip_dft_v4_0_outputs outputs;

  int i;
  double *pParams[5];
  int overflowFlag;

  // Floating point input and output arrays
  double *din_re, *din_im;
  double *dout_re, *dout_im, *blk_exp;

  // Fixed-point input and output arrays
  int xr[MAX_DFT_POINTS], xi[MAX_DFT_POINTS];
  int yr[MAX_DFT_POINTS], yi[MAX_DFT_POINTS];
  int bexp;

  dft_v4_0_state = &state;
  // Since the state for DFT does not store any information between the runs nor
  // allocate any memory dynamically, there is no need to create or destroy it.

  // Check for the proper number of arguments 
  if( nrhs < 4 || nrhs > 6 )
    mexErrMsgTxt("Number of input arguments should be between four and six");
  if( nlhs != 2 )
    mexErrMsgTxt("Number of output arguments should be two");

  // Check that both data inputs are row vectors
  if( mxGetM(prhs[0]) != 1 )
    mexErrMsgTxt("Data input must be row vectors.");

  for( i=0; i<nrhs-1; i++ )
  {
    if( mxGetN(prhs[i+1]) != 1  )
      mexErrMsgTxt("The size of the parameters should be 1");

    if(!mxIsDouble(prhs[i])) 
       mexErrMsgTxt("The input values must be double.");
    else
      pParams[i] = mxGetPr(prhs[i+1]);
  }

  // Convert inputs into C function parameters
  inputs.n2 = (int)(*pParams[0]);
  inputs.n3 = (int)(*pParams[1]);
  inputs.n5 = (int)(*pParams[2]);
  
  if (nrhs>4)
    inputs.direction = (int)(*pParams[3]);
  else
    inputs.direction = (int)0; // default direction - inverse

  if(nrhs==6)
    C_DATA_WIDTH = (int)(*pParams[4]);
  else
    C_DATA_WIDTH = 18 ;       // default - 18 bits

  inputs.size = (int)(pow(2.0,(double)inputs.n2)* pow(3.0,(double)inputs.n3)* pow(5.0,(double)inputs.n5));
  if(inputs.size>MAX_DFT_POINTS) // currently the biggest supported size
    mexErrMsgTxt("The point size is out of range (bigger than 1536)");
  
  if( mxGetN(prhs[0]) != inputs.size )
    mexErrMsgTxt("The size of the input data does not match to one specified by (n2,n3,n5)");

  if(!mxIsDouble(prhs[0]) || !mxIsComplex(prhs[0])) 
    mexErrMsgTxt("The input array must be complex double vector.");

  din_re = mxGetPr(prhs[0]);
  din_im = mxGetPi(prhs[0]);

  // Convert to fix point format and check for an overflow
  overflowFlag = 0;
  double max_data_value =(double)(1<<(C_DATA_WIDTH-1));
  for( i=0; i<inputs.size; i++ )
  {
    xr[i] = (int)( din_re[i] * (double)(1<<(C_DATA_WIDTH-1)) );
    xi[i] = (int)( din_im[i] * (double)(1<<(C_DATA_WIDTH-1)) );

    // Check for overflow
    // real
    if(xr[i] >= max_data_value ||
       xr[i] < -max_data_value )
      overflowFlag = 1;

    // imaginary
    if(xi[i] >= max_data_value ||
       xi[i] < -max_data_value )
      overflowFlag = 1;
  }
  
  if( overflowFlag )
    mexErrMsgTxt("Input data out of range.");
  
  dft_v4_0_state->generics.C_DATA_WIDTH = C_DATA_WIDTH;
  inputs.xn_re = xr;
  inputs.xn_im = xi;

  outputs.xk_re = yr;
  outputs.xk_im = yi;

  int check = xilinx_ip_dft_v4_0_bitacc_simulate(dft_v4_0_state, inputs, &outputs);
  if(check != 0)
    mexErrMsgTxt("Internal error in the C model.");
 
  plhs[0] = mxCreateDoubleMatrix(1,inputs.size,mxCOMPLEX);
  dout_re = mxGetPr(plhs[0]);
  dout_im = mxGetPi(plhs[0]);
  plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
  blk_exp = mxGetPr(plhs[1]);

  // convert outputs from fix point to floating point complex
  for( i=0; i<inputs.size; i++ )
  {
    dout_re[i] = (double)yr[i] / (double)(1<<(C_DATA_WIDTH-1));
    dout_im[i] = (double)yi[i] / (double)(1<<(C_DATA_WIDTH-1));
  }
  
  blk_exp[0] = (double)outputs.blk_exp;
}
