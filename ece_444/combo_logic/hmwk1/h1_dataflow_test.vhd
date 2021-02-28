library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity h1_dataflow_test is
end;

architecture test of h1_dataflow_test is

component h1_dataflow
    port
    (  
        f3  : out std_logic;
        f2  : out std_logic;
        f1  : out std_logic;
        f0  : out std_logic;
        a   : in std_logic;
        b   : in std_logic;
        c   : in std_logic;
        d   : in std_logic
    );
end component;

signal input			: std_logic_vector(3 downto 0);
signal test_output		: std_logic_vector(3 downto 0);
signal expected_output	: std_logic_vector(3 downto 0);

begin
    dev_to_test: h1_dataflow port map
    (
        f3 => test_output(3),
        f2 => test_output(2),
        f1 => test_output(1),
        f0 => test_output(0),
        a => input(3),
        b => input(2),
        c => input(1),
        d => input(0)
    );
    
    expected_proc : process(input)
    begin
        case input is
			when "0100" | "1100" =>
				expected_output <= "0000";
			when "0000" | "1111" =>
				expected_output <= "0101";
			when "1101" | "0111" =>
				expected_output <= "1010";
			when "0110" =>
				expected_output <= "0011";
			when "0010" =>
				expected_output <= "0100";
			when "0001" =>
				expected_output <= "1110";
			when "0011" =>
				expected_output <= "1100";
			when "1001" | "1010" =>
				expected_output <= "1101";
			when "0101" | "1000" | "1011" | "1110" =>
				expected_output <= "1111";
			when others =>
				expected_output <= (others => 'X');
		end case;
    end process;

    stimulus : process
    variable ErrorCount : integer := 0;
    variable WriteBuffer : line;

    begin
        for i in 0 to 15 loop
            input <= std_logic_vector(to_unsigned(i, input'length));

            wait for 5 ns;
			if (expected_output /= test_output) then
				write(WriteBuffer, string'("ERROR - FA test failed at: input = "));
				write(WriteBuffer, input);
				writeline(Output, WriteBuffer);
				
				write(WriteBuffer, string'("Output = "));
				write(WriteBuffer, test_output);
				writeline(Output, WriteBuffer);
				
				write(WriteBuffer, string'("Expected Output = "));
				write(WriteBuffer, expected_output);
				writeline(Output, WriteBuffer);
				writeline(Output, WriteBuffer);
				
				ErrorCount := ErrorCount + 1;
			end if;
			write(WriteBuffer, string'("Errors = "));
			write(WriteBuffer, ErrorCount);
			write(WriteBuffer, string'(". i = "));
			write(WriteBuffer, i);
			writeline(Output, WriteBuffer);
        end loop; 
        
        if (ErrorCount = 0) then
			report "SUCCESS! - HMWK1 Dataflow Test Completed.";
		else
			report "The HMWK1 Dataflow is broken." severity error;
		end if;
	end process stimulus;
end test;