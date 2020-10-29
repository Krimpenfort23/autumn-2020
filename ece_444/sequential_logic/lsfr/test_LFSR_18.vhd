library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use std.textio.all ;
use ieee.std_logic_textio.all ;

entity test_LFSR_18 is
end;

architecture test of test_LFSR_18 is

component LFSR_18 is
	Generic (
		clocks_per_count	: integer := 12500000);
	Port (
		count	  			: out std_logic_vector(17 downto 0);
		clk     			: in std_logic;
		reset    			: in std_logic
	);
end component;

constant bit_depth			: integer := 18;
constant clocks_per_count	: integer := 1;
signal count_out			: std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal reset_in		    	: std_logic := '0';
signal clk_in           	: std_logic := '0';

constant out_fname 			: string := "LFSR18_output.csv";
file output_file			: text;

begin
	dev_to_test : LFSR_18 
		generic map (
			clocks_per_count)
		port map (
			count => count_out,
			clk => clk_in,
			reset => reset_in);
		
	clk_proc : process
	begin
		wait for 10 ns;
		clk_in <= not clk_in;
	end process clk_proc;

	reset_proc : process
	begin
		wait for 15 ns;
		if(reset_in <= '0') then
			file_open(output_file, out_fname, write_mode);
		end if;
		reset_in <= '1';
	end process reset_proc;

	flag_proc : process(clk_in)
	begin
		if(rising_edge(clk_in)) then
			if(count_out = std_logic_vector(to_unsigned(1,bit_depth))) then
				report "The output of the LFSR is '1'";
			end if;
		end if;
	end process flag_proc;
	
	write_proc : process(clk_in)
	variable write_data : real;
	variable out_line : line;
	begin
		if(rising_edge(clk_in)) then
			if(reset_in = '1') then
				-- write the data to file
				write_data := real(to_integer(unsigned(count_out)));
				write(out_line, write_data, right, 5, 2);
				writeline(output_file,out_line);
			end if;
		end if;
	end process write_proc;
end test;
