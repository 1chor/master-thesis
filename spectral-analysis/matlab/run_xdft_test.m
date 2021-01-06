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

use_hex_float = true; % hex = true, float = false
normalised_data = true; % true = use already normalised input data, flase = calculate it
use_1q15 = true; % true = input data has 1q15 format

if ( (use_1q15 == true) && ( (normalised_data == false) || (use_hex_float == false) ) )
   error('This configuration is not possible!');
end

if (use_hex_float == true)
    if (normalised_data == true)
        if (use_1q15 == true)
            infile = './../TestData/input_TestData_norm16.txt';
        else
            infile = './../TestData/input_TestData_norm.txt';
        end
    else
        infile = './../TestData/input_TestData.txt';
    end
else
    if (normalised_data == true)
        infile = './../TestData/input_TestData_norm_float.txt';
    else
        infile = './../TestData/input_TestData_float.txt';
    end
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
    
    if (use_1q15 == true)
        for i=1:size
            stringData(i) = stringData{i}(1:end-4); % remove "0000" at end of string
            real_in(i) = convert_1q15(hex2dec(stringData(i)));
        end
        
    else
        real_in = typecast(uint32(hex2dec(stringData)),'single'); % convert to single float num
        % Single float is needed, otherwise matlab uses double float as default
        % and the convertion is not correct
        real_in = double(real_in); % convert the single float to double, needed by the dft
    end 
end

if (normalised_data == true)
    % limit data into range
    for i=1:size
        if (real_in(i) == 1)
            real_in(i) = real_in(i)/(real_in(i)+2^(1-precision));
        end
    end
    
    if (use_1q15 == true)
    	input = complex(real_in); % convert to complex
    else
        input = complex(transpose(real_in)); % convert to complex
    end
    
    norm_abs = 4.4371;% only valid with certain test data

else
    % Normalise values of the array to be between -1 and 1
    % original sign of the array values are maintained
    if abs(min(real_in)) > max(real_in)
        max_range_value = abs(min(real_in));
        min_range_value = min(real_in);
    else
        max_range_value = max(real_in);
        min_range_value = -max(real_in);
    end

    norm_abs = (max_range_value - min_range_value + 2^(1-precision));

    norm_real_in = 2 .* real_in ./ norm_abs; % normalise values
    input = complex(transpose(norm_real_in)); % convert to complex
end

% -----------------------------------------------------
% Call the bit accurate model
% -----------------------------------------------------

num2hex(input(1))
num2hex(single(input(1)))

[result_dft, block_exp] = dft_v4_0_bitacc_mex(input, n2, n3, n5, fwdinv, precision);
% conjugate the result and apply shifts and unnormalise
result_dft = conj(result_dft) .* 2^block_exp .* norm_abs ./ 2; 

%Beaware of float with single or double precision
num2hex(result_dft(1))
num2hex(single(result_dft(1)))

% -----------------------------------------------------
% Compare with built-in Matlab's double precision DFT
% -----------------------------------------------------

ref=fft(input);
% unnormalise
ref = ref .* norm_abs ./ 2;

% -----------------------------------------------------
% report maximum error
% ----------------------------------------------------- 
max_error = max(abs(result_dft-ref)/max(abs(ref)));

disp('max_error = ');
disp(max_error);

disp('Finish');




