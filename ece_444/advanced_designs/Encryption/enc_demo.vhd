-- enc_demo
-- implement an encrypted memory on the DE2 board
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

entity enc_demo is
	generic 
	(
		addr_size	: integer := 256
	);
	port 
	(
		seg_out_1	: out std_logic_vector(6 downto 0);
		seg_out_0	: out std_logic_vector(6 downto 0);
		count		: out std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
		clk			: in std_logic;
		dec			: in std_logic;
		reset		: in std_logic
		);
end enc_demo;

architecture behavior of enc_demo is
-- declaration of a memory with initialization file
component memory_2
	generic 
	(
		addr_size 	: integer := 256;
		data_width 	: integer := 8;
		filename 	: string := "temp.mif"
	);
	port 
	(
		data_out	: out std_logic_vector(data_width-1 downto 0);
		data_in		: in std_logic_vector(data_width-1 downto 0);
		read_addr	: in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
		write_addr	: in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
		clk			: in std_logic;
		write_en	: in std_logic
	);
end component;	
-- declaration of hex to 7-seg converter
component hex_to_7_seg
	port
	(
		seven_seg	: out std_logic_vector(6 downto 0);
		hex			: in std_logic_vector(3 downto 0)
	);	
end component;
-- declaration of a decryptor
component decrypt
	generic
	(
		data_width 	: integer := 8;
		addr_size	: integer := 256
	);
	port
	(
		dec_out		: out std_logic_vector(data_width-1 downto 0);
		enc_in		: in std_logic_vector(data_width-1 downto 0);
		addr_in		: in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
		clk			: in std_logic;
		reset		: in std_logic
	);
end component;
	
constant filename 		: string := "encrypt.mif";
constant data_width 	: integer := 8;

-- memory inputs.  we will not be writing to the RAM module 
constant writen			: std_logic := '0';
constant data_in		: std_logic_vector(data_width-1 downto 0) := (others => '0');
constant wr_addr  		: std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0) := (others => '0');	

-- memory outputs
signal data_out 		: std_logic_vector(data_width-1 downto 0);
signal mem_out  		: std_logic_vector(data_width-1 downto 0);
signal dec_out			: std_logic_vector(data_width-1 downto 0);
signal addr				: unsigned(integer(ceil(log2(real(addr_size))))-1 downto 0);

-- a counter is required to count to 50000000
constant maxcount 		: integer := 10000000 - 1;
signal counter 			: integer range 0 to maxcount := 0;

begin
	-- instantiate a memory
	mem : memory_2 
		generic map(addr_size, data_width, filename)
		port map(mem_out, data_in, std_logic_vector(addr), wr_addr, clk, writen); 
	-- instantiate 2 instances of the 7 seg converter 
	-- (upper and lower 4 bits of memory data)
	seg1 : hex_to_7_seg
		port map(seg_out_1,data_out(7 downto 4));
	seg0 : hex_to_7_seg
		port map(seg_out_0,data_out(3 downto 0));
	-- instantiate a decryptor
	dec0 : decrypt
		generic map(data_width,addr_size)
		port map(dec_out, mem_out, std_logic_vector(addr), clk, reset);
		
	-- now, we set up the counters
	counter_proc: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0' or counter = maxcount) then
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process counter_proc;
	second_count_proc: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0' or addr = addr_size-1) then
				addr <= (others => '0');
			elsif(counter = maxcount) then
				addr <= addr + 1;
			end if;
		end if;
	end process second_count_proc;
	-- assign inputs to the memory
	count <= std_logic_vector(addr);
	-- process to assign output (MUX)
	output_proc : process(dec, mem_out, dec_out)
	begin
		if(dec = '1') then
			data_out <= dec_out;
		else
			data_out <= mem_out;
		end if;
	end process output_proc;
end behavior;
