-- mult
-- combonational multiplier (unsigned)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mult is
    generic
    (
        input_size  :   integer := 8
    );
    port 
    (
        product     :   out unsigned(2*input_size-1 downto 0);
        data_ready  :   out std_logic;
        input_1     :   in unsigned(input_size-1 downto 0);
        input_2     :   in unsigned(input_size-1 downto 0);
        reset       :   in std_logic;
        start       :   in std_logic;
        clk         :   in std_logic
    );
end mult;

architecture behavior of mult is

signal input_1_reg      :   unsigned(input_size-1 downto 0);
signal input_2_reg      :   unsigned(input_size-1 downto 0);
signal data_ready_reg   :   std_logic;

begin
    data_ready <= data_ready_reg;
    input_process : process(clk)
    begin
        if (rising_edge(clk)) then
            data_ready_reg <= '0';
            if (reset = '0') then
                input_1_reg <= (others => '0');
                input_2_reg <= (others => '0');
            elsif (start = '1') then
                input_1_reg <= input_1;
                input_2_reg <= input_2;
            else
                data_ready_reg <= '1';
            end if;
        end if;
    end process input_process; -- input_process

    product <= input_1_reg * input_2_reg;
end behavior; -- behavior