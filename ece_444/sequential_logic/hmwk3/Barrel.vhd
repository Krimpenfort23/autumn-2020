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
signal right_shift  :   std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal left_shift   :   std_logic_vector(bit_depth-1 downto 0) := (others => '0');
signal reg          :   std_logic_vector(bit_depth-1 downto 0) := (others => '0');

begin
	Output <= reg;
	
    shift_process: process(Input, Shift, Reset, clk)
    begin
        if (Reset = '1' and rising_edge(clk)) then
            -- no reset
			right_shift <= std_logic_vector(unsigned(reg) srl Shift);
			left_shift <= std_logic_vector(unsigned(reg) sll Shift);
        else
            -- resets the register and resets the Output
            reg <= (others => '0');
        end if;
    end process shift_process;

    s_process: process(Clk, Input, Sel, right_shift, left_shift, Reset)
    begin 
        if (Reset = '0') then
            -- resets the register and resets the Output
            reg <= (others => '0');
        elsif rising_edge(Clk) then
            -- no reset
            case Sel is
                when "00" =>
                    -- hold
                    reg <= reg;
                when "01" =>
                    -- shift right
                    reg <= reg(shift-1 downto 0) & right_shift(bit_depth-shift-1 downto 0);
                when "10" =>
                    -- shift left
                    reg <= left_shift(bit_depth-1 downto shift) & reg(bit_depth-1 downto bit_depth-shift);
                when "11" =>
                    -- load
                    reg <= Input;
                when others =>
                    -- When Select is wrong
                    reg <= (others => 'X');
            end case;
        end if;
    end process s_process;
end behavior;