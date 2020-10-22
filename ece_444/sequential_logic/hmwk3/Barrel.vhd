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
signal mux_out      :   std_logic_vector(bit_depth-1 downto 0) := (others => '0');

begin
	Output <= reg;

    mux_process: process(Input, Sel, reg, right_shift, left_shift)
    begin 
        case Sel is
            when "00" =>    -- hold
                mux_out <= reg;
            when "01" =>    -- shift right
                right_shift <= std_logic_vector(unsigned(reg) srl Shift);
                mux_out <= reg(shift-1 downto 0) & right_shift(bit_depth-shift-1 downto 0);
            when "10" =>    -- shift left
                left_shift <= std_logic_vector(unsigned(reg) sll Shift);
                mux_out <= left_shift(bit_depth-1 downto shift) & reg(bit_depth-1 downto bit_depth-shift);
            when "11" =>    -- load
                mux_out <= Input;
            when others =>  -- When Select is wrong
                mux_out <= (others => 'X');
        end case;
    end process mux_process;

    reg_process: process(clk)
    begin
        if(rising_edge(clk)) then
            if (reset = '0') then
                reg <= (others => '0');
            else
                reg <= mux_out;
            end if;
        end if;
    end process reg_process;
end behavior;