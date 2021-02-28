library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all ;
use ieee.std_logic_textio.all ;

entity test_Dff_compare is
end;

architecture test of test_Dff_compare is
component Dff_compare
port (Q					: out std_logic;
	  Q_comb			: out std_logic;
      D					: in std_logic;
      clk				: in std_logic;
      reset				: in std_logic);
end component;
signal D 				: std_logic := '0';
signal clk 				: std_logic := '0';
signal Q 				: std_logic;
signal Q_comb 			: std_logic;
signal reset 			: std_logic := '1';

begin
	dev_to_test : Dff_compare port map (
		Q, Q_comb, D, clk, reset);
	
 	d_stimulus: process
	begin
		for j in std_logic range '0' to '1' loop
			D <= j;
			wait for 23 ns;
		end loop;
	end process d_stimulus;
	
	clk_stimulus:  process
    begin
		reset <= '0';
		wait for 10 ns;
		reset <= '1';
		for i in  0 to 200 loop
			for k in std_logic range '0' to '1' loop	
				clk <= k;	
				wait for 10 ns;
			end loop;
		end loop;
	end process clk_stimulus;
end test;
