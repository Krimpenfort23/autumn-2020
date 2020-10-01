library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use std.textio.all ;
use ieee.std_logic_textio.all ;

entity test_Dff_1 is
end;

architecture test of test_Dff_1 is
  
component Dff_1
	port (
		Q					: out std_logic;
		D					: in std_logic;
		clk					: in std_logic;
		reset				: in std_logic);
end component;

signal D_in 				: std_logic := '0';
signal clk 					: std_logic := '0';
signal Q_out				: std_logic;
signal expected				: std_logic := '0';
signal reset 				: std_logic := '0';

begin
   
	dev_to_test : Dff_1 port map (
		Q_out, D_in, clk, reset);
	
	expected_output:  process(clk, reset)
	begin
		if(reset = '0') then
			expected <= '0';
		elsif(rising_edge(clk)) then
			expected <= D_in;
		end if;
	end process expected_output;
		
	clk_proc: process
	begin
		wait for 10 ns;
		clk <= not clk;
	end process clk_proc;
	
	stimulus:  process
	-- Variables for testbench
	variable WriteBuf : line ;
	variable ErrCnt : integer := 0 ;
    begin  
		reset <= '0';
		wait for 10 ns;
		reset <= '1';
	
		for k in 0 to 5 loop
			for i in std_logic range '0' to '1' loop		
				D_in <= i;
						
				wait for 13 ns;  
				if(expected /= Q_out) then
					write(WriteBuf, string'("ERROR: D_type FF failed"));
					write(WriteBuf, string'(" at D_in = "));
					write(WriteBuf, i);
					ErrCnt := ErrCnt+1;
					writeline(Output, WriteBuf);
				end if;			
				end loop;			
		end loop;
		if (ErrCnt = 0) then 
			report "SUCCESS!!!  D_type FF Test Completed";
		else
			report "D_type FF device is broken" severity warning;
		end if;			  
	end process stimulus; 
end test;