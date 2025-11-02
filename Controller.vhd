library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exp_controller is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        start    : in  std_logic;
        op_done  : in  std_logic;  -- tín hiệu từ khối datapath báo hoàn thành 1 bước
        done     : out std_logic;
        op_sel   : out std_logic_vector(1 downto 0)
    );
end entity exp_controller;

architecture fsm of exp_controller is

    -- định nghĩa trạng thái FSM
    type state_type is (IDLE, LOAD, EXECUTE, FINISH);
    signal state, next_state : state_type;

    -- tín hiệu nội bộ
    signal done_int   : std_logic := '0';
    signal op_sel_int : std_logic_vector(1 downto 0) := (others => '0');

begin

    ---------------------------------------------------------------------
    -- mapping các tín hiệu nội bộ ra cổng output
    ---------------------------------------------------------------------
    done   <= done_int;
    op_sel <= op_sel_int;

    ---------------------------------------------------------------------
    -- PROCESS 1: trạng thái hiện tại
    ---------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    ---------------------------------------------------------------------
    -- PROCESS 2: logic chuyển trạng thái và điều khiển
    ---------------------------------------------------------------------
    process(state, start, op_done)
    begin
        -- giá trị mặc định
        next_state  <= state;
        done_int    <= '0';
        op_sel_int  <= "00";

        case state is

            when IDLE =>
                if start = '1' then
                    next_state <= LOAD;
                end if;

            when LOAD =>
                op_sel_int <= "01";
                next_state <= EXECUTE;

            when EXECUTE =>
                op_sel_int <= "10";
                if op_done = '1' then
                    next_state <= FINISH;
                end if;

            when FINISH =>
                done_int   <= '1';
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;

        end case;
    end process;

end architecture fsm;
