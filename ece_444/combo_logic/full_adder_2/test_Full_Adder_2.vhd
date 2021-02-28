library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity test_Full_Adder_2 is
end;

architecture test of test_Full_Adder_2 is

component Full_Adder_2
	port
	(
		s		: out std_logic;
		c_out	: out std_logic;
		x		: in std_logic;
		y		: in std_logic;
		c_in	: in std_logic
	);
end component;

signal input			: std_logic_vector(2 downto 0);
signal test_output		: std_logic_vector(1 downto 0);
signal expected_output	: std_logic_vector(1 downto 0);

begin 
	dev_to_test: Full_Adder_2 port map 
	(
		s => test_output(0),
		c_out => test_output(1),
		x => input(0),
		y => input(1),
		c_in => input(2)
	);
		
	-- Create expected output behavior
	expected_proc : process(input)
	begin
		case input is 
			when "000" => 
				expected_output <= "00";
			when "001" | "010" | "100" =>
				expected_output <= "01";
			when "011" | "101" | "110" =>
				expected_output <= "10";
			when "111" =>
				expected_output <= "11";
			when others => 
				expected_output <= (others => 'X');
		end case;
	end process;
	
	stimulus : process
	-- Variable for test bench
	variable ErrorCount : integer := 0;
	variable WriteBuffer : line;
	
	begin 
		for i in 0 to 7 loop
			input <= std_logic_vector(to_unsigned(i, input'length));
			
			wait for 10 ns;
			if (expected_output /= test_output) then
				write(WriteBuffer, string'("ERROR - FA test failed at: input = "));
				write(WriteBuffer, input);
				writeline(Output, WriteBuffer);
				
				write(WriteBuffer, string'("Output = "));
				write(WriteBuffer, test_output);
				write(WriteBuffer, string'(". Expected Output = "));
				write(WriteBuffer, expected_output);
				
				ErrorCount := ErrorCount + 1;
			end if;
		end loop; 
		-- i
		
		if (ErrorCount = 0) then
			report "SUCCESS! - Full Adder Test Completed.";
		else
			report "The Full Adder is broken." severity error;
		end if;
	end process stimulus;
end test;