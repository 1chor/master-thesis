----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2021 10:24:33 PM
-- Design Name: 
-- Module Name: user_logic_tb - behav
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

entity user_logic_tb is
end user_logic_tb;

architecture behav of user_logic_tb is

     -- component for AXI peripheral user logic
    component user_logic is
         generic
         (
             -- ADD USER GENERICS BELOW THIS LINE ---------------
             --USER generics added here
             -- ADD USER GENERICS ABOVE THIS LINE ---------------
             
             -- DO NOT EDIT BELOW THIS LINE ---------------------
             -- Bus protocol parameters, do not add to or delete
             C_NUM_REG                      : integer              := 2;
             C_SLV_DWIDTH                   : integer              := 64
             -- DO NOT EDIT ABOVE THIS LINE ---------------------
         );
         port
         (
             -- ADD USER PORTS BELOW THIS LINE ------------------
             --USER ports added here
             -- ADD USER PORTS ABOVE THIS LINE ------------------
         
             -- DO NOT EDIT BELOW THIS LINE ---------------------
             -- Bus protocol ports, do not add to or delete
             Bus2IP_Clk                     : in  std_logic;
             Bus2IP_Resetn                  : in  std_logic;
             Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
             Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
             Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
             Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
             IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
             IP2Bus_RdAck                   : out std_logic;
             IP2Bus_WrAck                   : out std_logic;
             IP2Bus_Error                   : out std_logic
             -- DO NOT EDIT ABOVE THIS LINE ---------------------
         );
     end component user_logic;

    -- constant declaration
    constant SIZE : positive := 128;
    constant DATA_WIDTH : positive := 64;
    constant INPUT_WIDTH : positive := 32;
    constant C_NUM_REG : positive := 2;
    constant CLK_PERIOD : time := 10 ns;
    constant stop_clock : boolean := false;
    constant ZERO_PADDING : std_logic_vector(INPUT_WIDTH - 1 downto 0) := (others => '0');
    
    -- signal declaration
    signal Bus2IP_Clk                     : std_logic;
    signal Bus2IP_Resetn                  : std_logic;
    signal Bus2IP_Data                    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal Bus2IP_BE                      : std_logic_vector(DATA_WIDTH/8-1 downto 0);
    signal Bus2IP_RdCE                    : std_logic_vector(C_NUM_REG-1 downto 0);
    signal Bus2IP_WrCE                    : std_logic_vector(C_NUM_REG-1 downto 0);
    signal IP2Bus_Data                    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal IP2Bus_RdAck                   : std_logic;
    signal IP2Bus_WrAck                   : std_logic;
    signal IP2Bus_Error                   : std_logic;
    
--    signal clk : std_logic;
--    signal reset : std_logic;    
--    signal stin_data : std_logic_vector(DATA_WIDTH -1 downto 0);
--    signal stin_valid : std_logic;
--    signal stin_ready : std_logic;
--    signal stout_data : std_logic_vector(DATA_WIDTH -1 downto 0);
--    signal stout_valid : std_logic;
--    --signal stout_ready : std_logic;
            
    shared variable my_line : line;
    
    -- type declaration
    subtype word32_t is std_logic_vector(INPUT_WIDTH -1 downto 0);
    type array_t is array(integer range 0 to SIZE -1) of word32_t;
    
    subtype word64_t is std_logic_vector(DATA_WIDTH -1 downto 0);
    type output_buf_t is array(integer range 0 to SIZE -1) of word64_t;
    
    shared variable real_in : array_t;
    
    shared variable real_out : array_t;
    shared variable imag_out : array_t;
    
    shared variable output_buffer : output_buf_t;
    shared variable output_buffer_idx : integer := 0;
    
begin

    uut : user_logic
        generic map(
            C_NUM_REG       => C_NUM_REG,
            C_SLV_DWIDTH    => DATA_WIDTH
        )
        port map (
            Bus2IP_Clk      =>    Bus2IP_Clk,
            Bus2IP_Resetn   =>    Bus2IP_Resetn,
            Bus2IP_Data     =>    Bus2IP_Data,
            Bus2IP_BE       =>    Bus2IP_BE,
            Bus2IP_RdCE     =>    Bus2IP_RdCE,
            Bus2IP_WrCE     =>    Bus2IP_WrCE,
            IP2Bus_Data     =>    IP2Bus_Data,
            IP2Bus_RdAck    =>    IP2Bus_RdAck,
            IP2Bus_WrAck    =>    IP2Bus_WrAck,
            IP2Bus_Error    =>    IP2Bus_Error
        );
    
    -- testbench process
    stimulus : process
        
        variable output_real : array_t;
        variable output_imag : array_t;        
        
        -- function to read file content 32 bit
        impure function read_file32(filename: string) return array_t is
            file FileHandle : text open read_mode is filename;
            variable CurrentLine : line;
            variable TempWord : word32_t;
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
        
        -- function to read file content 64 bit
        impure function read_file64(filename: string) return output_buf_t is
            file FileHandle : text open read_mode is filename;
            variable CurrentLine : line;
            variable TempWord : word64_t;
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
        procedure write_data(val_real : std_logic_vector) is
        begin
            Bus2IP_WrCE <= "10";
            Bus2IP_BE <= "11111111";
            
            --send input data (only real part)
            Bus2IP_Data <= ZERO_PADDING & val_real;
            wait until rising_edge(Bus2IP_Clk);
            Bus2IP_WrCE <= "00";
            wait for 0 ns;
        end procedure;
        
        -- procedure to compare two buffers
        procedure compare_buffers(buffer_A, buffer_B : array_t; length : integer) is
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
        Bus2IP_Resetn <= '0';
        
        wait until rising_edge(Bus2IP_Clk);
        wait until rising_edge(Bus2IP_Clk);
        wait until rising_edge(Bus2IP_Clk);
        Bus2IP_Resetn <= '1';
        wait until rising_edge(Bus2IP_Clk);
        
        write(my_line, string'("All Ones Test:"));
        writeline(output, my_line);
        
        write(my_line, string'("Load Input Buffers"));
        writeline(output, my_line);
        
        real_in := read_file32("ones.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        real_out := read_file32("result_ones.txt");
        imag_out := read_file32("result_ones_imag.txt");
        
        write(my_line, string'("Start FFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            write_data(real_in(i));
        end loop;
        
        wait_for_output_buffer_fill_level(SIZE);
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
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
        
        real_in := read_file32("one_zeros.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        real_out := read_file32("result_one_zeros.txt");
        imag_out := read_file32("result_one_zeros_imag.txt");
        
        write(my_line, string'("Start FFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            write_data(real_in(i));
        end loop;
        
        wait_for_output_buffer_fill_level(SIZE);
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
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
        
        real_in := read_file32("xfft_input_TestData.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        real_out := read_file32("xfft_real_TestData.txt");
        imag_out := read_file32("xfft_imag_TestData.txt");
        
        write(my_line, string'("Start FFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            write_data(real_in(i));
        end loop;
        
        wait_for_output_buffer_fill_level(SIZE);
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
        end loop;               
        
        write(my_line, string'("Compare results"));
        writeline(output, my_line);
        
        compare_buffers(output_real, real_out, SIZE);
        compare_buffers(output_imag, imag_out, SIZE);
        
        write(my_line, string'("Done"));
        writeline(output, my_line);
        
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
       
       -- End of simulation
        report "Not a real failure. Simulation finished successfully. Test completed successfully" severity failure;
        wait;
        
    end process;
    
    -- read data output process
    read_data_output : process(Bus2IP_Clk)
    begin
        if (rising_edge(Bus2IP_Clk)) then            
--                output_buffer(output_buffer_idx) := stout_data;
--                output_buffer_idx := output_buffer_idx + 1;
        end if;
    end process;
    
    -- clock generator process
    generate_clk : process
    begin
        while not stop_clock loop
            Bus2IP_Clk <= '0', '1' after CLK_PERIOD / 2;
            wait for CLK_PERIOD;
        end loop;
        wait;            
    end process;

end behav;
