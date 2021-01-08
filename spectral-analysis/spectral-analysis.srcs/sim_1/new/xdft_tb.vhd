----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2020 08:25:35 PM
-- Design Name: 
-- Module Name: xdft_tb - bench
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

library STD;
use STD.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xdft_tb is
end xdft_tb;

architecture bench of xdft_tb is

     -- component for DFT wrapper
    component xdft_wrapper is
        generic (
            SIZE : positive := 108; -- default 108
            C_S_AXI_DATA_WIDTH : positive := 32
        );
        port ( 
            clk : in std_logic;
            reset : in std_logic;
            
            -- streaming sink (input)
            stin_data : in std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0);
            stin_valid : in std_logic;
            stin_ready : out std_logic;
            
            -- streaming source (ouput)
            stout_data : out std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0);
            stout_valid : out std_logic
            --stout_ready : in std_logic
        );
    end component;

    -- constant declaration
    constant SIZE : positive := 108;
    constant DATA_WIDTH : positive := 32;
    constant INPUT_WIDTH : positive := 16;
    constant CLK_PERIOD : time := 10 ns;
    constant stop_clock : boolean := false;
    
    -- signal declaration
    signal clk : std_logic;
    signal reset : std_logic;    
    signal stin_data : std_logic_vector(DATA_WIDTH -1 downto 0);
    signal stin_valid : std_logic;
    signal stin_ready : std_logic;
    signal stout_data : std_logic_vector(DATA_WIDTH -1 downto 0);
    signal stout_valid : std_logic;
    --signal stout_ready : std_logic;
    
    signal out_shift : std_logic_vector(DATA_WIDTH -1 downto 0) := (others => '0');
        
    shared variable my_line : line;
    
    -- type declaration
    subtype word16_t is std_logic_vector(INPUT_WIDTH -1 downto 0);
    type array_t is array(integer range 0 to SIZE -1) of word16_t;
    
    subtype word32_t is std_logic_vector(DATA_WIDTH -1 downto 0);
    type output_buf_t is array(integer range 0 to SIZE -1) of word32_t;
    
    shared variable real_in : array_t;
    shared variable imag_in : array_t;
    
    shared variable real_out : output_buf_t;
    shared variable imag_out : output_buf_t;
    
    shared variable output_buffer : output_buf_t;
    shared variable output_buffer_idx : integer := 0;
    
    --signal declaration for shifted output
    signal real_out_shifted : output_buf_t := (others => (others => '0'));
    signal imag_out_shifted : output_buf_t := (others => (others => '0'));
    
    signal signed16 : signed(INPUT_WIDTH -1 downto 0);
    signal signed32 : signed(DATA_WIDTH -1 downto 0);
    signal signed32_shifted : signed(DATA_WIDTH -1 downto 0);
    signal std_shifted : std_logic_vector(DATA_WIDTH -1 downto 0);

begin

    uut : xdft_wrapper
        generic map(
            SIZE => SIZE,
            C_S_AXI_DATA_WIDTH => DATA_WIDTH
        )
        port map( 
            clk         => clk,
            reset       => reset,
            stin_data   => stin_data,
            stin_valid  => stin_valid,
            stin_ready  => stin_ready,
            stout_data  => stout_data,
            stout_valid => stout_valid
            --stout_ready => stout_ready
        );
    
    -- testbench process
    stimulus : process
        
        variable output_real : output_buf_t;
        variable output_imag : output_buf_t;        
        
        -- function to read file content 16 bit
        impure function read_file16(filename: string) return array_t is
            file FileHandle : text open read_mode is filename;
            variable CurrentLine : line;
            variable TempWord : word16_t;
            variable Result : array_t := (others => (others => '0'));
        begin
            for i in 0 to SIZE-1 loop
                exit when endfile(FileHandle);
                
                readline(FileHandle, CurrentLine);
                hread(CurrentLine, TempWord);
                --report "TempWord: " & to_hstring(TempWord);
                Result(i) := TempWord;
            end loop;
            
            return Result;        
        end function;
        
        -- function to read file content 32 bit
        impure function read_file32(filename: string) return output_buf_t is
            file FileHandle : text open read_mode is filename;
            variable CurrentLine : line;
            variable TempWord : word32_t;
            variable Result : output_buf_t := (others => (others => '0'));
        begin
            for i in 0 to SIZE-1 loop
                exit when endfile(FileHandle);
                
                readline(FileHandle, CurrentLine);
                hread(CurrentLine, TempWord);
                --report "TempWord: " & to_hstring(TempWord);
                Result(i) := TempWord;
            end loop;
            
            return Result;        
        end function;
        
        -- function to convert std_logic_vector to hex string
        function slv_to_hex(slv : in std_logic_vector) return string is
            constant hex_digits : string(1 to 16) := "0123456789abcdef";
            constant num_hex_digits : integer := integer((slv'length+3)/4);
            variable ret_value : string(1 to num_hex_digits);
            variable zero_padded_slv : std_logic_vector((4*num_hex_digits)-1 downto 0) := (others => '0');
            variable r : integer := 0;
        begin
            zero_padded_slv(slv'range) := slv;
            loop
                ret_value(num_hex_digits-r) := hex_digits(to_integer(unsigned( zero_padded_slv( (r+1)*4-1 downto 4*r) ))+1);
                r := r + 1;
                if num_hex_digits-r = 0 then
                    exit;
                end if;
            end loop;
            
            return ret_value;
        end function;
        
        -- procedure to write data
        procedure write_data(val_real : std_logic_vector; val_imag : std_logic_vector) is
        begin
            if (stin_ready = '0') then
                wait until stin_ready = '1';
            end if;
            
            --send input data
            stin_data(DATA_WIDTH -1 downto DATA_WIDTH/2) <= val_imag;
            stin_data(DATA_WIDTH/2 -1 downto 0) <= val_real;
            stin_valid <= '1';
            wait until rising_edge(clk);
            stin_valid <= '0';
            wait for 0 ns;
        end procedure;
        
        -- procedure to compare two buffers
        procedure compare_buffers(buffer_A, buffer_B : output_buf_t; length : integer) is
        begin
            for i in 0 to length-1 loop
                if ( buffer_A(i) /= buffer_B(i) ) then
                    report ("Buffers don't match (index = " & integer'image(i) & ", " & slv_to_hex(buffer_A(i)) & " vs. " & slv_to_hex(buffer_B(i))) severity error;
                end if;
            end loop;
        end procedure;
        
        
        -- procedure to check output fill level
        procedure wait_for_output_buffer_fill_level(fill_level : integer) is
        begin
            loop
                wait for 100 ns;
                if(output_buffer_idx = fill_level) then
                    exit;
                end if;
            end loop;
        end procedure;
        
    begin
    
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        
        --Test Reset
        reset <= '1';
        stin_data <= (others => '0');
        stin_valid <= '0';
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        reset <= '0';
        wait until rising_edge(clk);
        
        write(my_line, string'("All Ones Test:"));
        writeline(output, my_line);
        
        write(my_line, string'("Load Input Buffers"));
        writeline(output, my_line);
        
        real_in := read_file16("ones.txt");
        imag_in := read_file16("zeros.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        real_out := read_file32("result_ones.txt");
        imag_out := read_file32("zeros.txt");
        
        write(my_line, string'("Start DFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            write_data(real_in(i), imag_in(i));
        end loop;
        
        wait_for_output_buffer_fill_level(SIZE);
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := x"0000" & output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := x"0000" & output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
        end loop;               

        write(my_line, string'("Compare results"));
        writeline(output, my_line);
        
        compare_buffers(output_real, real_out, SIZE);
        compare_buffers(output_imag, imag_out, SIZE);
        
        write(my_line, string'("Done"));
        writeline(output, my_line);
        
        --------------------------------------------------------------
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        --------------------------------------------------------------
        
        write(my_line, string'("First One, Others Zero Test:"));
        writeline(output, my_line);
        
        write(my_line, string'("Load Input Buffers"));
        writeline(output, my_line);
        
        real_in := read_file16("one_zeros.txt");
        imag_in := read_file16("zeros.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        real_out := read_file32("result_one_zeros.txt");
        imag_out := read_file32("zeros.txt");
        
        write(my_line, string'("Start DFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            write_data(real_in(i), imag_in(i));
        end loop;
        
        wait_for_output_buffer_fill_level(SIZE);
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := x"0000" & output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := x"0000" & output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
        end loop;               

        write(my_line, string'("Compare results"));
        writeline(output, my_line);
        
        compare_buffers(output_real, real_out, SIZE);
        compare_buffers(output_imag, imag_out, SIZE);
                
        write(my_line, string'("Done"));
        writeline(output, my_line);
        
        --------------------------------------------------------------
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        --------------------------------------------------------------
        
        write(my_line, string'("Real Input Test:"));
        writeline(output, my_line);
        
        write(my_line, string'("Load Input Buffers"));
        writeline(output, my_line);
        
        real_in := read_file16("input_TestData_norm16.txt");
        imag_in := read_file16("zeros.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        real_out := read_file32("real_TestData_norm32.txt");
        imag_out := read_file32("imag_TestData_norm32.txt");
        
        write(my_line, string'("Start DFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            write_data(real_in(i), imag_in(i));
        end loop;
        
        wait_for_output_buffer_fill_level(SIZE);
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := x"0000" & output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := x"0000" & output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
        end loop;               
        
        write(my_line, string'("Compare results"));
        writeline(output, my_line);
        
        compare_buffers(real_out_shifted, real_out, SIZE);
        compare_buffers(imag_out_shifted, imag_out, SIZE);
        
        write(my_line, string'("Done"));
        writeline(output, my_line);
        
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
       
        wait;
        
    end process;
    
    -- read data output process
    read_data_output : process(clk)
    begin
        if (rising_edge(clk)) then
            if stout_valid = '1' then
                output_buffer(output_buffer_idx) := stout_data;
                
                signed16 <= signed( stout_data( DATA_WIDTH / 2 -1 downto 0) );
                signed32 <= resize( signed( stout_data( DATA_WIDTH / 2 -1 downto 0) ), out_shift'length);
                signed32_shifted <= shift_left( resize( signed( stout_data( DATA_WIDTH / 2 -1 downto 0) ), out_shift'length), 7);
                std_shifted <= std_logic_vector( shift_left( resize( signed( stout_data( DATA_WIDTH / 2 -1 downto 0) ), out_shift'length), 7) );
                
                
                
                out_shift <= std_logic_vector( shift_left( resize( signed( stout_data( DATA_WIDTH / 2 -1 downto 0) ), out_shift'length), 7) );
                real_out_shifted(output_buffer_idx) <= std_logic_vector( shift_left( resize( signed( stout_data( DATA_WIDTH / 2 -1 downto 0) ), DATA_WIDTH), 7) );
                imag_out_shifted(output_buffer_idx) <= std_logic_vector( shift_left( resize( signed( stout_data( DATA_WIDTH -1 downto DATA_WIDTH / 2) ), DATA_WIDTH), 7) );
                output_buffer_idx := output_buffer_idx + 1;
            end if;
        end if;
    end process;
    
    -- clock generator process
    generate_clk : process
    begin
        while not stop_clock loop
            clk <= '0', '1' after CLK_PERIOD / 2;
            wait for CLK_PERIOD;
        end loop;
        wait;            
    end process;
    
end bench;
