library ieee;
use ieee.std_logic_1164.all;

entity comparator is
port(
    rst, clk: in std_logic;
    
    a: in std_logic_vector (31 downto 0);
    z_flag : out std_logic;
    e_32_flag: out std_logic
);
end comparator;

architecture behavioral of comparator is

constant N : std_logic_vector (31 downto 0) := x"00000014"; -- 20

begin
    e_32_flag <= '1' when (a = N) else '0';
    z_flag <= not a(31);
end behavioral;


