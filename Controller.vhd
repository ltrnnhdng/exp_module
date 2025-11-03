
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exp_controller is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        start     : in  std_logic;
        z_ge_0    : in  std_logic;
        i_gt_N    : in  std_logic;

        -- các tín hiệu điều khiển ra datapath
        x_ld      : out std_logic;
        y_ld      : out std_logic;
        z_ld      : out std_logic;
        i_ld      : out std_logic;
        out_ld    : out std_logic;
        op_sel    : out std_logic;  -- 1 = add, 0 = sub
        z_op_sel  : out std_logic;  -- chọn phép cộng/trừ cho Z
        z_sel     : out std_logic;
        done      : out std_logic;

        -- debug quan sát FSM
        state_reg : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of exp_controller is

    type state_type is (
        S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12
    );

    signal state, next_state : state_type;

    signal x_ld_int, y_ld_int, z_ld_int, i_ld_int, out_ld_int : std_logic := '0';
    signal op_sel_int, z_op_sel_int,z_sel_int, done_int : std_logic := '0';

begin

    -- Ánh xạ ra cổng
    x_ld     <= x_ld_int;
    y_ld     <= y_ld_int;
    z_ld     <= z_ld_int;
    i_ld     <= i_ld_int;
    out_ld   <= out_ld_int;
    op_sel   <= op_sel_int;
    z_op_sel <= z_op_sel_int;
    z_sel    <= z_sel_int;
    done     <= done_int;

    with state select
        state_reg <= "0000" when S0,
                     "0001" when S1,
                     "0010" when S2,
                     "0101" when S5,
                     "0111" when S7,
                     "1000" when S8,
                     "1001" when S9,
                     "1010" when S10,
                     "1011" when S11
    -- Thanh ghi trạng thái
    process(clk, reset)
    begin
        if reset = '1' then
            state <= S0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Logic tổ hợp FSM
    process(state, start, z_ge_0, i_gt_N)
    begin
        -- mặc định
        next_state <= state;
        x_ld_int   <= '0';
        y_ld_int   <= '0';
        z_ld_int   <= '0';
        i_ld_int   <= '0';
        out_ld_int <= '0';
        op_sel_int <= '0';
        z_op_sel_int <= '0';
        z_sel_int <= '0';
        done_int   <= '0';

        case state is

            when S0 =>
               next_state <= S1;

            when S1 =>
                if start = '1' then
                    next_state <= S2;
                end if;

            when S2 =>             
                z_ld_int <= '1';
                z_sel_int <= '0';
                next_state <= S3;

            when S3 =>
                if i_gt_N = '0' then
	                next_state <= S4; 
								else
                  next_state <= S8;
                end if;
					
					--if Z >= 0:
          --  X_next = X + (Y * 2 ** (-i))
           -- Y_next = Y + (X * 2 ** (-i))
           -- Z_next = Z - LUT[i - 1]
      --  else:
       --     X_next = X - (Y * 2 ** (-i))
       --     Y_next = Y - (X * 2 ** (-i))
        --    Z_next = Z + LUT[i - 1]
     --   X, Y, Z = X_next, Y_next, Z_next
            when S4 =>
                if z_ge_0 = '0' then
                    next_state <= S5;
                else
                    next_state <= S6;
                end if;
							
							
            when S5 =>
                op_sel_int <= '0';
                z_op_sel_int <= '1';
                next_state <= S7;
						
						when S6 =>
                op_sel_int <= '0';
                z_op_sel_int <= '1';
                next_state <= S7;
                
            when S7 =>
                x_ld_int <= '1';
                y_ld_int <= '1';
                z_ld_int <= '1';
                z_sel_int<= '1';
                i_ld_int <= '1';
                next_state <= S3;

            when S8 =>
                out_ld_int <= '1';
                next_state <= S9;

            when S9 =>
                done_int <= '1';
                next_state <= S10;

            when S10 =>
                if start = '0' then
                    next_state <= S11;
                end if;

            when S11 =>
                done_int <= '0';
                next_state <= S0;

            when others =>
                next_state <= S0;

        end case;
    end process;

end architecture fsm;
s

