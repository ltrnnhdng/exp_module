library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ultimate_top_module is
  Port ( 
    clk       : in  std_logic;
    rst       : in  std_logic;
    start     : in  std_logic;
    data_in   : in  std_logic_vector(31 downto 0);
    
    done      : out std_logic;
    out_data  : out std_logic_vector(31 downto 0)
    
  );
end ultimate_top_module;

architecture Behavioral of ultimate_top_module is

  --=== COMPONENT DECLARATIONS ===--
  component exp_controller is
    port (
        clk       : in  std_logic;
        reset_cpu : in  std_logic;
        start     : in  std_logic;
        z_ge_0    : in  std_logic;
        i_gt_N    : in  std_logic;

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
        
        -- debug FSM
        state_reg : out std_logic_vector(3 downto 0);
        reset_ctrl  : out std_logic
    );
  end component;

  component datapath is
    port (
       rst, clk :                        in std_logic;

       i_ld, x_ld, y_ld, z_ld, out_ld,xin_ld, k_ld, xtiny_ld  : in std_logic;
       
       xy_op_sel, z_op_sel, z_sel:      in std_logic;   -- control ops

       i_gt_N, z_ge_0:                  out std_logic;  -- flags
       
       in_val  : in  std_logic_vector(31 downto 0);     -- input data
       out_data: out std_logic_vector(31 downto 0)      -- output data

    );
  end component;

  --=== SIGNALS ===--
  signal x_ld_top, y_ld_top, z_ld_top, i_ld_top, out_ld_top, xin_ld_top, k_ld_top, xtiny_ld_top : std_logic;
  signal z_ge_0_top, i_gt_N_top : std_logic;
  signal xy_op_sel_top, z_op_sel_top, z_sel_top : std_logic;
  signal done_top : std_logic;
  signal state_debug : std_logic_vector(3 downto 0);
  signal reset_controller: std_logic;


begin

  --=== DATAPATH INSTANCE ===--
  data_path_module : datapath
    port map(
      clk        => clk,
      rst        => reset_controller,

      i_ld       => i_ld_top,
      x_ld       => x_ld_top,
      y_ld       => y_ld_top,
      z_ld       => z_ld_top,
      out_ld     => out_ld_top,
      xin_ld     => xin_ld_top, 
      k_ld       => k_ld_top, 
      xtiny_ld   => xtiny_ld_top, 

      xy_op_sel  => xy_op_sel_top,
      z_op_sel   => z_op_sel_top,
      z_sel      => z_sel_top,

      i_gt_N     => i_gt_N_top,
      z_ge_0     => z_ge_0_top,

      in_val     => data_in,
      out_data   => out_data

    );

  --=== CONTROLLER INSTANCE ===--
  controller_module : exp_controller
    port map(
      clk       => clk,
      reset_cpu => rst,
      start     => start,
      z_ge_0    => z_ge_0_top,
      i_gt_N    => i_gt_N_top,

      x_ld      => x_ld_top,
      y_ld      => y_ld_top,
      z_ld      => z_ld_top,
      i_ld      => i_ld_top,
      out_ld    => out_ld_top,
      xin_ld     => xin_ld_top, 
      k_ld       => k_ld_top, 
      xtiny_ld   => xtiny_ld_top, 


      op_sel    => xy_op_sel_top,
      z_op_sel  => z_op_sel_top,
      z_sel     => z_sel_top,

      done      => done_top,
      state_reg => state_debug,
      reset_ctrl=> reset_controller
    );

  --=== OUTPUT CONNECTIONS ===--
  done <= done_top;

end Behavioral;
