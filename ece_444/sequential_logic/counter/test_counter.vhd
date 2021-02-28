library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

use std.textio.all ;
use ieee.std_logic_textio.all ;

entity test_counter is
end;

architecture test of test_counter is

component counter is
	Generic (
		max_count						: integer := 2**30;
		synch_reset						: boolean := false);
	Port (
		count	  						: out std_logic_vector(integer(ceil(log2(real(max_count))))-1 downto 0);
		strobe	 						: out std_logic;
		clk     						: in std_logic;
		reset    						: in std_logic
	);
end component;

constant max_count						: integer := 10;
constant bit_depth						: integer := integer(ceil(log2(real(max_count))));

constant synch_reset					: boolean := true;
signal count_out						: std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal strobe_out       				: std_logic := '0';
signal reset_in		    				: std_logic := '0';
signal clk_in           				: std_logic := '0';

begin
	dev_to_test : counter 
		generic map (
			max_count => max_count,
			synch_reset => synch_reset)
		port map (
			count => count_out,
			strobe => strobe_out,
			clk => clk_in,
			reset => reset_in);
		
	clk_process : process
	  begin
		  wait for 10 ns;
		  clk_in <= not clk_in;
	end process clk_process;

	reset_process : process
	  begin
		  wait for 15 ns;
		  reset_in <= '1';
	end process reset_process;
	
end test;
