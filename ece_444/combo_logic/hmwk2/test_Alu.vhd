library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity test_Alu is
end;

architecture test of test_Alu is

component test_Alu
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

constant bit_depth          : integer := 32;
constant max_input_value    : integer := 2**(bit_depth-2);
constant mid_point          : integer := max_input_value / 2;

signal A_in             : std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal B_in             : std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal A_int_in         : integer := 0;
signal B_int_in         : integer := 0;
signal OpCode_in        : std_logic_vector(3 downto 0) := (others => '0');
signal Result_out       : std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal Error_out        : std_logic;

begin
    dev_to_test: Alu 
        generic map
        (
            bit_depth <= bit_depth;
        )
        port map
        (
            Result <= Result_out,
            Error <= Error_out,
            A <= A_in,
            B <= B_in,
            OpCode <= OpCode_in
        );

    stimulus : process
    -- Variables for Testbench
    variable ErrCount       : integer := 0;
    variable seed1, seed2   : positive;
    variable rand, rval     : real;

    begin 
        for i in 0 to 15 loop
            OpCode_in <= std_logic_vector(to_unsigned(i,4));
            for j in 0 to 99 loop
                UNIFORM(seed1, seed2, rand);
                rval := trunc(rand*real(max_input_value));
                A_in <= std_logic_vector(integer(rval)-mid_point, bit_depth);

                UNIFORM(seed1, seed2, rand);
                rval := trunc(rand*real(max_input_value));
                B_in <= std_logic_vector(integer(rval)-mid_point, bit_depth);

                A_int_in <= to_integer(signed(A_in));
                B_int_in <= to_integer(signed(B_in));

                case OpCode_in is
                    when "0000" =>
                        Result_out <= not A_in;
                    when "0001" =>
                        Result_out <= not B_in;
                    when "0010" =>
                        Result_out <= std_logic_vector(A_int_in + B_int_in);
                    when "0011" =>
                        Result_out <= std_logic_vector(A_int_in - B_int_in);
                    when "0100" =>
                        Result_out <= std_logic_vector(A_int_in sll 1);
                    when "0101" =>
                        Result_out <= std_logic_vector(A_int_in srl 2);
                    when "0110" =>
                        Result_out <= std_logic_vector(B_int_in sll 1);
                    when "0111" =>
                        Result_out <= std_logic_vector(B_int_in srl 2);
                    when "1000" =>
                        Flip:
                        for i in 0 to bit_depth-1 generate
                            A_in(i) <= A_in(bit_depth-1-i);
                        end generate Flip;
                        result_out <= A_in;
                    when "1001" =>
                        Flip:
                        for i in 0 to bit_depth-1 generate
                            B_in(i) <= B_in(bit_depth-1-i);
                        end generate Flip;
                        result_out <= B_in;
                    when "1010" =>
                        Result_out <= A_in and B_in;
                    when "1011" =>
                        Result_out <= A_in or B_in;
                    when others =>
                        Error_out <= '1';
                        Result_out <= (others => 'X');
                end case;
                wait for 1 ns;
            end loop;
        end loop;

        report "ALU Test Completed.";
    end stimulus;
end test ; -- test
