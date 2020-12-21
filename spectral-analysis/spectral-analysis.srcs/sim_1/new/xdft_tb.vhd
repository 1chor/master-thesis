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
            reset_n : in std_logic;
            regin : in std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0);
            regout : out std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0)
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
    signal reset_n : std_logic;
    signal data_in : std_logic_vector(DATA_WIDTH -1 downto 0);
    signal data_out : std_logic_vector(DATA_WIDTH -1 downto 0);
    
    shared variable my_line : line;
    
    -- type declaration
    subtype word16_t is std_logic_vector(INPUT_WIDTH -1 downto 0);
    type array_t is array(integer range 0 to SIZE -1) of word16_t;
    
    subtype word32_t is std_logic_vector(DATA_WIDTH -1 downto 0);
    type output_buf_t is array(integer range 0 to 2*SIZE -1) of word32_t;
    
    shared variable real_in : array_t;
    shared variable imag_in : array_t;
    
    shared variable output_buffer : output_buf_t;
    shared variable output_buffer_idx : integer := 0;

begin

    uut : xdft_wrapper
        generic map(
            SIZE => SIZE,
            C_S_AXI_DATA_WIDTH => DATA_WIDTH
        )
        port map( 
            clk => clk,
            reset_n => reset_n,
            regin => data_in,
            regout => data_out
        );
    
    -- testbench process
    stimulus : process
        
        variable output_real : output_buf_t;
        variable output_imag : output_buf_t;
        
        variable temp : word16_t;
        
        -- function to read file content 
        impure function read_file(filename: string) return array_t is
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
        
        -- procedure to compare two buffers
        procedure compare_buffers(buffer_A, buffer_B : output_buf_t; length : integer) is
        begin
            for i in 0 to length-1 loop
                report ("Buffers don't match (index = " & integer'image(i) & ", " & slv_to_hex(buffer_A(i)) & " vs. " & slv_to_hex(buffer_B(i))) severity error;
            end loop;
        end procedure;
        
        
        -- procedure to check output fill level
        procedure wait_for_output_buffer_fill_level(fill_level : integer) is
        begin
            loop
                wait for 100ns;
                if(output_buffer_idx = fill_level) then
                    exit;
                end if;
            end loop;
        end procedure;
        
    begin
    
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        
        --Test Reset
        reset_n <= '0';
        data_in <= (others => '0');
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        reset_n <= '1';
        wait until rising_edge(clk);
        
        write(my_line, string'("Load Input Buffers"));
        writeline(output, my_line);
        
        real_in := read_file("real_dft.txt");
        imag_in := read_file("imag_dft.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        -- real_in := read_file("real_dft.txt");
        -- imag_in := read_file("imag_dft.txt");
        
        write(my_line, string'("Start DFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            data_in <= imag_in(i) & real_in(i);
        end loop;
        
        wait_for_output_buffer_fill_level(2*SIZE);
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := output_buffer(2*i);
            output_imag(i) := output_buffer(2*i+1);
        end loop;
        
        write(my_line, string'("Compare results"));
        writeline(output, my_line);
        
        --compare_buffers(output_real, , SIZE);
        --compare_buffers(output_real, , SIZE);
        
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
            output_buffer(output_buffer_idx) := data_out;
            output_buffer_idx := output_buffer_idx + 1;
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
