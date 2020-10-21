-- test Barrel Shifter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use std.textio.all;
use ieee.std_logic_testio.all;

use work.sim_mem_unit.all;

entity Barrel is 
end;

architecture test of test_Barrel is

component Barrel 
    generic
    (
        bit_depth   :   integer := 8
    );
    port
    (
        Output  :   out std_logic_vector(bit_depth-1 downto 0);
        Input   :   in std_logic_vector(bit_depth-1 downto 0);
        Sel     :   in std_logic_vector(1 downto 0);
        Shift   :   in integer range 0 to bit_depth-1;
        Reset   :   in std_logic;
        Clk     :   in std_logic
    );
end component;

constant data_width     :   integer := 8;
signal data_in          :   std_logic_vector(data_width-1 downto 0);
signal data_out         :   std_logic_vector(data_width-1 downto 0);
signal expected         :   std_logic_vector(data_width-1 downto 0);
signal shift            :   integer range 0 to data_width-1;
signal sel              :   std_logic_vector(1 downto 0);
signal clk              :   std_logic := '1';
signal reset            :   std_logic := '1';

constant in_fname       :   string := "barrel_input.csv";
constant out_fname      :   string := "barrel_output.csv";
file input_file         :   text;
file output_file        :   text;

begin
    dev_to_test:    Barrel
        generic(data_width)
        port map(data_out, data_in, sel, shift, reset, clk);
    
    stimulus:   process
        variable input_line     : line;
        variable writeBuffer    : line;
        variable in_char        : charcter;
        variable in_slv         : std_logic_vector(9 downto 0);
        variable out_slv        : std_logic_vector(9 downto 0);
        variable errorCount     : integer := 0;

        begin
            file_open(input_file, in_fname, read_mode);
            file_open(output_file, out_fname, read_mode);

            while not(endfile(input_file)) loop
                readline(input_file, input_line);

                for i in 0 to 8 loop
                    read(input_line, in_char);
                    in_slv := std_logic_vector(to_unsigned(character'pos(in_char), 10));
                    if (i = 3) then
                        data_in(7 downto 4) <= ASCII_to_hex(in_slv);
                    elsif (i = 4) then
                        data_in(3 downto 0) <= ASCII_to_hex(in_slv);
                    elsif (i = 6) then
                        sel <= in_slv(1 downto 0);
                    elsif (i = 8) then
                        shift <= in_slv(1 downto 0);
                    end if
                end loop;

                readline(output_file, input_line);

                clk <= '0';
                wait for 10 ns;

                for i in 0 to 4 loop
                    read(input_line, in_char);
                    out_slv := std_logic_vector(to_unsigned(character'pos(in_char), 10));
                    if (i = 3) then
                        expected(7 downto 4) <= ASCII_to_hex(out_slv);
                    elsif (i = 4) then
                        expected(3 downto 0) <= ASCII_to_hex(out_slv);
                    end if
                end loop;

                clk <= '1';
                wait for 10 ns;

                if (expected /= data_out) then
                    write(writeBuffer, string'("ERROR: Barrel Shifter Failed."));
                    writeline(Output, WriteBuffer);

                    write(writeBuffer, string'("expected = "));
                    write(writeBuffer, expected);
                    writeline(Output, WriteBuffer);

                    write(writeBuffer, string'("actual = "));
                    write(writeBuffer, data_out);
                    writeline(Output, WriteBuffer);
                    errorCount := errorCount + 1;
                end if
            end loop;

            file_close(input_file);
            file_close(output_file);

            if (errorCount = 0) then
                report "SUCCESS: Barrel Shift Test Completed."
            else
                report "The Barrel Shifter is Broken." severity warning;
            end if
    end process stimulus;
end test;