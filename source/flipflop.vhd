library ieee;
use ieee.std_logic_1164.all;

entity flipflop is
generic(reset_value : std_logic_vector (15 downto 0));
port(
    clk, rst, ena: in std_logic;
    d : in std_logic_vector (15 downto 0);
    q : out std_logic_vector (15 downto 0)
);
end flipflop;

architecture behavioral of flipflop is
signal q_reg:  std_logic_vector(15 downto 0);
begin
    process (clk,  rst)
    begin
        if rst = '1' then
            q_reg <= reset_value;
        elsif rising_edge(clk) then
            if ena = '1' then   
                q_reg <= d;
            end if;
        end if;
    end process;
    q <= q_reg;
end behavioral;

