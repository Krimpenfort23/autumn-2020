library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.All;		-- for UNIFORM, trunc funtions
use std.textio.all;
use ieee.std_logic_textio.all;

entity test_Alu is
end;

architecture test of test_Alu is

component Alu
    generic 
    (
        bit_depth   :   integer := 32
    );
    port
    (
        Result      :   out std_logic_vector(bit_depth-1 downto 0);
        Error       :   out std_logic;
        A           :   in std_logic_vector(bit_depth-1 downto 0);
        B           :   in std_logic_vector(bit_depth-1 downto 0);
        OpCode      :   in std_logic_vector(3 downto 0)
    );
end component;

constant bit_depth          : 	integer := 32;
constant max_input_value    : 	integer := 2**(bit_depth-2);
constant mid_point          :	integer := max_input_value / 2;

signal A		: 	signed(bit_depth-1 downto 0) := to_signed(0,bit_depth);
signal B		: 	signed(bit_depth-1 downto 0) := to_signed(0,bit_depth);
signal Result	: 	signed(bit_depth-1 downto 0) := to_signed(0,bit_depth);
signal Expected	: 	std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal OpCode	: 	unsigned(3 downto 0) := to_unsigned(0,4);
signal Error	: 	std_logic := '0';
signal A_inv	:	signed(0 to bit_depth-1) := (others => '0');
signal B_inv	:	signed(0 to bit_depth-1) := (others => '0');

begin
    dev_to_test	: Alu 
        generic map
        (
            bit_depth => bit_depth
        )
        port map
        (
            signed(Result) => Result,
            Error => Error,
            A => std_logic_vector(A),
            B => std_logic_vector(B),
            OpCode => std_logic_vector(OpCode)
        );

		flip_process	: process(A, B, A_inv, B_inv)
		begin
			FlipA:
			for i in 0 to bit_depth-1 loop
				A_inv(i) <= A(i);
			end loop;
			FlipB:
			for i in 0 to bit_depth-1 loop
				B_inv(i) <= B(i);
			end loop;
		end process flip_process;

		expected_process	: process(OpCode, A, B, A_inv, B_inv)
		begin
			case to_integer(OpCode) is
				when 0 =>
					Expected <= not std_logic_vector(A);
				when 1 =>
					Expected <= not std_logic_vector(B);
				when 2 =>
					Expected <= std_logic_vector(A + B);
				when 3 =>
					Expected <= std_logic_vector(A - B);
				when 4 =>
					Expected <= std_logic_vector(A sll 1);
				when 5 =>
					Expected <= std_logic_vector(A srl 2);
				when 6 =>
					Expected <= std_logic_vector(B sll 1);
				when 7 =>
					Expected <= std_logic_vector(B srl 2);
				when 8 =>
					Expected <= std_logic_vector(A_inv);
				when 9 =>
					Expected <= std_logic_vector(B_inv);
				when 10 =>
					Expected <= std_logic_vector(A) and std_logic_vector(B);
				when 11 =>
					Expected <= std_logic_vector(A) or std_logic_vector(B);
				when others =>
					Error <= '1';
					Expected <= (others => 'X');
			end case;
		end process expected_process;

		stimulus : process
		-- Variables for Testbench
		variable ErrCount       : integer := 0;
		variable seed1, seed2   : positive;
		variable rand, rval     : real;
		
		begin 
			for i in 0 to 15 loop
				OpCode <= to_unsigned(i,4);
				for j in 0 to 99999 loop
					UNIFORM(seed1, seed2, rand);
					rval := trunc(rand*real(max_input_value));
					A <= to_signed(integer(rval), bit_depth);

					UNIFORM(seed1, seed2, rand);
					rval := trunc(rand*real(max_input_value));
					B <= to_signed(integer(rval), bit_depth);

					wait for 1 ns;
					
					if (Expected /= std_logic_vector(Result)) then
						report "The ALU is broken." severity warning;
						ErrCount := ErrCount+1;
					end if;
				end loop;
			end loop;

		if (ErrCount = 0) then
			report "SUCCESS!!! ALU Test Completed.";
		else
			report "The ALU is broken." severity warning;
		end if;
    end process stimulus;
end test ; -- test
