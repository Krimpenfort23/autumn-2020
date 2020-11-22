library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity LFSR_18 is
	Generic 
	(
		clocks_per_count	:	integer := 5000000
	);
	Port
	(
		count				:	out std_logic_vector(17 downto 0);
		clk					:	in std_logic;
		reset				:	in std_logic
	);
end LFSR_18;

architecture behavior of LFSR_18 is

constant bit_depth		:	integer := 18;
constant seed			:	std_logic_vector(bit_depth-1 downto 0) := b"00" & x"0001";
signal clock_counter 	:	integer range 0 to clocks_per_count;
signal strobe			: 	std_logic;
signal count_register	:	std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal MSB_in			:	std_logic;

begin
	count <= std_logic_vector(count_register(bit_depth-1 downto bit_depth-18));
	MSB_in <= count_register(bit_depth-18) xor count_register(bit_depth-11);
	
	counter_process: process(clk)
	begin
		if rising_edge(clk) then
			strobe <= '0';
			if ((clock_counter = clocks_per_count-1) or (reset = '0')) then
				clock_counter <= 0;
				strobe <= '1';
			else 
				clock_counter <= clock_counter + 1;
			end if;
		end if;
	end process counter_process;
	
	shift_process: process(clk)
	begin
		if rising_edge(clk) then
			if (reset = '0') then
				count_register <= seed;
			elsif(strobe = '1') then
				count_register <= MSB_in & count_register(bit_depth-1 downto 1);
			end if;
		end if;
	end process shift_process;
end behavior;