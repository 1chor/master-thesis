%  (c) Copyright 2007-2011 Xilinx, Inc. All rights reserved.
%
%  This file contains confidential and proprietary information
%  of Xilinx, Inc. and is protected under U.S. and
%  international copyright and other intellectual property
%  laws.
%
%  DISCLAIMER
%  This disclaimer is not a license and does not grant any
%  rights to the materials distributed herewith. Except as
%  otherwise provided in a valid license issued to you by
%  Xilinx, and to the maximum extent permitted by applicable
%  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
%  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
%  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
%  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
%  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
%  (2) Xilinx shall not be liable (whether in contract or tort,
%  including negligence, or under any other theory of
%  liability) for any loss or damage of any kind or nature
%  related to, arising under or in connection with these
%  materials, including for any direct, or any indirect,
%  special, incidental, or consequential loss or damage
%  (including loss of data, profits, goodwill, or any type of
%  loss or damage suffered as a result of any action brought
%  by a third party) even if such damage or loss was
%  reasonably foreseeable or Xilinx had been advised of the
%  possibility of the same.
%
%  CRITICAL APPLICATIONS
%  Xilinx products are not designed or intended to be fail-
%  safe, or for use in any application requiring fail-safe
%  performance, such as life-support or safety devices or
%  systems, Class III medical devices, nuclear facilities,
%  applications related to the deployment of airbags, or any
%  other applications that could lead to death, personal
%  injury, or severe property or environmental damage
%  (individually and collectively, "Critical
%  Applications"). Customer assumes the sole risk and
%  liability of any use of Xilinx products in Critical
%  Applications, subject only to applicable laws and
%  regulations governing limitations on product liability.
%
%  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
%  PART OF THIS FILE AT ALL TIMES.
%
%_________________________________________________________________________
%
% Example run_dft_v4_0_mex.m file that demonstrates the call of the model
%_________________________________________________________________________

% Set up the point size for the function
n2 = 4;
n3 = 1;
n5 = 2;
size = 2^n2 * 3^n3 * 5^n5

precision = 18;

% generate some noise in the source
noise=0.5; 
s=noise*(rand(1, size)+sqrt(-1)*rand(1, size)-0.5*(1+sqrt(-1)));

% create a wave at the middle of the frequency range
freq = 3.1415926;
freq_noise = 0.0003;
for i=1:size
    freq = (rand(1)-0.5)*freq_noise+freq; % add some frequency instability
    s(i)=0.5*(sqrt(-1)*sin(i*freq)+cos(i*freq)+s(i));
    % saturate
    if(abs(s(i))>=1)
        s(i) = s(i)/(abs(s(i))+2^(1-precision));
    end
end

% Call the bit accurate model
[a b] = dft_v4_0_bitacc_mex(s, n2, n3, n5, 0, precision);

% Compare with built-in Matlab's double precision DFT
ref=ifft(s);
ref = size*ref;

% report maximum error
max_error = max(abs(a*2^b-ref)/max(abs(ref)))

% now you should see a nice, slightly noisy peak in the middle of the graph

for i=1:size
    x_axis(i)=i-1;
end

plot(x_axis, abs(a)*2^b)
