% -----------------------------------------------------
% check if cmodel is already compiled
% -----------------------------------------------------

if (~exist('dft_v4_0_bitacc_mex.mexa64', 'file'))
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

use_hex_float = false; % hex = true, float = false

if (use_hex_float == true)
    infile = './../TestData/input_TestData.txt';
else
    infile = './../TestData/input_TestData_float.txt';
end

% -----------------------------------------------------
% read files
% -----------------------------------------------------

fileID = fopen(infile, 'r');
if (use_hex_float == true)
    data = textscan(fileID, '%s'); % read as string
else
    real_in = fscanf(fileID, '%f', size); % read as float
end
fclose(fileID);

if (use_hex_float == true)
    stringData = string(data{:}); % convert to hex string
    real_in = hex2num(stringData); % convert to float num
end

% Normalise values of the array to be between -1 and 1
% original sign of the array values is maintained
if abs(min(real_in)) > max(real_in)
    max_range_value = abs(min(real_in));
    min_range_value = min(real_in);
else
    max_range_value = max(real_in);
    min_range_value = -max(real_in);
end

norm = (max_range_value - min_range_value + 2^(1-precision));
norm_real_in = 2 .* real_in ./ norm;

input = complex(transpose(norm_real_in)); % convert to complex

% -----------------------------------------------------
% Call the bit accurate model
% -----------------------------------------------------

[result_dft, block_exp] = dft_v4_0_bitacc_mex(input, n2, n3, n5, fwdinv, precision);
% conjugate the result and apply shifts and unnormalise
result_dft = conj(result_dft) .* 2^block_exp .* norm ./ 2; 

%num2hex(result_dft(1))

% -----------------------------------------------------
% Compare with built-in Matlab's double precision DFT
% -----------------------------------------------------

ref=fft(input);
% unnormalise
ref = ref .* norm ./ 2;

% -----------------------------------------------------
% report maximum error
% ----------------------------------------------------- 
max_error = max(abs(result_dft-ref)/max(abs(ref)));

disp('max_error = ');
disp(max_error);

disp('Finish');






