library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.sim_mem_init.all;

entity memory_2 is
    generic
    (
        addr_size   :   integer := 256;
        data_width  :   integer := 8;
        filename    :   string := "pi.mif"
    );
    port
    (
        data_out    :   out std_logic_vector(data_width-1 downto 0);
        data_in     :   in std_logic_vector(data_width-1 downto 0);
        read_addr   :   in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
        write_addr  :   in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
        clk         :   in std_logic;
        write_en    :   in std_logic
    );
end memory_2;

architecture behavior of memory_2 is

signal Mem              : MemType(0 to addr_size-1) := init_quartus_mem_8bit(filename, addr_size-1);
attribute ram_init_file : string;
attribute ram_init_file of Mem : signal is filename;

begin
    mem_process : process(clk)
    begin
        if (rising_edge(clk)) then
            if (write_en = '1') then
                Mem(to_integer(unsigned(write_addr))) <= data_in;
            end if;
        end if;
    end process mem_process; -- mem_process

    mem_read : process(clk)
    begin
        if (rising_edge(clk)) then
            data_out <= Mem(to_integer(unsigned(read_addr)));
        end if;
    end process mem_read; -- mem_read
end behavior; -- behavior