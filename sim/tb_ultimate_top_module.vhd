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
        data_in_tb <= x"11000000"; --    -0.6137056
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(-0.5)" severity NOTE;
        data_in_tb <= x"0AEA6E06"; -- -0.5 * 2^28 = -134217728
        start_tb <= '1';
        wait for clk_period;
        rst_tb <= '1';
        wait for 500 ns;
        rst_tb <= '0';
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;
        
        rst_tb <= '1';
        wait for clk_period;wait for clk_period;wait for clk_period;
        rst_tb <= '0';
        

        report "TEST: e^(-0.4)" severity NOTE;
        data_in_tb <= x"00000010"; -- -0.4 * 2^28 = -107374183
        start_tb <= '1';
        wait for clk_period;
        wait until done_tb = '1';
        wait for clk_period;
        start_tb <= '0';
        wait for clk_period * 5;

        report "TEST: e^(-0.3)" severity NOTE;
        data_in_tb <= x"0D55555A"; -- -0.3 * 2^28 = -80530637
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
--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--use IEEE.MATH_REAL.all;
--use std.textio.all;
--use ieee.std_logic_textio.all;

--entity tb_ultimate_top_module is
--end tb_ultimate_top_module;

--architecture sim of tb_ultimate_top_module is
--    -- DUT: 32-bit fixed-point
--    component ultimate_top_module
--      port (
--        clk      : in  std_logic;
--        rst      : in  std_logic;
--        start    : in  std_logic;
--        data_in  : in  std_logic_vector(31 downto 0);  -- Input: Q2.30
--        done     : out std_logic;
--        out_data : out std_logic_vector(31 downto 0)   -- Output: Q4.28
--      );
--    end component;

--    -- Signals
--    signal clk_tb       : std_logic := '0';
--    signal rst_tb       : std_logic := '1';
--    signal start_tb     : std_logic := '0';
--    signal data_in_tb   : std_logic_vector(31 downto 0) := (others => '0');
--    signal done_tb      : std_logic;
--    signal out_data_tb  : std_logic_vector(31 downto 0);

--    -- Clock
--    constant clk_period : time := 10 ns;
    
--    -- He so scale
--    constant Q_SCALE_IN  : real := 2.0**30; -- Cho dau vao Q2.30
--    constant Q_SCALE_OUT : real := 2.0**28; -- Cho dau ra Q4.28

--begin
--    -- Instantiate DUT
--    DUT : ultimate_top_module
--      port map (
--        clk      => clk_tb,
--        rst      => rst_tb,
--        start    => start_tb,
--        data_in  => data_in_tb,
--        done     => done_tb,
--        out_data => out_data_tb
--      );

--    -- Clock generation
--    clk_process : process
--    begin
--        clk_tb <= '0';
--        wait for clk_period / 2;
--        clk_tb <= '1';
--        wait for clk_period / 2;
--    end process;

--    -- Stimulus process
--    stim_proc : process
--        variable v_data_in_uns : unsigned(31 downto 0);
--    begin
--        -- Reset he thong
--        rst_tb <= '1';
--        start_tb <= '0';
--        data_in_tb <= (others => '0');
--        wait for 20 ns;
--        rst_tb <= '0';
--        wait for 20 ns;

--        ---------------------------------------------------------------------
--        -- BAT DAU SWEEP TU 0 tang dan
--        ---------------------------------------------------------------------
--        report "--- BAT DAU TEST DO NHAY (SENSITIVITY) ---" severity NOTE;
        
--        -- Bat dau tu 0
--        v_data_in_uns := X"10000000"; 
        
--        -- Chay vong lap 20 lan, moi lan tang them 1 LSB (x"00000001")
--        for i in 0 to 400  loop
            
--            -- Gan gia tri vao tin hieu
--            data_in_tb <= std_logic_vector(v_data_in_uns);
            
--            -- Kich hoat start
--            start_tb   <= '1';
--            wait for clk_period; -- 1 chu ky de bat
            
--            -- Cho ket qua
--            wait until done_tb = '1';
--            wait for clk_period;
            
--            -- Ha start xuong
--            start_tb   <= '0';
--            wait for clk_period * 5; -- Nghi giua cac lan test
            
--            -- Tang gia tri dau vao len 1 don vi (1 LSB cua Q2.30)
--            -- Day la muc tang nho nhat co the
--            v_data_in_uns := v_data_in_uns + 8192*4;
            
--        end loop;

--        ---------------------------------------------------------------------
--        report "--- Ket thuc mo phong ---";
--        wait; -- end simulation
--        ---------------------------------------------------------------------
--    end process;

--    -- Monitor process: ghi ket qua
--    monitor : process(clk_tb)
--        variable L             : line;
--        variable data_in_real  : real;
--        variable out_real      : real;
--        variable expected      : real;
--        variable error         : real;
        
--        -- Bien luu gia tri cu de so sanh su thay doi
--        variable prev_out_hex  : std_logic_vector(31 downto 0) := (others => '0');
--        variable is_changed    : boolean;
--    begin
--        if rising_edge(clk_tb) then
--            if done_tb = '1' and done_tb'event then -- Chi in khi done chuyen sang '1'
                
--                -- Input la Q2.30, Output la Q4.28
--                data_in_real := real(to_integer(signed(data_in_tb))) / Q_SCALE_IN;
--                out_real     := real(to_integer(signed(out_data_tb))) / Q_SCALE_OUT;
                
--                expected     := exp(data_in_real);
--                error        := abs(out_real - expected);
                
--                -- Kiem tra xem dau ra co thay doi so voi lan truoc khong
--                if out_data_tb /= prev_out_hex then
--                    is_changed := true;
--                else
--                    is_changed := false;
--                end if;
--                prev_out_hex := out_data_tb;

--                write(L, string'("In(Hex)="));    write(L, data_in_tb);
--                write(L, string'(" | In(Real)="));   write(L, data_in_real, RIGHT, 12, 10);
--                write(L, string'(" | Out(Hex)="));   write(L, out_data_tb);
                
--                if is_changed then
--                    write(L, string'(" <-- CHANGED!"));
--                else
--                    write(L, string'(" <-- same..."));
--                end if;
                
--                writeline(output, L);
--            end if;
--        end if;
--    end process;

--end sim;
