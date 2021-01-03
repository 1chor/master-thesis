% -----------------------------------------------------
% check if cmodel is already compiled
% -----------------------------------------------------

if (~exist('dft_v4_0_bitacc_mex.mexa64'))
    disp('Compiling cmodel');
    make_dft_v4_0_mex;
end

% -----------------------------------------------------
% variable declarations
% -----------------------------------------------------

% Set up the point size for the function
n2 = 2;
n3 = 3;
n5 = 0;
size = 2^n2 * 3^n3 * 5^n5; % = 108

precision = 16;
fwdinv = 0; % use forward transformation

infile = './../TestData/input_TestData.txt';

imag_in = zeros(1, size);

% -----------------------------------------------------
% read files
% -----------------------------------------------------

fileID = fopen(infile, 'r');
data = textscan(fileID, '%s'); % read as string
fclose(fileID);

stringData = string(data{:}); % convert to hex string
real_in = hex2num(transpose(stringData)); % convert to float num

%saturate
for i=1:size    
   if(real_in(i)>=1)
       real_in(i) = real_in(i)/(real_in(i)+2^(1-precision));
   end
end

input = complex(real_in, imag_in); % convert to complex

% -----------------------------------------------------
% Call the bit accurate model
% -----------------------------------------------------

[result_dft, block_exp] = dft_v4_0_bitacc_mex(input, n2, n3, n5, fwdinv, precision);
num2hex(result_dft(1))
result_dft = result_dft * 2^block_exp; % apply shifts
num2hex(result_dft(1))

% -----------------------------------------------------
% Compare with built-in Matlab's double precision DFT
% -----------------------------------------------------

ref=ifft(input);
ref = size*ref;

% -----------------------------------------------------
% report maximum error
% ----------------------------------------------------- 
max_error = max(abs(result_dft-ref)/max(abs(ref)))

disp('Fin');