library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math.real.all;

entity counter is
    generic
    (
        max_count   : integer := 2**30;
        synch_reset : boolean := false
    );
    port
    (
        count       : out std_logic_vector(integer(cell(log2(real(max_count))))-1 downto 0);
        strobe      : out std_logic;
        clk         : in std_logic;
        reset       : in std_logic;
    );
end counter;

architecture behavior of counter is
    
end behavior;