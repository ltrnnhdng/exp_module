library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_ultimate_top_module is
end tb_ultimate_top_module;

architecture sim of tb_ultimate_top_module is
    -- DUT: 32-bit fixed-point (Q4.28)
    component ultimate_top_module
      port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        start    : in  std_logic;
        data_in  : in  std_logic_vector(31 downto 0);  -- 32-bit fixed point Q4.28
        done     : out std_logic;
        out_data : out std_logic_vector(31 downto 0)   -- 32-bit fixed point Q4.28
      );
    end component;

    -- Signals
    signal clk_tb       : std_logic := '0';
    signal rst_tb       : std_logic := '1';
    signal start_tb     : std_logic := '0';
    signal data_in_tb   : std_logic_vector(31 downto 0) := (others => '0');
    signal done_tb      : std_logic;
    signal out_data_tb  : std_logic_vector(31 downto 0);

    -- Clock
    constant clk_period : time := 10 ns;
    
    -- H? s? scale cho Q4.28
    constant Q_SCALE : real := 2.0**28;

begin
    -- Instantiate DUT
    DUT : ultimate_top_module
      port map (
        clk      => clk_tb,
        rst      => rst_tb,
        start    => start_tb,
        data_in  => data_in_tb,
        done     => done_tb,
        out_data => out_data_tb
      );

    -- Clock generation
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset h? th?ng
        rst_tb <= '1';
        start_tb <= '0';
        data_in_tb <= (others => '0');
        wait for 20 ns;
        rst_tb <= '0';
        wait for 20 ns;

        ---------------------------------------------------------------------
        -- Test các giá tr? t? -0.6 ? +0.6 (Q4.28)
        -- Công th?c: value_hex = round(real_value * 2^28)
        ---------------------------------------------------------------------

        report "TEST: e^(-0.6)" severity NOTE;
        data_in_tb <= x"F999999A"; -- -0.6 * 2^28 = -161061274
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(-0.5)" severity NOTE;
        data_in_tb <= x"E0000000"; -- -0.5 * 2^28 = -134217728
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(-0.4)" severity NOTE;
        data_in_tb <= x"E6666666"; -- -0.4 * 2^28 = -107374183
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(-0.3)" severity NOTE;
        data_in_tb <= x"ECCCCCCD"; -- -0.3 * 2^28 = -80530637
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(-0.2)" severity NOTE;
        data_in_tb <= x"F3333333"; -- -0.2 * 2^28 = -53687091
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(-0.1)" severity NOTE;
        data_in_tb <= x"F999999A"; -- -0.1 * 2^28 = -26843546
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(0.0)" severity NOTE;
        data_in_tb <= x"00000000"; -- 0.0
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(+0.1)" severity NOTE;
        data_in_tb <= x"06666666"; -- +0.1 * 2^28 = 26843546
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(+0.2)" severity NOTE;
        data_in_tb <= x"0CCCCCCD"; -- +0.2 * 2^28 = 53687091
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(+0.3)" severity NOTE;
        data_in_tb <= x"13333333"; -- +0.3 * 2^28 = 80530637
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(+0.4)" severity NOTE;
        data_in_tb <= x"1999999A"; -- +0.4 * 2^28 = 107374183
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(+0.5)" severity NOTE;
        data_in_tb <= x"20000000"; -- +0.5 * 2^28 = 134217728
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(+0.6)" severity NOTE;
        data_in_tb <= x"26666666"; -- +0.6 * 2^28 = 161061274
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        ---------------------------------------------------------------------
        report "--- K?t thúc mô ph?ng ---";
        wait; -- end simulation
        ---------------------------------------------------------------------
    end process;

    -- Monitor process: ghi k?t qu?
    monitor : process(clk_tb)
        variable L             : line;
        variable data_in_real  : real;
        variable out_real      : real;
        variable expected      : real;
        variable error         : real;
    begin
        if rising_edge(clk_tb) then
            if done_tb = '1' then
                data_in_real := real(to_integer(signed(data_in_tb))) / Q_SCALE;
                out_real     := real(to_integer(signed(out_data_tb))) / Q_SCALE;
                expected     := exp(data_in_real);
                error        := abs(out_real - expected);

                write(L, string'("Time="));      write(L, now);
                write(L, string'(" | Input="));  write(L, data_in_real, RIGHT, 8, 6);
                write(L, string'(" | Output=")); write(L, out_real, RIGHT, 8, 6);
                write(L, string'(" | Expected=")); write(L, expected, RIGHT, 8, 6);
                write(L, string'(" | Error="));  write(L, error);
                writeline(output, L);
            end if;
        end if;
    end process;

end sim;
