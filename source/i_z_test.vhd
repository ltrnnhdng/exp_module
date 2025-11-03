library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- dùng cho phép toán s? h?c

-- Top-level rút g?n: ch? i và z ?? debug
entity datapath_debug_i_z is
    port (
       rst, clk: in std_logic;

       -- enable/load cho i và z
       i_ld, z_ld : in std_logic;

       -- input value (dùng khi ch?n load t? input vào z)
       in_val : in std_logic_vector(15 downto 0);

       -- ch?n phép toán cho z (adder/sub) và mux ch?n ngu?n z_next
       z_op_sel, z_sel: in std_logic;

       -- flag output
       i_gt_N, z_ge_0_out: out std_logic;

       -- debug probes: tr?c ti?p xu?t giá tr? i và z hi?n t?i
       i_out : out std_logic_vector(15 downto 0);
       z_out : out std_logic_vector(15 downto 0);
       lut_out_tb : out std_logic_vector(15 downto 0)
    );
end entity datapath_debug_i_z;

architecture Behavior of datapath_debug_i_z is

    -- component declarations (gi? nh? top c?)
    component flipflop 
        generic(
            reset_value : std_logic_vector(15 downto 0) 
        );
        port(
            clk, rst, ena: in std_logic;
            d : in std_logic_vector (15 downto 0);
            q : out std_logic_vector (15 downto 0)        
        );
    end component;
    
    component addsub 
        port(
            op_sel : in std_logic;                       -- '1' = add, '0' = sub (theo ??nh ngh?a module c?a b?n)
            a, b   : in std_logic_vector (15 downto 0);
            c      : out std_logic_vector (15 downto 0)
        );
    end component;
    
    component comparator 
        port(
            rst, clk: in std_logic;
            a: in std_logic_vector (15 downto 0);
            z_flag : out std_logic;
            e_16_flag: out std_logic
        );
    end component;
    
    component mux
    Port ( 
        a, b: in std_logic_vector(15 downto 0);
        sel: in std_logic;
        c: out std_logic_vector(15 downto 0)
    );
    end component;

    -- internal signals (ch? cho i và z)
    signal i_sig, i_after_add: std_logic_vector(15 downto 0);
    signal z_sig, z_after_add, z_next: std_logic_vector(15 downto 0);
    signal lut_out : std_logic_vector(15 downto 0);
    signal z_ge_0 : std_logic;
    -- constants
    constant one : std_logic_vector (15 downto 0) := x"0001";
    constant one_1bit : std_logic := '1';
    
        -- Khai báo thêm trong ph?n signal
    signal z_op_sel_sig : std_logic;
    
    -- Gán tín hi?u ?i?u khi?n c?ng/tr?
    -- LUT (atanh(2^-i)) d?ng Q1.14 fixed-point (gi? nguyên nh? b?n cung c?p)
    type lut_array is array (1 to 15) of std_logic_vector(15 downto 0);
    constant LUT : lut_array := (
        1  => x"2328",
        2  => x"1059",
        3  => x"080B",
        4  => x"0401",
        5  => x"0200",
        6  => x"0100",
        7  => x"0080",
        8  => x"0040",
        9  => x"0020",
        10 => x"0010",
        11 => x"0008",
        12 => x"0004",
        13 => x"0002",
        14 => x"0001",
        15 => x"0001"
    );

begin

    -- i flipflop + increment logic (i <- i + 1 khi i_ld = '1')
    i_ff : entity work.flipflop  
        generic map (reset_value => x"0001")
        port map (clk => clk, rst => rst, ena => i_ld, d => i_after_add, q => i_sig);

    -- t?ng i m?i b??c (s? d?ng addsub v?i op_sel = '1' ?? add)
    i_add_1: addsub
        port map (op_sel => one_1bit, a => i_sig, b => one, c => i_after_add);

    -- comparator cho i (e.g. ki?m tra i > N) -- map e_16_flag thành i_gt_N
    i_comp: comparator
        port map (clk => clk, rst => rst, a => i_sig, e_16_flag => i_gt_N, z_flag => open);

    -- LUT lookup theo 4 bit th?p c?a i (i trong kho?ng 0..15)
    -- L?u ý: LUT index ch?y t? 1..15; n?u i = 0 hãy tr? v? "0" (ho?c LUT(1) tu? ý)
    process(i_sig)
        variable idx : integer;
    begin
        idx := to_integer(unsigned(i_sig(3 downto 0)));
        if idx = 0 then
            lut_out <= (others => '0');
        elsif idx > 15 then
            lut_out <= LUT(15);
        else
            -- LUT index 1..15
            lut_out <= LUT(idx);
        end if;
    end process;

    -- z flipflop
    z_ff : entity work.flipflop  
        generic map (reset_value => x"0000")
        port map (clk => clk, rst => rst, ena => z_ld, d => z_next, q => z_sig);

    -- z add/sub: z_after_add = z +/- lut_out
    z_op_sel_sig <= not(z_ge_0);

    z_addsub: entity work.addsub
        port map (op_sel => z_op_sel_sig, a => z_sig, b => lut_out, c => z_after_add);

    -- z mux: ch?n gi?a in_val (ví d? init) ho?c z_after_add
    z_mux: mux
        port map (sel => z_sel, a => in_val, b => z_after_add, c => z_next);

    -- comparator cho z (z_flag ??a ra z_ge_0)
    z_comp: comparator
        port map (clk => clk, rst => rst, a => z_sig, z_flag => z_ge_0, e_16_flag => open);

    -- debug outputs
    i_out <= i_sig;
    z_out <= z_sig;
    lut_out_tb <= lut_out;
    z_ge_0_out <= z_ge_0;
end architecture Behavior;
