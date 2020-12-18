-- decrypt.vhd
-- decryption scheme to decrypt data from memory
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

entity decrypt is
generic(
	data_width 			: integer := 8;
	addr_size			: integer := 256);
port(
	dec_out				: out std_logic_vector(data_width-1 downto 0);
	enc_in				: in std_logic_vector(data_width-1 downto 0);
	addr_in				: in std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0);
	clk					: in std_logic;
	reset				: in std_logic);
end decrypt;

architecture behavior of decrypt is
  
constant keylength 		: integer := 18;
type KeyType is array (0 to keylength-1) of std_logic_vector(data_width-1 downto 0);
-- The key is "ECE501-VHDL-Design"
constant Key 			: Keytype := (x"45",x"43",x"45",x"35",x"30",x"31",x"2D", -- ECE501-
							x"56",x"48",x"44",x"4C",x"2D", -- VHDL-
							x"44",x"65",x"73",x"69",x"67",x"6E"); -- Design
signal addr_reg			: std_logic_vector(integer(ceil(log2(real(addr_size))))-1 downto 0) := (others => '0');
signal enc_reg			: std_logic_vector(data_width-1 downto 0) := (others => '0');
signal count 			: unsigned(data_width-1 downto 0) := (others => '0');
	
begin	
	-- mod counter
	count <= to_unsigned(to_integer(unsigned(addr_reg)) mod keylength, count'length);
	-- define the output
	dec_out <= enc_in(data_width-1 downto 0) xor Key(to_integer(count));
	-- register the inputs
	reg_proc: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then
				addr_reg <= (others => '0');
				enc_reg <= (others => '0');
			else
				addr_reg <= addr_in;
				enc_reg <= enc_in;
			end if;
		end if;
	end process reg_proc;
end behavior;
