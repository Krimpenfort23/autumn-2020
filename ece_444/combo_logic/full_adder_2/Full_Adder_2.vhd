-- Behavior Full Adder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_Adder_2 is
	port(
		s		: out std_logic;
		c_out	: out std_logic;
		x		: in std_logic;
		y		: in std_logic;
		c_in	: in std_logic
		);
end Full_Adder_2;

architecture behavior of Full_Adder_2 is
-- Create input and output vectors
signal inputs		: std_logic_vector(2 downto 0);
signal outputs		: std_logic_vector(1 downto 0);

begin 
	-- Combine inputs and outputs into std_logic_vector
	inputs <= c_in & x & y;
	c_out <= outputs(1);
	s <= outputs(0);
	
	-- Create the Full Added funtionality
	adder_proc : process(inputs)
	begin 
		case inputs is
			when "000" =>
				outputs <= "00";
			when "001" | "010" | "100" =>
				outputs <= "01";
			when "011" | "101" | "110" =>
				outputs <= "10";
			when "111" =>
				outputs <= "11";
			when others =>
				outputs <= (others => 'X');
		end case;
	end process adder_proc;
end behavior;