-- mem demo
-- implement a memory on the DE2 board
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity mem_demo is
    port (
        seg_out_1   :   out std_logic_vector(6 downto 0);
        seg_out_2   :   out std_logic_vector(6 downto 0);
        count       :   out std_logic_vector(7 downto 0);
        clk         :   in std_logic;
        reset       :   in std_logic
    );
end mem_demo;

architecture behavior of mem_demo is

component memory_2
    generic
    (
        addr_size   :   integer := 256;
        data_width  :   integer := 8;
        filename    :   string := "temp.mif"
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
end component;

component hex_to_7_seg
    port
    (
        seven_seg   : out std_logic_vector(6 downto 0);
        hex         : in std_logic_vector(3 downto 0)
    );
end component;

constant filename       :   string := "pi.mif";
constant addr_size      :   integer := 256;
constant data_width     :   integer := 8;
constant max_count      :   integer := 20000000;

signal counter          :   integer range 0 to max_count-1 := 0;
signal data_out         :   std_logic_vector(data_width-1 downto 0);
signal data_in          :   std_logic_vector(data_width-1 downto 0) := (others => '0');
signal written          :   std_logic := '0';
signal addr             :   integer range 0 to addr_size-1;
signal addr_slv         :   in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);

begin
    mem: memory_2
        generic map(addr_size, data_width, filename)
        port map(data_out, data_in, addr_slv, addr_slv, clk, written);
    
    seg1 : hex_to_7_seg
        port map(seg_out_1, data_out(7 downto 4));
    seg0 : hex_to_7_seg
        port map(seg_out_0, data_out(3 downto 0));

    counter_process : process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '0' or counter = max_count-1) then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process counter_process; -- counter_process

    second_counter_process : process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '0' or addr = addr_size-1) then
                addr <= 0;
            else
                addr <= addr + 1;
            end if;
        end if;
    end process second_counter_process; -- second_counter_process
    
    addr_slv <= std_logic_vector(to_unsigned(addr, addr_slv'length));
    count <= addr_slv;
    data_in <= addr_slv;
end behavior; -- behavior