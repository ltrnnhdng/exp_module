library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Port ( 
        a, b: in std_logic_vector(15 downto 0);
        sel: in std_logic;
        c: out std_logic_vector
    );
end mux;

architecture Behavioral of mux is

begin
    c <= a when sel = '0' else b;
end Behavioral;
