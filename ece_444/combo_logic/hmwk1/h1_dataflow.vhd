library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity h1_dataflow is 
    Port
    (
        f3  : out std_logic;
        f2  : out std_logic;
        f1  : out std_logic;
        f0  : out std_logic;
        a   : in std_logic;
        b   : in std_logic;
        c   : in std_logic;
        d   : in std_logic
    );
end h1_dataflow;

architecture dataflow of h1_dataflow is
    begin
        f3 <= (a and not b) 
			or (not c and d) 
			or (not a and c and d) 
			or (a and c and not d);
        f2 <= (not b) 
			or (a and c) 
			or (not a and not c and d);
        f1 <= (a and not b and not c and not d) 
			or (a and not b and c and d) 
			or (not a and not c and d) 
			or (not a and b and d) 
			or (b and (c xor d));
        f0 <= (not a and b and not c and d) 
			or (not b and not c and not d) 
			or (a and not b) 
			or (a and c) 
			or (b and c and not d);
end dataflow;