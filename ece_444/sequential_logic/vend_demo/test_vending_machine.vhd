-- test_mult_1.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all ;
use ieee.std_logic_textio.all ;
use work.sim_mem_init.all;

entity test_vending_machine is
end;

architecture test of test_vending_machine is
  
component vending_machine
port (
	money								: out unsigned(7 downto 0);
	product_out							: out std_logic;
	quarter_out							: out std_logic;
	dime_out							: out std_logic;
	nickel_out							: out std_logic;
	
	quarter_in							: in std_logic;
	dime_in								: in std_logic;
	nickel_in							: in std_logic;
	return_money						: in std_logic;
	
	reset								: in std_logic;
	clk									: in std_logic);
end component;

-- signals to connect the vending machine
signal money 							: unsigned(7 downto 0) := (others => '0');
signal product_out 						: std_logic := '0';
signal quarter_out		 				: std_logic := '0';
signal dime_out			 				: std_logic := '0';
signal nickel_out	 					: std_logic := '0';
signal quarter_in 						: std_logic := '0';
signal dime_in 							: std_logic := '0';
signal nickel_in	 					: std_logic := '0';
signal return_money 					: std_logic := '0';
signal reset 							: std_logic := '0';
signal clk 								: std_logic := '0';

constant in_fname 				: string := "vend_input.csv";
file input_file 				: text;

begin
   
	-- test the multiplier
	dev_to_test : vending_machine 
		port map (money, product_out, quarter_out, dime_out, nickel_out,
			quarter_in, dime_in, nickel_in, return_money, reset, clk);
								
	clk_proc: process
	begin
		clk <= not clk;
		wait for 10 ns;
	end process clk_proc;
	
	stimulus: process
	
	variable input_line			: line;
	variable in_char			: character;
	variable in_slv				: std_logic_vector(7 downto 0);
		
	begin
			  
		file_open(input_file, in_fname, read_mode);
		wait for 10 ns;
		reset <= '1';
		
		while not(endfile(input_file)) loop
                
			readline(input_file,input_line);
        	
			-- let's read the first 10 characters in the row
			for i in 0 to 9 loop
				read(input_line,in_char);
				in_slv := std_logic_vector(to_unsigned(character'pos(in_char),8));
			  
				if(i = 3) then
					quarter_in <= ASCII_to_hex(in_slv)(0);
				elsif(i = 5) then
					dime_in <= ASCII_to_hex(in_slv)(0);
				elsif(i = 7) then
					nickel_in <= ASCII_to_hex(in_slv)(0);
				elsif(i = 9) then
					return_money <= ASCII_to_hex(in_slv)(0);
				end if;
			end loop;
			
			wait for 20 ns;						
		end loop;
		file_close(input_file);		
		report "Vending Machine Test Completed";
	end process stimulus;
end test;