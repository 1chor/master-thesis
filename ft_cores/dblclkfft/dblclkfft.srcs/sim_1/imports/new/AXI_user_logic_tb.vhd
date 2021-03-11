----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2021 09:14:39 PM
-- Design Name: 
-- Module Name: AXI_user_logic_tb - bench
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


entity AXI_user_logic_tb is
generic
(
    C_S_AXI_DATA_WIDTH             : integer              := 64;
    C_S_AXI_ADDR_WIDTH             : integer              := 1
);

end AXI_user_logic_tb;

architecture bench of AXI_user_logic_tb is

    -- component declaration
	component user_logic is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 64;
		C_S_AXI_ADDR_WIDTH	: integer	:= 1
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component user_logic;
    
    -- constant declaration
    constant SIZE : positive := 128;
    constant DATA_WIDTH : positive := C_S_AXI_DATA_WIDTH;
    constant INPUT_WIDTH : positive := C_S_AXI_DATA_WIDTH/2;
    constant CLK_PERIOD : time := 10 ns;
    constant stop_clock : boolean := false;
    constant ZERO_PADDING : std_logic_vector(INPUT_WIDTH - 1 downto 0) := (others => '0');
           
    -- signal declaration
    signal S_AXI_ACLK                     :  std_logic;
    signal S_AXI_ARESETN                  :  std_logic;
    signal S_AXI_AWADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_AWVALID                  :  std_logic;
    signal S_AXI_WDATA                    :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_WSTRB                    :  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    signal S_AXI_WVALID                   :  std_logic;
    signal S_AXI_BREADY                   :  std_logic;
    signal S_AXI_ARADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_ARVALID                  :  std_logic;
    signal S_AXI_RREADY                   :  std_logic;
    signal S_AXI_ARREADY                  : std_logic;
    signal S_AXI_RDATA                    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_RRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_RVALID                   : std_logic;
    signal S_AXI_WREADY                   : std_logic;
    signal S_AXI_BRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_BVALID                   : std_logic;
    signal S_AXI_AWREADY                  : std_logic;
    signal S_AXI_AWPROT                   : std_logic_vector(2 downto 0);
    signal S_AXI_ARPROT                   : std_logic_vector(2 downto 0);
        
    shared variable ClockCount : integer range 0 to 50_000 := 10;
    signal sendIt : std_logic := '0';
    signal readIt : std_logic := '0';
        
    shared variable my_line : line;
    
    signal write_success : boolean := false;
        
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

    -- Instantiation of Axi Bus Interface S00_AXI
    uut : user_logic
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
        S_AXI_ACLK    => S_AXI_ACLK,
		S_AXI_ARESETN => S_AXI_ARESETN,
		S_AXI_AWADDR  => S_AXI_AWADDR,
		S_AXI_AWPROT  => S_AXI_AWPROT,
		S_AXI_AWVALID => S_AXI_AWVALID,
		S_AXI_AWREADY => S_AXI_AWREADY,
		S_AXI_WDATA	  => S_AXI_WDATA,
		S_AXI_WSTRB   => S_AXI_WSTRB,
		S_AXI_WVALID  => S_AXI_WVALID,
		S_AXI_WREADY  => S_AXI_WREADY,
		S_AXI_BRESP	  => S_AXI_BRESP,
		S_AXI_BVALID  => S_AXI_BVALID,
		S_AXI_BREADY  => S_AXI_BREADY,
		S_AXI_ARADDR  => S_AXI_ARADDR,
		S_AXI_ARPROT  => S_AXI_ARPROT,
		S_AXI_ARVALID => S_AXI_ARVALID,
		S_AXI_ARREADY => S_AXI_ARREADY,
		S_AXI_RDATA	  => S_AXI_RDATA,
		S_AXI_RRESP   => S_AXI_RRESP,
		S_AXI_RVALID  => S_AXI_RVALID,
		S_AXI_RREADY  => S_AXI_RREADY
	);
    
    -- clock generator process
    generate_clk : process
    begin
        while not stop_clock loop
            S_AXI_ACLK <= '0', '1' after CLK_PERIOD / 2;
            wait for CLK_PERIOD;
        end loop;
        wait;            
    end process;

    -- Initiate process which simulates a master wanting to write.
    -- This process is blocked on a "Send Flag" (sendIt).
    -- When the flag goes to 1, the process exits the wait state and
    -- execute a write transaction.
    send : process
    begin
        S_AXI_AWVALID <= '0';
        S_AXI_WVALID <= '0';
        S_AXI_BREADY <= '0';
        loop
            wait until sendIt = '1';
            wait until S_AXI_ACLK = '0';
            S_AXI_AWVALID <= '1';
            S_AXI_WVALID <= '1';
            wait until (S_AXI_AWREADY and S_AXI_WREADY) = '1';  --Client ready to read address/data        
            S_AXI_BREADY <= '1';
            wait until S_AXI_BVALID = '1';  -- Write result valid
            assert S_AXI_BRESP = "00" report "AXI data not written" severity failure;
            S_AXI_AWVALID <= '0';
            S_AXI_WVALID <= '0';
            S_AXI_BREADY <= '1';
            wait until S_AXI_BVALID = '0';  -- All finished
            S_AXI_BREADY <= '0';
        end loop;
    end process send;

    -- Initiate process which simulates a master wanting to read.
    -- This process is blocked on a "Read Flag" (readIt).
    -- When the flag goes to 1, the process exits the wait state and
    -- execute a read transaction.
    read : process
    begin
        S_AXI_ARVALID<='0';
        S_AXI_RREADY<='0';
        loop
            wait until readIt = '1';
            wait until S_AXI_ACLK = '0';
            S_AXI_ARVALID <= '1';
            S_AXI_RREADY <= '1';
            --wait until (S_AXI_RVALID and S_AXI_ARREADY) = '1';  --Client provided data
            wait until S_AXI_RVALID = '1';  --Client provided data
            wait until S_AXI_RVALID = '0';  --Client provided data
            assert S_AXI_RRESP = "00" report "AXI data not written" severity failure;
            S_AXI_ARVALID <= '0';
            S_AXI_RREADY <= '0';
        end loop;
    end process read;

    -- 
    tb : process
        
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
        
        -- function to write file content 32 bit
        impure function write_file32(filename: string; value: array_t) return boolean is
            file FileHandle : text open write_mode is filename;
            variable CurrentLine : line;
        begin
            for i in 0 to SIZE-1 loop
                hwrite(CurrentLine, value(i), right, word32_t'length);                            
                writeline(FileHandle, CurrentLine);
            end loop;
            
            return true;        
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
            S_AXI_AWADDR <= b"0";
            --send input data (only real part)
            S_AXI_WDATA <= ZERO_PADDING & val_real;
            S_AXI_WSTRB <= b"11111111";
            sendIt <= '1';                --Start AXI Write to Slave
            wait for 1 ns; sendIt <= '0'; --Clear Start Send Flag
            wait until S_AXI_BVALID = '1';
            wait until S_AXI_BVALID = '0';  --AXI Write finished
            S_AXI_WSTRB <= (others => '0');
        end procedure;
        
        -- procedure to read data
        procedure read_data(output_buffer_idx : integer) is
        begin
            S_AXI_ARADDR <= b"0";
            readIt <= '1';                --Start AXI Read from Slave
            wait for 1 ns; readIt <= '0'; --Clear "Start Read" Flag
            wait until S_AXI_RVALID = '1';
            output_buffer(output_buffer_idx) := S_AXI_RDATA;
            wait until S_AXI_RVALID = '0';
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
        
    begin
    
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        
        --Test Reset
        S_AXI_ARESETN <= '0';
        sendIt <= '0';
        
        wait until rising_edge(S_AXI_ACLK);
        wait until rising_edge(S_AXI_ACLK);
        wait until rising_edge(S_AXI_ACLK);
        S_AXI_ARESETN <= '1';
        wait until rising_edge(S_AXI_ACLK);
        
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
        
        for i in 0 to SIZE-1 loop
            --read output data
            read_data(output_buffer_idx);
            output_buffer_idx := output_buffer_idx + 1;
        end loop;
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
        end loop;    
        
        -- write output files
        write_success <= write_file32("../../../../TestData/simulation/dblclkfft_result_ones.txt", output_real);
        assert write_success = false report "Write file was not successful!" severity error;
        write_success <= false;
        write_success <= write_file32("../../../../TestData/simulation/dblclkfft_result_ones_imag.txt", output_imag);
        assert write_success = false report "Write file was not successful!" severity error;
        write_success <= false;
        
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
        
        for i in 0 to SIZE-1 loop
            --read output data
            read_data(output_buffer_idx);
            output_buffer_idx := output_buffer_idx + 1;
        end loop;
                
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
        end loop;               

        -- write output files
        write_success <= write_file32("../../../../TestData/simulation/dblclkfft_result_one_zeros.txt", output_real);
        assert write_success = false report "Write file was not successful!" severity error;
        write_success <= false;
        write_success <= write_file32("../../../../TestData/simulation/dblclkfft_result_one_zeros_imag.txt", output_imag);
        assert write_success = false report "Write file was not successful!" severity error;
        write_success <= false;
        
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
        
        real_in := read_file32("dblclkfft_input.txt");
        
        write(my_line, string'("Load Reference Output Buffers"));
        writeline(output, my_line);
        
        real_out := read_file32("dblclkfft_real.txt");
        imag_out := read_file32("dblclkfft_imag.txt");
        
        write(my_line, string'("Start FFT Test"));
        writeline(output, my_line);
        
        output_buffer_idx := 0;
        
        for i in 0 to SIZE-1 loop
            --send input data
            write_data(real_in(i));
        end loop;
        
        for i in 0 to SIZE-1 loop
            --read output data
            read_data(output_buffer_idx);
            output_buffer_idx := output_buffer_idx + 1;
        end loop;
        
        for i in 0 to SIZE-1 loop
            -- read output data
            output_real(i) := output_buffer(i)(DATA_WIDTH / 2 -1 downto 0);
            output_imag(i) := output_buffer(i)(DATA_WIDTH -1 downto DATA_WIDTH / 2);
        end loop;               

        -- write output files
        write_success <= write_file32("../../../../TestData/simulation/dblclkfft_result_real.txt", output_real);
        assert write_success = false report "Write file was not successful!" severity error;
        write_success <= false;
        write_success <= write_file32("../../../../TestData/simulation/dblclkfft_result_imag.txt", output_imag);
        assert write_success = false report "Write file was not successful!" severity error;
        write_success <= false;
                
        write(my_line, string'("Compare results"));
        writeline(output, my_line);
        
        compare_buffers(output_real, real_out, SIZE);
        compare_buffers(output_imag, imag_out, SIZE);
        
        write(my_line, string'("Done"));
        writeline(output, my_line);
        
        write(my_line, string'("-----------------------------------"));
        writeline(output, my_line);
        
        wait for 20 ns;
        
        -- End of simulation
        report "Not a real failure. Simulation finished successfully. Test completed successfully" severity failure;
        wait; -- will wait forever
    end process tb;

end bench;
