library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- dùng cho phép toán s? h?c

-- Khai báo entity (giao ti?p)
entity datapath is
    port (
       rst, clk: in std_logic;
        
       -- ff enable signals
       i_ld, x_ld, y_ld, z_ld, out_ld : in std_logic;
       
       -- input value
       in_val : in std_logic_vector(15 downto 0);
       
       -- operation selection signals
       xy_op_sel, z_op_sel, z_sel: in std_logic;

       -- flag signals
       i_gt_N, z_ge_0: out std_logic;
       
       -- data out
       out_data: out std_logic_vector(15 downto 0)
       
    );
end entity datapath;

-- Ki?n trúc bên trong (mô t? ho?t ??ng)
architecture Behavior of datapath is

    -- component declearations 
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
            op_sel :in std_logic;
            a,b : in std_logic_vector (15 downto 0);
            c : out std_logic_vector (15 downto 0)
        );
    end component;
    
    component bitshift 
        port(
            clk, rst: in std_logic;
            data: in std_logic_vector (15 downto 0);
            shift_i: in std_logic_vector (3 downto 0);
            data_out: out std_logic_vector (15 downto 0)
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
        c: out std_logic_vector
    );
    end component;

    -- signals
    -- 
    signal i_sig, i_after_add: std_logic_vector(15 downto 0);
    signal z_sig, z_after_add, z_next: std_logic_vector(15 downto 0);
    signal x_sig, x_after_shift, x_next: std_logic_vector(15 downto 0);
    signal y_sig, y_after_shift, y_next: std_logic_vector(15 downto 0);
    signal lut_out : std_logic_vector(15 downto 0);
    signal out_adder_sig: std_logic_vector(15 downto 0);
    --
    
    
    constant one : std_logic_vector (15 downto 0) := x"0001";
    constant one_1bit : std_logic := '1';
    

    -- =============================================================
    --  LUT (atanh(2^-i)) d?ng Q1.14 fixed-point
    -- =============================================================
    type lut_array is array (0 to 15) of std_logic_vector(15 downto 0);
    constant LUT : lut_array := (
        0  => x"2328", -- i= 1: 0.5493061443 -> 0b0010001100101000 -> 0x2328
        1  => x"1059", -- i= 2: 0.2554128119 -> 0b0001000001011001 -> 0x1059
        2  => x"080B", -- i= 3: 0.1256572141 -> 0b0000100000001011 -> 0x080B
        3  => x"0401", -- i= 4: 0.0625815715 -> 0b0000010000000001 -> 0x0401
        4  => x"0200", -- i= 5: 0.0312601785 -> 0b0000001000000000 -> 0x0200
        5  => x"0100", -- i= 6: 0.0156262718 -> 0b0000000100000000 -> 0x0100
        6  => x"0080", -- i= 7: 0.0078126590 -> 0b0000000010000000 -> 0x0080
        7  => x"0040", -- i= 8: 0.0039062699 -> 0b0000000001000000 -> 0x0040
        8  => x"0020", -- i= 9: 0.0019531275 -> 0b0000000000100000 -> 0x0020
        9  => x"0010", -- i=10: 0.0009765628 -> 0b0000000000010000 -> 0x0010
        10 => x"0008", -- i=11: 0.0004882813 -> 0b0000000000001000 -> 0x0008
        11 => x"0004", -- i=12: 0.0002441406 -> 0b0000000000000100 -> 0x0004
        12 => x"0002", -- i=13: 0.0001220703 -> 0b0000000000000010 -> 0x0002
        13 => x"0001", -- i=14: 0.0000610352 -> 0b0000000000000001 -> 0x0001
        14 => x"0001"  -- i=15: 0.0000305176 -> 0b0000000000000001 -> 0x0001
    );
    -- =============================================================


BEGIN 

i_ff : entity work.flipflop  
    generic map (reset_value => x"0001") 
    port map (clk => clk, rst => rst, ena => i_ld, d => i_after_add, q => i_sig);
i_add_1: addsub port map (op_sel => one_1bit, a => i_sig, b=>one, c => i_after_add);
i_comp: comparator port map (clk => clk, rst => rst, a => i_sig, e_16_flag => i_gt_N);



-- x,y,z ffs
x_ff : entity work.flipflop  
    generic map (reset_value => x"4D21")  --        1/k = 1.2051363583 -> 0b0100110100100001 -> 0x4D21
    port map (clk => clk, rst => rst, ena => x_ld, d => x_next, q => x_sig);
    

y_ff : entity work.flipflop  
    generic map (reset_value => x"0000")
    port map (clk => clk, rst => rst, ena => y_ld, d => y_next, q => y_sig);

z_ff : entity work.flipflop  
    generic map (reset_value => x"0000")
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

lut_out <= LUT(to_integer(unsigned(i_sig(3 downto 0))));
z_addsub:entity work.addsub
    port map(op_sel => z_op_sel, a => z_sig, b => lut_out, c => z_after_add);
    
z_mux: mux port map (sel => z_sel, a => in_val, b => z_after_add, c => z_next);


-- data out
out_addsub : entity work.addsub
    port map(op_sel => one_1bit, a => x_sig, b => y_sig, c => out_adder_sig);
out_ff: entity work.flipflop  
    generic map (reset_value => x"0000")
    port map (clk => clk, rst => rst, ena => out_ld, d => out_adder_sig, q => out_data);

    
end architecture Behavior;
