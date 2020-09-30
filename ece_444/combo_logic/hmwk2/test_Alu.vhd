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

signal input
signal test_output
signal expected_output 

begin
    dev_to_test: Alu 
    generic map
    (

    );
    port map
    (

    );

end test ; -- test
