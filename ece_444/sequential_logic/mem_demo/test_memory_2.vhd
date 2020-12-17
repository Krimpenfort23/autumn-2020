library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

use std_textio.all;
use ieee.std_logic_textio.all;

entity test_memory_2 is
end;

architecture test of test_memory_2 is

component memory_2
    generic
    (
        addr_size   :   integer := 256;
        data_width  :   integer := 8;
        filename    :   string := "temp.mif"
    );
    port
    (
        data_out    :   out std_logic_vector(data_width-1 downto 0);
        data_in     :   in std_logic_vector(data_width-1 downto 0);
        read_addr   :   in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
        write_addr  :   in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
        clk         :   in std_logic;
        write_en    :   in std_logic
    );
end component;

constant addr_size  : integer := 256;
constant data_width : integer := 8;
constant filename   : string := "temp.mif";

signal data_in      : std_logic_vector(data_width-1 downto 0) := x"00";
signal data_out     : std_logic_vector(data_width-1 downto 0);
signal addr         : std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
signal wr_addr      : std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0) := x"00";
signal clk          : std_logic := '0';
signal written      : std_logic := '0';

begin
    dev_to_test : memory_2
        generic map(addr_size, data_width, filename)
        port map(data_out, data_in, addr, wr_addr, written);

    stimulus : process
    begin
        for i in 0 to addr_size-1 loop
            addr <= std_logic_vector(to_unsigned(i,addr'length));
            
            for j in 0 to 1 loop
                clk <= not clk;
                wait for 10 ns;
            end loop;
        end loop;
        report "Complete! memory_2 Test Completed.";
    end process ; -- stimulus
end test; -- test