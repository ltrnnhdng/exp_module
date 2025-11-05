library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ultimate_top_module is
end tb_ultimate_top_module;

architecture sim of tb_ultimate_top_module is

    -- DUT (Device Under Test) component
    component ultimate_top_module
      port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;
        data_in   : in  std_logic_vector(15 downto 0);
        done      : out std_logic;
        out_data  : out std_logic_vector(15 downto 0);
        
        x_out, y_out, z_out, i_out  : out std_logic_vector(15 downto 0)
      );
    end component;

    --==== Internal testbench signals ====--
    signal clk_tb      : std_logic := '0';
    signal rst_tb      : std_logic := '1';
    signal start_tb    : std_logic := '0';
    signal data_in_tb  : std_logic_vector(15 downto 0) := (others => '0');
    signal done_tb     : std_logic;
    signal out_data_tb : std_logic_vector(15 downto 0);
    signal x_out, y_out, z_out, i_out  :  std_logic_vector(15 downto 0); -- debug--------
    -- Clock period constant
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
        out_data => out_data_tb,
        
        -- debug-----------
        x_out => x_out,
      y_out => y_out,
      z_out => z_out,
      i_out => i_out
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
        -- Giai ?o?n 1: reset toàn h? th?ng
        rst_tb <= '1';
        wait for 20 ns;
        rst_tb <= '0';
        wait for 20 ns;

        -- Giai ?o?n 2: n?p d? li?u ??u vào
        data_in_tb <= x"1111";  -- ví d?: input = 10
        wait for 10 ns;

        -- Giai ?o?n 3: phát xung start
        start_tb <= '1';
        
        wait for 1000 ns;  -- ch? quá trình x? lý

        -- Giai ?o?n 4: ??i d? li?u, ch?y l?i
        data_in_tb <= x"0005";
        wait for 20 ns;
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait for 1000 ns;

        -- K?t thúc mô ph?ng
        wait;
    end process;

    --==== Monitor (optional) ====--
    monitor : process(clk_tb)
    begin
        if rising_edge(clk_tb) then
            report "Time=" & time'image(now) &
                   " start=" & std_logic'image(start_tb) &
                   " done=" & std_logic'image(done_tb) &
                   " out_data=" & integer'image(to_integer(unsigned(out_data_tb)));
        end if;
    end process;

end sim;
