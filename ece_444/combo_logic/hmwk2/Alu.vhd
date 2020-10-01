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
signal A_int        :   integer := 0;
signal B_int        :   integer := 0;

begin
	A_int <= to_integer(signed(A));
	B_int <= to_integer(signed(B));

    op_process : process(OpCode, A, B)
    begin
        case OpCode is
            when "0000" =>
                Result <= not A;
            when "0001" =>
                Result <= not B;
            when "0010" =>
                Result <= std_logic_vector(to_unsigned(A_int + B_int,Result'length));
            when "0011" =>
                Result <= std_logic_vector(A_int - B_int);
            when "0100" =>
                Result <= std_logic_vector(A_int sll 1);
            when "0101" =>
                Result <= std_logic_vector(A_int srl 2);
            when "0110" =>
                Result <= std_logic_vector(B_int sll 1);
            when "0111" =>
                Result <= std_logic_vector(B_int srl 2);
            when "1000" =>
                Flip:
                for i in 0 to bit_depth-1 generate
                    A(i) <= A(bit_depth-1-i);
                end generate Flip;
                result <= A;
            when "1001" =>
                Flip:
                for i in 0 to bit_depth-1 generate
                    B(i) <= B(bit_depth-1-i);
                end generate Flip;
                result <= B;
            when "1010" =>
                Result <= A and B;
            when "1011" =>
                Result <= A or B;
            when others =>
                Error <= '1';
                Result <= (others => 'X');
        end case;
    end process op_process;
end behavior;

