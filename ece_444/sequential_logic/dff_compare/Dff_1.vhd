library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Dff_1 is
    port
    (
        Q       : out std_logic;
        D       : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic
    );
end Dff_1;

architecture dataflow of Dff_1 is
signal s, r, w1, w2     : std_logic;
signal Q_out, Q_bar_out : std_logic;

begin
    Q <= Q_out;

    w1 <= not(w2 and s);
    s <= not(w1 and reset and clk);
    r <= not(s and clk and w2);
    w2 <= not(r and reset and D);

    Q_out <= not(s and Q_bar_out);
    Q_bar_out <= not(Q_out and r and reset);
end dataflow;