library ieee;
use ieee.std_logic_1164.all;

entity comparator is
port(
    rst, clk: in std_logic;
    
    a: in std_logic_vector (15 downto 0);
    z_flag : out std_logic;
    e_16_flag: out std_logic
);
end comparator;

architecture behavioral of comparator is

constant N : std_logic_vector (15 downto 0) := x"0010"; -- 16

begin
    e_16_flag <= '1' when (a = N) else '0';
    z_flag <= a(15);
end behavioral;

