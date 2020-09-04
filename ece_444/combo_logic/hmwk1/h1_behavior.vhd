library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity h1_behavior is 
    Port
    (
        f3  : out std_logic;
        f2  : out std_logic;
        f1  : out std_logic;
        f0  : out std_logic;
        a   : in std_logic;
        b   : in std_logic;
        c   : in std_logic;
        d   : in std_logic;
    );
end h1_behavior;

architecture behavior of h1_behavior is
    signal inputs   : std_logic_vector(3 downto 0);
    signal outputs  : std_logic_vector(3 downto 0);

    begin
        inputs <= a & b & c & d;
        f3 <= outputs(0);
        f2 <= outputs(1);
        f1 <= outputs(2);
        f0 <= outputs(3);

        h1_process  : process(inputs)
        begin
            case (inputs) is
                when "0100" | "1100" =>
                    outputs <= "0000";
                when "0100" | "1111" =>
                    outputs <= "0101";
                when "1101" | "0111" =>
                    outputs <= "1010";
                when "0110" =>
                    outputs <= "0011";
                when "0010" =>
                    outputs <= "0100";
                when "0001" =>
                    outputs <= "1110";
                when "0011" =>
                    outputs <= "1100";
                when "1001" | "1010" =>
                    outputs <= "1101";
                when "0101" | "1000" | "1011" | "1110" =>
                    outputs <= "1111";
                when others =>
                    outputs <= (others => "X");
            end case;
            
    end process h1_process;
end behavior;
