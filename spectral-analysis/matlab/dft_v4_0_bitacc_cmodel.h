//-------------------------------------------------------------------------------
// Copyright (c) 2007 Xilinx, Inc.
// All rights reserved.
// $Id: dft_v4_0_bitacc_cmodel.h,v 1.2 2009/12/02 13:23:28 akennedy Exp $
// $Header: /devl/xcs/repo/env/Databases/ip/src2/L/dft_v4_0/lib/cmodel/bitacc/export/dft_v4_0_bitacc_cmodel.h,v 1.2 2009/12/02 13:23:28 akennedy Exp $
//-------------------------------------------------------------------------------
//    ____  ____
//   /   /\/   /
//  /___/  \  /   Vendor: 
//  \   \   \/    Version: 
//   \   \        Filename: 
//   /   /        Date Last Modified: 
//  /___/   /\    Date Created: 
//  \   \  /  \
//   \___\/\___\
//
// This text contains proprietary, confidential information of Xilinx,Inc.,
// is distributed under license from Xilinx, Inc., and may be used, copied
// and/or disclosed only pursuant to the terms of a valid license agreement
// with Xilinx, Inc.
//
// This copyright notice must be retained as part of this text at all times.
//
//-------------------------------------------------------------------------------

#ifndef dft_v4_0_bitacc_cmodel_h
#define dft_v4_0_bitacc_cmodel_h

#ifdef NT
#define DLLIMPORT __declspec(dllimport)
#else
#define DLLIMPORT
#endif

#ifndef Ip_xilinx_ip_dft_v4_0_DLL
#define Ip_xilinx_ip_dft_v4_0_DLL DLLIMPORT
#endif

#ifdef  __cplusplus
extern "C" {
#endif

struct xilinx_ip_dft_v4_0_generics
{
   char* C_XDEVICEFAMILY;    
   int   C_DATA_WIDTH; 

}; // xilinx_ip_dft_v4_0_generics


struct xilinx_ip_dft_v4_0_generics 
   xilinx_ip_dft_v4_0_get_default_generics();

struct xilinx_ip_dft_v4_0_bitacc_state
{
   struct xilinx_ip_dft_v4_0_generics generics;

}; // end xilinx_ip_dft_v4_0_bitacc_state

/**
* Create a new state structure for this C-Model.
*
* IMPORTANT: Client is responsible for calling xilinx_ip_dft_v4_0_destroy_bitacc() 
*            to free state memory.
*
* @param generics    Generics to be used to configure C-Model state.
*
* @returns xilinx_ip_dft_v4_0_bitacc_state*  Pointer to the internal state.                             
*/

Ip_xilinx_ip_dft_v4_0_DLL struct xilinx_ip_dft_v4_0_bitacc_state*
   xilinx_ip_dft_v4_0_bitacc_create_state( struct xilinx_ip_dft_v4_0_generics generics);


/**
* Destroy a state structure.
*
* @param state    State structure to be destroyed (freed in memory).                          
*/

Ip_xilinx_ip_dft_v4_0_DLL
void xilinx_ip_dft_v4_0_bitacc_destroy_state( struct xilinx_ip_dft_v4_0_bitacc_state* state );


/**
* Structure to capture all inputs to the DFT C-Model.
*
* 
* @param size              Description...
*
* @param xn_re             Input data (real component). 
* @param xn_im             Input data (imaginary component). 
*
* @param direction         Transform direction: 1=forward DFT (default), 0=inverse DFT (IDFT)
*/
struct xilinx_ip_dft_v4_0_inputs
{
  int size;                //@- point size
  int n2;                  //@- power of 2 of the size
  int n3;                  //@- power of 3 of the size 
  int n5;                  //@- power of 5 of the size

  int*  xn_re;             //@- Input data (real)
  int*  xn_im;             //@- Input data (imaginary)

  int   direction;         //@- Transform direction

}; // end xilinx_ip_dft_v4_0_inputs


/**
* Structure to capture all outputs from the DFT C-Model.
*
* Long description here...
*
* @param xk_re         Output data (real component).  
*                      
* @param xk_im         Output data (imaginary component). 
*                     
* @param blk_exp       Integer value of resulting block exponent 
*                      
*/
struct xilinx_ip_dft_v4_0_outputs
{
  int*  xk_re;          //@- Output data (real)
  int*  xk_im;          //@- Output data (imaginary)
  int   blk_exp;        //@- Block exponent
}; // xilinx_ip_dft_v4_0_outputs


/**
* Simulate this bit-accurate C-Model.
*
* Long description here...
*            
* @param     state      Internal state of this C-Model. State
*                       may span multiple simulations.
* @param     inputs     Inputs to this C-Model.
* @param     outputs    Outputs from this C-Model.
*
* @returns   Exit code   Zero for SUCCESS, Non-zero otherwise.
*/
Ip_xilinx_ip_dft_v4_0_DLL int xilinx_ip_dft_v4_0_bitacc_simulate
( 
 struct xilinx_ip_dft_v4_0_bitacc_state* state, 
 struct xilinx_ip_dft_v4_0_inputs        inputs, 
 struct xilinx_ip_dft_v4_0_outputs*      outputs 
);

#ifdef  __cplusplus
}
#endif


#endif // dft_v4_0_bitacc_cmodel_h
