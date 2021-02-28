library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Alu is
    generic 
    (
        bit_depth   :   integer := 32
    );
    port
    (
        Result      :   out std_logic_vector(bit_depth-1 downto 0);
        Error       :   out std_logic := '0';
        A           :   in std_logic_vector(bit_depth-1 downto 0);
        B           :   in std_logic_vector(bit_depth-1 downto 0);
        OpCode      :   in std_logic_vector(3 downto 0)
    );
end Alu;

architecture behavior of Alu is
signal A_inv		:	std_logic_vector(0 to bit_depth-1) := (others => '0');
signal B_inv		:	std_logic_vector(0 to bit_depth-1) := (others => '0');

begin
	flip_process	: process(A, B, A_inv, B_inv)
	begin
		FlipA:
		for i in 0 to bit_depth-1 loop
			A_inv(i) <= A(i);
		end loop;
		FlipB:
		for i in 0 to bit_depth-1 loop
			B_inv(i) <= B(i);
		end loop;
	end process flip_process;

    op_process : process(OpCode, A, B, A_inv, B_inv)
    begin
        case to_integer(unsigned(OpCode)) is
            when 0 =>
                Result <= not A;
            when 1 =>
                Result <= not B;
            when 2 =>
                Result <= std_logic_vector(signed(A) + signed(B));
            when 3 =>
                Result <= std_logic_vector(signed(A) - signed(B));
            when 4 =>
                Result <= std_logic_vector(signed(A) sll 1);
            when 5 =>
                Result <= std_logic_vector(signed(A) srl 2);
            when 6 =>
                Result <= std_logic_vector(signed(B) sll 1);
            when 7 =>
                Result <= std_logic_vector(signed(B) srl 2);
            when 8 =>
                result <= A_inv;
            when 9 =>
                result <= B_inv;
            when 10 =>
                Result <= A and B;
            when 11 =>
                Result <= A or B;
            when others =>
                Error <= '1';
                Result <= (others => 'X');
        end case;
    end process op_process;
end behavior;

