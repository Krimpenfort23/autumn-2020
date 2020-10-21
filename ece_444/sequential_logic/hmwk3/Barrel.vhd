-- Barrel Shifter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Barrel is
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
end Barrel;

architecture behavior of Barrel is
signal right_shift  :   std_logic_vector(bit_depth-1 downto 0) := (others => 'X');
signal left_shift   :   std_logic_vector(bit_depth-1 downto 0) := (others => 'X');
signal reg          :   std_logic_vector(bit_depth-1 downto 0) := (others => 'X');

begin
    shift_process: process(Input, Shift, Reset)
    begin
        if (Reset = '1') then
            -- no reset
            if (Shift >= 0) then
                -- shift both left and right by a length of shift
                right_shift <= reg srl Shift;
                left_shift <= reg sll Shift;
            else
                -- shift is wrong
                right_shift <= (others => 'X');
                left_shift <= (others => 'X');
            end if
        else
            -- resets the register and resets the Output
            reg <= (others => 'X');
            Output <= (others => 'X');
        end if
    end process shift_process;

    s_process: process(Clk, Input, Sel, right_shift, left_shift, Output, Reset)
    begin 
        if (Reset = '0') then
            -- resets the register and resets the Output
            reg <= (others => 'X');
            Output <= (others => 'X');
        elsif rising_edge(Clk) then
            -- no reset
            case Sel is
                when '00' =>
                    -- hold
                    Output <= reg;
                when '01' =>
                    -- shift right
                    reg <= right_shift;
                    Output <= reg;
                when '10' =>
                    -- shift left
                    reg <= left_shift;
                    Output <= reg;
                when '11' =>
                    -- load
                    reg <= Input;
                    Output <= reg;
                when others =>
                    -- When Select is wrong
                    reg <= (others => 'X');
                    Output <= (others => 'X');
            end case;
        end if
    end process s_process;
end behavior;