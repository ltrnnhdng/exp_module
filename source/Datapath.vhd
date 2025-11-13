library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.STD_LOGIC_UNSIGNED;

-- Khai b�o entity (giao ti?p)
entity datapath is
    port (
       rst, clk: in std_logic;
        
       -- ff enable signals
       i_ld, x_ld, y_ld, z_ld, out_ld : in std_logic;
       
       -- input value
       in_val : in std_logic_vector(31 downto 0);
       
       -- operation selection signals
       xy_op_sel, z_op_sel, z_sel: in std_logic;

       -- flag signals
       i_gt_N, z_ge_0: out std_logic;
       
       -- data out
       out_data: out std_logic_vector(31 downto 0)
       
    );
end entity datapath;

-- Ki?n tr�c b�n trong (m� t? ho?t ??ng)
architecture Behavior of datapath is

    -- component declearations 
    component flipflop 
        generic(
            reset_value : std_logic_vector(31 downto 0) 
        );
        port(
            clk, rst, ena: in std_logic;
            d : in std_logic_vector (31 downto 0);
            q : out std_logic_vector (31 downto 0)        
        );
    end component;
    
    component addsub 
        port(
            op_sel :in std_logic;
            a,b : in std_logic_vector (31 downto 0);
            c : out std_logic_vector (31 downto 0)
        );
    end component;
    
    component bitshift 
        port(
            data: in std_logic_vector (31 downto 0);
            shift_i: in std_logic_vector (31 downto 0);
            data_out: out std_logic_vector (31 downto 0)
        );
    end component;
    
    component comparator 
        port(
            rst, clk: in std_logic;
            a: in std_logic_vector (31 downto 0);
            z_flag : out std_logic;
            e_16_flag: out std_logic
        );
    end component;
    
    component mux
    Port ( 
        a, b: in std_logic_vector(31 downto 0);
        sel: in std_logic;
        c: out std_logic_vector
    );
    end component;

    -- signals
    -- 
    signal i_sig: std_logic_vector(31 downto 0) := x"00000001";
    signal i_after_add: std_logic_vector(31 downto 0) := x"00000000";
    signal z_sig, z_after_add, z_next: std_logic_vector(31 downto 0) := x"00000000";
    signal x_sig, x_after_shift, x_next: std_logic_vector(31 downto 0) := x"00000000";
    signal y_sig, y_after_shift, y_next: std_logic_vector(31 downto 0) := x"00000000";
    signal lut_out : std_logic_vector(31 downto 0) := x"00000000";
    signal out_adder_sig: std_logic_vector(31 downto 0) := x"00000000";
    --
    
    
    constant one : std_logic_vector (31 downto 0) := x"00000001";
    constant one_1bit : std_logic := '1';
    
-- =============================================================
--  LUT (atanh(2^-i)) dạng Q2.30 fixed-point (32-bit)
-- =============================================================
-- =============================================================
--  LUT (atanh(2^-i)) dạng Q2.30 fixed-point
-- =============================================================
type lut_array is array (0 to 20) of std_logic_vector(31 downto 0);
constant LUT : lut_array := (
    0  => x"FFFFFFFF", -- filler
    1  => x"08C9F53D", -- i=0
    2  => x"04162BBF", -- i=1
    3  => x"0202B124", -- i=2
    4  => x"01005589", -- i=3
    5  => x"00800AAC", -- i=4
    6  => x"00400155", -- i=5
    7  => x"0020002B", -- i=6
    8  => x"00100005", -- i=7
    9  => x"00080001", -- i=8
    10 => x"00040000", -- i=9
    11 => x"00020000", -- i=10
    12 => x"00010000", -- i=11
    13 => x"00008000", -- i=12
    14 => x"00004000", -- i=13
    15 => x"00002000", -- i=14
    16 => x"00001000", -- i=15
    17 => x"00000800", -- i=16
    18 => x"00000400", -- i=17
    19 => x"00000200", -- i=18
    20 => x"00000100"  -- i=19
);
-- =============================================================

BEGIN 

i_ff : entity work.flipflop  
    generic map (reset_value => x"00000001") 
    port map (clk => clk, rst => rst, ena => i_ld, d => i_after_add, q => i_sig);
i_add_1: addsub port map (op_sel => one_1bit, a => i_sig, b=>one, c => i_after_add);
i_comp: comparator port map (clk => clk, rst => rst, a => i_sig, e_16_flag => i_gt_N);



-- x,y,z ffs
x_ff : entity work.flipflop  
    generic map (reset_value => x"13483D0F")  --        1/k = 1.2051363583 
    port map (clk => clk, rst => rst, ena => x_ld, d => x_next, q => x_sig);

y_ff : entity work.flipflop  
    generic map (reset_value => x"00000000")
    port map (clk => clk, rst => rst, ena => y_ld, d => y_next, q => y_sig);

z_ff : entity work.flipflop  
    generic map (reset_value => x"00000000")
    port map (clk => clk, rst => rst, ena => z_ld, d => z_next, q => z_sig);

-- shifters
x_shift : entity work.bitshift
    port map (data => y_sig, shift_i => i_sig, data_out => y_after_shift);
    
y_shift : entity work.bitshift
    port map (data => x_sig ,shift_i => i_sig, data_out => x_after_shift);
    
    
    
-- adder / subtrators
x_addsub : entity work.addsub
    port map(op_sel => xy_op_sel, a => x_sig, b => y_after_shift, c => x_next);
    
y_addsub : entity work.addsub
    port map(op_sel => xy_op_sel, a => y_sig, b => x_after_shift, c => y_next);



-- z's comparator and adders and mux
z_comp: comparator port map (clk => clk, rst => rst, a => z_sig, z_flag => z_ge_0);

lut_out <= LUT(to_integer(unsigned(i_sig(31 downto 0))) mod LUT'length);
z_addsub:entity work.addsub
    port map(op_sel => z_op_sel, a => z_sig, b => lut_out, c => z_after_add);
    
z_mux: mux port map (sel => z_sel, a => in_val, b => z_after_add, c => z_next);


-- data out
out_addsub : entity work.addsub
    port map(op_sel => one_1bit, a => x_sig, b => y_sig, c => out_adder_sig);
out_ff: entity work.flipflop  
    generic map (reset_value => x"00000000")
    port map (clk => clk, rst => rst, ena => out_ld, d => out_adder_sig, q => out_data);

end architecture Behavior;
