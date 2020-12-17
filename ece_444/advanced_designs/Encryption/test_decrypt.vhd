library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

use std.textio.all ;
use ieee.std_logic_textio.all ;
use work.sim_mem_init.all;

entity test_decrypt is
end;

architecture test of test_decrypt is
  
component decrypt
generic(
	data_width 			: integer := 8;
	addr_size			: integer := 256);
port(
	dec_out				: out std_logic_vector(data_width-1 downto 0);
	enc_in				: in std_logic_vector(data_width-1 downto 0);
	addr_in				: in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
	clk					: in std_logic;
	reset				: in std_logic);
end component;

constant data_width 	: integer := 8;
constant addr_size		: integer := 256;

signal data_out 		: std_logic_vector(data_width-1 downto 0) := (others => '0');
signal data_in 			: std_logic_vector(data_width-1 downto 0) := (others => '0');
signal addr 			: unsigned(integer(ceil(log2(real(addr_size))))-1 downto 0) := (others => '0');
signal expected_out		: std_logic_vector(data_width-1 downto 0) := (others => '0');
signal reset 			: std_logic := '1';
signal clk 				: std_logic := '0';

constant in_fname 		: string := "decrypt_input.csv";
file input_file 		: text;

begin
	-- instantiate the decryption circuitry
	dev_to_test : decrypt 
		generic map(data_width, addr_size)
		port map(data_out, data_in, std_logic_vector(addr), clk, reset); 
	
	clk_proc : process
	begin
		wait for 10 ns;
		clk <= not clk;
	end process clk_proc;
	
	stimulus : process
	variable input_line : line;
	variable in_char	: character;
	variable in_slv		: std_logic_vector(7 downto 0);
	variable ErrCnt 	: integer := 0 ;
	variable WriteBuf 	: line ;
	
	begin	  
		file_open(input_file, in_fname, read_mode);	
		while not(endfile(input_file)) loop
			readline(input_file,input_line);
			-- let's read the first 7 characters in the row
			for i in 0 to 7 loop				
				read(input_line,in_char);
				in_slv := std_logic_vector(to_unsigned(character'pos(in_char),8));
				if i = 3 then
					data_in(7 downto 4) <= ASCII_to_hex(in_slv);
				elsif i = 4 then
					data_in(3 downto 0) <= ASCII_to_hex(in_slv);
				elsif i = 6 then
					expected_out(7 downto 4) <= ASCII_to_hex(in_slv);
				elsif i = 7 then
					expected_out(3 downto 0) <= ASCII_to_hex(in_slv);
				end if;
			end loop;
			wait for 20 ns;
			if(data_out /= expected_out) then
				write(WriteBuf, string'("ERROR:  Decryption Failure"));
				write(WriteBuf, string'("expected_out = "));
				write(WriteBuf, expected_out);
				write(WriteBuf, string'(", data_out = "));
				write(WriteBuf, data_out);
			
				writeline(Output, WriteBuf);
				ErrCnt := ErrCnt+1;
			end if;       
			addr <= addr + 1;
		end loop;		
		file_close(input_file);
		if (ErrCnt = 0) then 
			report "SUCCESS!!!  Decryption Test Complete";
	    else
			report "The Decryption device is broken" severity warning;
		end if;			  
	end process stimulus;  
end test;
