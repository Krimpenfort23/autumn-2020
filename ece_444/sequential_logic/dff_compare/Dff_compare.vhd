library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Dff_compare is
    port
    (
        Q               : out std_logic;
        Q_combined      : out std_logic;
        D               : in std_logic;
        clk             : in std_logic;
        reset           : in std_logic
    );
end Dff_compare;

architecture behavior of Dff_compare is

component Dff_1
    port
    (
        Q       : out std_logic;
        D       : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic
    );
end component;

component Dff_2
    port
    (
        Q       : out std_logic;
        D       : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic
    );
end component;

constant synch_reset    : boolean := true;

begin
    combonational_dff   : Dff_1 
    port map
    (
        Q_comb, D, clk, reset
    );
    behavioral_dff  : Dff_2 
    generic map
    (
        synch reset
    )
    port map 
    (
        Q, D, clk, reset
    );
end behavior ; -- `behavior`