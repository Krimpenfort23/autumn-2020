library library IEEE;
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
        Error       :   out std_logic;
        A           :   in std_logic_vector(bit_depth-1 downto 0);
        B           :   in std_logic_vector(bit_depth-1 downto 0);
        OpCode      :   in std_logic_vector(3 downto 0)
    );
end Alu;

architecture behavior of Alu is
signal A_int        :   integer := 0;
signal B_int        :   integer := 0;
signal Result_int   :   integer := 0;

A_int = to_integer(signed(A));
B_int = to_integer(signed(B));
begin
    op_process : process(OpCode, A, B)
    begin
        case OpCode is
            when "0000" =>
                Result_int <= not A_int;
            when "0001" =>
                Result_int <= not B_int;
            when "0010" =>
                Result_int <= A_int + B_int;
            when "0011" =>
                Result_int <= A_int - B_int;
            when "0100" =>
                Result_int <= A_int * 2;
            when "0101" =>
                Result_int <= A_int / 4;
            when "0110" =>
                Result_int <= B_int * 2;
            when "0111" =>
                Result_int <= B_int / 4;
            when "1000" =>
                Flip:
                for i in 0 to bit_depth-1 generate
                    A_int(i) <= A_int(bit_depth-1-i);
                end generate Flip;
            when "1001" =>
                Flip:
                for i in 0 to bit_depth-1 generate
                    B_int(i) <= B_int(bit_depth-1-i);
                end generate Flip;
            when "1010" =>
                Result_int <= A_int and B_int;
            when "1011" =>
                Result_int <= A_int or B_int;
            when "1100" | "1101" | "1110" | "1111" =>
                Error <= "1";
            when others =>
                Result <= (others => "X");
        end case;
    end process op_process;
end behavior;

