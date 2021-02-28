library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity counter is
    generic
    (
        max_count   : integer := 2**30;
        synch_reset : boolean := false
    );
    port
    (
        count       : out std_logic_vector(integer(ceil(log2(real(max_count))))-1 downto 0);
        strobe      : out std_logic;
        clk         : in std_logic;
        reset       : in std_logic
    );
end counter;

architecture behavior of counter is
    
constant bit_depth			:	integer := integer(ceil(log2(real(max_count))));
signal count_register		:	unsigned(bit_depth-1 downto 0) := (others => '0');

begin
	count <= std_logic_vector(count_register);
	
	synch_rst	: if synch_reset = true generate
		count_process: process(clk)
		begin
			if rising_edge(clk) then
				if ((reset = '0') or (count_register = max_count-1)) then
					count_register <= (others => '0');
				else
					count_register <= count_register + 1;
				end if;
			end if;
		end process;
	end generate;
	
	asynch_rst : if synch_reset = false generate
		count_process: process(clk, reset)
		begin
			if (reset = '0') then
				count_register <= (others => '0');
			elsif rising_edge(clk) then
				if (count_register = max_count-1) then
					count_register <= (others => '0');
				else 
					count_register <= count_register + 1;
				end if;
			end if;
		end process;
	end generate;
	
	output_process: process(count_register)
	begin
		strobe <= '0';
		if (count_register = max_count-1) then
			strobe <= '1';
		end if;
	end process;
end behavior;