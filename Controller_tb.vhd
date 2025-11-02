library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_tb is
end entity;

architecture sim of Controller_tb is

    signal clk, reset, start : std_logic := '0';
    signal z_ge_0, i_gt_N    : std_logic := '0';
    signal done, x_ld, y_ld, z_ld, i_ld, out_ld : std_logic;
    signal op_sel, z_op_sel  : std_logic;
    signal state_reg         : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Clock
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Mô phỏng tiến trình FSM
    stim_proc : process
    begin
        reset <= '1';
        wait for 18 ns;
        reset <= '0';

        start <= '1';
        wait for 18 ns;
        start <= '0';

        -- lặp vài vòng
        wait for 100 ns;
        z_ge_0 <= '1';
        wait for 36 ns;
        i_gt_N <= '1';
        wait for 18 ns;
        i_gt_N <= '0';

        wait for 200 ns;
        assert false report "Simulation finished" severity failure;
    end process;

    DUT: entity work.exp_controller
        port map (
            clk       => clk,
            reset     => reset,
            start     => start,
            z_ge_0    => z_ge_0,
            i_gt_N    => i_gt_N,
            x_ld      => x_ld,
            y_ld      => y_ld,
            z_ld      => z_ld,
            i_ld      => i_ld,
            out_ld    => out_ld,
            op_sel    => op_sel,
            z_op_sel  => z_op_sel,
            done      => done,
            state_reg => state_reg
        );

end architecture sim;
