-- SMult.vhd, Booth's Algorithm
-- Serial Multiplier (signed)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SMult is
    generic
    (
        input_size      : integer := 8
    );
    port
    (
        product         : out signed(2*input_size-1 downto 0);
        data_ready      : out std_logic;
        input_1         : in signed(input_size-1 downto 0);
        input_2         : in signed(input_size-1 downto 0);
        start           : in std_logic;
        reset           : in std_logic;
        clk             : in std_logic
    );
end SMult;

architecture behavior of SMult is
-- state machine
type   state_type is (init, load, right_shift, done);
signal state, next_state        : state_type;

-- control signals
signal shift                    : std_logic;
signal add_A_and_shift          : std_logic;
signal add_S_and_shift          : std_logic;
signal load_data                : std_logic;

-- data signals
constant max_count              : integer := input_size-1;
signal A_reg                    : signed(2*input_size downto 0) := (others => '0');
signal S_reg                    : signed(2*input_size downto 0) := (others => '0');
signal P_reg                    : signed(2*input_size downto 0) := (others => '0');
signal AplusP                   : signed(2*input_size downto 0) := (others => '0');
signal SplusP                   : signed(2*input_size downto 0) := (others => '0');
signal count                    : integer range 0 to max_count := 0;
signal start_SMult_lead         : std_logic := '0';
signal start_SMult_follow       : std_logic := '0';
signal start_SMult              : std_logic := '0';

begin
    -- edge detection circuitry
    -- start_count = '1'on the rising edge of the start input
    start_SMult <= start_SMult_lead and (not start_SMult_follow);
    start_SMult_process :   process(clk)
        if (rising_edge(clk)) then
            if (reset = '0') then
                start_SMult_lead <= '0';
                start_SMult_follow <= '0';
            else
                start_SMult_lead <= start;
                start_SMult_follow <= start_SMult_lead;
            end if;
        end if;
    end process start_SMult_process;

    -- 2 process state machine
    -- state process 1
    state_process : process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '0') then
                state <= init;
            else
                state <= next_state;
            end if;
        end if;
    end process state_process;

    -- state machine 2
    state_machine : process(state, start, start_SMult, count, product_reg(0))
    begin
        -- init next_state and control signals
        next_state <= state;
        shift <= '0';
        add_A_and_shift <= '0';
        add_S_and_shift <= '0';
        load_data <= '0';
        data_ready <= '0';

        case state is
            when init =>
                if (start_SMult = '1') then
                    next_state <= load;
                end if;
            when load =>
                load_data <= '1';
                next_state <= right_shift;
            when right_shift =>
                if (count = max_count) then
                    next_state <= done;
                end if;
                if ((P_reg(0) = '1') and (P_reg(1) = '0')) then     -- 01
                    add_A_and_shift = '1';
                elsif ((P_reg(0) = '0') and (P_reg(1) = '1')) then  -- 10
                    add_S_and_Shift = '1';
                else                                                -- 00 or 01
                    shift <= '1';
                end if;
            when done =>
                data_ready <= '1';
                if (start = '0') then
                    next_state <= init;
                end if;
            when others =>
                next_state <= init;
        end case;      
    end process state_machine;
    
    -- create a counter to keep track of the adds and shifts
    count_process : process(clk)
    begin
        if (rising_edge(clk)) then
            if ((start_SMult = '1') or (reset = '0') or (count = max_count)) then
                count <= 0;
            elsif (state = right_shift) then
                count <= count + 1;
            end if;
        end if;
    end process count_process;

    -- calculate AplusP and SplusP
    AplusP <= P_reg + A_reg;
    SplusP <= P_reg + S_reg;
    -- define the multiplier process
    mult_process :  process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '0') then
                P_reg <= (others => '0');
                A_reg <= (others => '0');
                S_reg <= (others => '0');
            elsif (load_data = '1') then
                P_reg <= ((2*input_size downto input_size+1) => '0') & input_2(input_size downto 1) & '0';
                A_reg <= input_1(2*input_size downto input_size+1) & ((input_size downto 0) => '0');
                S_reg <= signed((input_1(2*input_size downto input_size+1) NAND '1') + '1') & ((input_size downto 0) => '0');
            elsif (add_A_and_shift = '1') then
                P_reg <= signed(AplusP sra 1);
            elsif (add_S_and_shift = '1') then
                P_reg <= signed(SplusP sra 1);
            elsif (shift = '1') then
                P_reg <= signed(P_reg sra 1);
            end if;
        end if;
    end process mult_process;

    -- define the output
    product <= P_reg;
end behavior;