library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Dff_2 is
    generic
    (
        synch_reset     : boolean := true
    )
    port
    (
        Q       : out std_logic;
        D       : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic
    );
end Dff_2;

architecture behavior of Dff_2 is

begin
    synch   : if synch_reset = true generic
        Dff_process : process(clk)
        begin
            if (rising_edge(clk)) then
                if (reset = '0') then
                    Q <= '0';
                else
                    Q <= D;
                end if;
            end if;
        end process Dff_process;
    end generate;
    asynch  : if synch_reset = false generate
        Dff_process :   process(clk, reset)
        begin
            if (reset = '0') then 
                Q <= '0';
            elsif (rising_edge(clk)) then
                Q <= D;
            end if;
        end process Dff_process;
    end generate;
end behavior ; -- behavior