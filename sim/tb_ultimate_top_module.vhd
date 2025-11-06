library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;
use std.textio.all;      --  Thư viện in text
use ieee.std_logic_textio.all;  --  Dùng khi muốn in std_logic_vector

entity tb_ultimate_top_module is
end tb_ultimate_top_module;

architecture sim of tb_ultimate_top_module is

    -- DUT (Device Under Test)
    component ultimate_top_module
      port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;
        data_in   : in  std_logic_vector(15 downto 0);
        done      : out std_logic;
        out_data  : out std_logic_vector(15 downto 0)
      );
    end component;

    -- Internal signals
    signal clk_tb      : std_logic := '0';
    signal rst_tb      : std_logic := '1';
    signal start_tb    : std_logic := '0';
    signal data_in_tb  : std_logic_vector(15 downto 0) := (others => '0');
    signal done_tb     : std_logic;
    signal out_data_tb : std_logic_vector(15 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    --==== Instantiate DUT ====--
    DUT : ultimate_top_module
      port map (
        clk      => clk_tb,
        rst      => rst_tb,
        start    => start_tb,
        data_in  => data_in_tb,
        done     => done_tb,
        out_data => out_data_tb
      );

    --==== Clock generation ====--
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    --==== Stimulus process ====--
    stim_proc : process
    begin
        -- Reset hệ thống
        rst_tb <= '1';
        wait for 20 ns;
        rst_tb <= '0';
        wait for 20 ns;

        ---------------------------------------------------------------------
        -- Test case 1: input = +10.0 (x"1001")
        ---------------------------------------------------------------------
        data_in_tb <= x"1001";
        start_tb <= '1';
        wait for 500 ns;
        start_tb <= '0';
        wait for 50 ns;

        ---------------------------------------------------------------------
        -- Test case 2: input = +0.3125 (x"0500")
        ---------------------------------------------------------------------
        data_in_tb <= x"0500";
        start_tb <= '1';
        wait for 500 ns;
        start_tb <= '0';
        wait for 50 ns;

        ---------------------------------------------------------------------
        -- Test case 3: input = -1.5 (x"E800")
        ---------------------------------------------------------------------
        data_in_tb <= x"E800";
        start_tb <= '1';
        wait for 500 ns;
        start_tb <= '0';
        wait for 50 ns;

        ---------------------------------------------------------------------
        -- Test case 4: input = +2.75 (x"2C00")
        ---------------------------------------------------------------------
        data_in_tb <= x"2C00";
        start_tb <= '1';
        wait for 500 ns;
        start_tb <= '0';
        wait for 50 ns;

        ---------------------------------------------------------------------
        -- Test case 5: input = -0.25 (x"FC00")
        ---------------------------------------------------------------------
        data_in_tb <= x"FC00";
        start_tb <= '1';
        wait for 500 ns;
        start_tb <= '0';
        wait for 50 ns;

        ---------------------------------------------------------------------
        wait;  -- kết thúc mô phỏng
        ---------------------------------------------------------------------
    end process;

    --==== Monitor ====--
monitor : process(clk_tb)
    variable L : line;
    variable data_in_real  : real;
    variable out_real      : real;
    variable expected      : real;
    variable error         : real;
begin
    if rising_edge(clk_tb) then
        if done_tb = '1' then
            data_in_real := real(to_integer(signed(data_in_tb))) / 16384.0;
            out_real     := real(to_integer(signed(out_data_tb))) / 16384.0;
            expected     := exp(data_in_real);
            error        := abs(out_real - expected);

            -- dòng in đơn giản, không metadata
            write(L, string'("Time="));
            write(L, now);
            write(L, string'(" | data_in="));
            write(L, data_in_real, RIGHT, 0, 6);
            write(L, string'(" | expected(e^x)="));
            write(L, expected, RIGHT, 0, 6);
            write(L, string'(" | actual="));
            write(L, out_real, RIGHT, 0, 6);
            write(L, string'(" | error="));
            write(L, error, RIGHT, 0, 6);
            writeline(output, L);
        end if;
    end if;
end process;



end sim;
