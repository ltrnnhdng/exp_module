library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exp_controller is
    port (
        clk         : in  std_logic;
        reset_cpu   : in  std_logic;   -- Reset t?ng t? CPU
        start       : in  std_logic;   -- CPU g?i start
        z_ge_0      : in  std_logic;   -- t? datapath
        i_gt_N      : in  std_logic;   -- t? datapath

        -- các tín hi?u ?i?u khi?n ra datapath
        x_ld        : out std_logic;
        y_ld        : out std_logic;
        z_ld        : out std_logic;
        i_ld        : out std_logic;
        out_ld      : out std_logic;
        op_sel      : out std_logic;
        z_op_sel    : out std_logic;
        z_sel       : out std_logic;
        done        : out std_logic;
        xin_ld      : out std_logic; 
        k_ld        : out std_logic;
        xtiny_ld    : out std_logic;

        -- tín hi?u reset n?i b? FSM (quan sát)
        reset_ctrl  : out std_logic
    );
end entity;

architecture fsm of exp_controller is

    type state_type is (
        S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12
    );
    signal state, next_state : state_type;

    signal x_ld_int, y_ld_int, z_ld_int, i_ld_int, out_ld_int : std_logic := '0';
    signal op_sel_int, z_op_sel_int, z_sel_int, done_int : std_logic := '0';
    signal xin_ld_int, k_ld_int, xtiny_ld_int: std_logic := '0';
    signal reset_ctrl_int : std_logic := '1';
    signal start_dly      : std_logic := '0';
    

begin
    --------------------------------------------------------------------
    -- Gán ra ngoài
    --------------------------------------------------------------------
    x_ld     <= x_ld_int;
    y_ld     <= y_ld_int;
    z_ld     <= z_ld_int;
    i_ld     <= i_ld_int;
    out_ld   <= out_ld_int;
    op_sel   <= op_sel_int;
    z_op_sel <= z_op_sel_int;
    z_sel    <= z_sel_int;
    done     <= done_int;
    reset_ctrl <= reset_ctrl_int;
    
    xin_ld    <= xin_ld_int; 
    k_ld      <= k_ld_int;
    xtiny_ld  <= xtiny_ld_int;

    --------------------------------------------------------------------
    -- Thanh ghi tr?ng thái
    --------------------------------------------------------------------
    process(clk, reset_cpu)
    begin
        if reset_cpu = '1' then
            state <= S0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Logic chuy?n tr?ng thái
    --------------------------------------------------------------------
    process(state, start, z_ge_0, i_gt_N)
    begin
        next_state <= state;

        case state is
            when S0 =>
                if start = '1' then
                    next_state <= S1;
                end if;

            when S1 =>
                next_state <= S2;
                
            when S2 =>
                next_state <= S3;
                
            when S3 =>
                next_state <= S4;
                
            when S4 =>
                next_state <= S5;
                
            when S5 =>
                if i_gt_N = '0' then
                    next_state <= S6;
                else
                    next_state <= S9;
                end if;

            when S6 =>
                if z_ge_0 = '0' then
                    next_state <= S7;
                else
                    next_state <= S8;
                end if;

            when S7 | S8 =>
                next_state <= S5;  
                
            when S9 =>
                next_state <= S10;

            when S10 =>
                next_state <= S11;

            when S11 =>
                if start = '0' then 
                    next_state <= S12;
                end if;
            when S12 =>
                next_state <= S0;

            when others =>
                next_state <= S0;
                
        end case;
    end process;

    --------------------------------------------------------------------
    -- Logic ?i?u khi?n output
    --------------------------------------------------------------------
    reset_ctrl_int  <= '1' when (state = S1) else '0';
    
    xin_ld_int      <= '1' when (state = S2) else '0';
    k_ld_int        <= '1' when (state = S3) else '0';
    xtiny_ld_int    <= '1' when (state = S3) else '0';
    
    z_ld_int        <= '1' when (state = S4 or state = S7 or state = S8) else '0';
    
    z_sel_int       <= '0' when (state = S4) else 
                       '1' when (state = S7 or state = S8) else 
                       '0';
                       
    op_sel_int      <= '0' when (state = S7) else 
                       '1' when (state = S8) else 
                       '0';
                       
    z_op_sel_int    <= '1' when (state = S7) else 
                       '0' when (state = S8) else 
                       '0';

    x_ld_int        <= '1' when (state = S7 or state = S8) else '0';
    y_ld_int        <= '1' when (state = S7 or state = S8) else '0';
    i_ld_int        <= '1' when (state = S7 or state = S8) else '0';

    out_ld_int      <= '1' when (state = S9) else '0';
    done_int        <= '1' when (state = S10 or state = S11) else 
                       '0' when (state = S12) else
                       '0' ;

end architecture;
