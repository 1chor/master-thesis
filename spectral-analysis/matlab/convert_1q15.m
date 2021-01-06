%convert integer fixed 1q15 format to float
function fval = convert_1q15(num)
    shift_by = 0;
    invert = 0;
    %num = arg;
    num_float = 0;

    %if num is negativ, num will be inverted (2's complement)
    if (num < 0)
        invert = 1;

        num = ~num;
        num = num + 1;
    end

    %for the 1q15 format we have to start at 15
    %the smallest part is 2^⁻15
    for i=15:-1:1
        % if lsb is 1
        if ( ( bitand(bitshift(num, -shift_by),1) ) == 1)
            %then add 2^-i
            num_float = num_float + 2^(-i);
        end
        shift_by = shift_by + 1;

        %calculate integer part to the left of the comma
        if ((i == 1) && ((bitshift(num, -shift_by)) > 0))
            num_float = num_float + bitshift(num, -shift_by);
        end
    end

    if (invert == 1)
        num_float = num_float * (-1);
    end

    fval = num_float;
end
