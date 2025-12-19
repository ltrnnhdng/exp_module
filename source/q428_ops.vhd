---------------------------------------- add -----------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity q428_add is
Port ( 
    ain, bin: in std_logic_vector (31 downto 0);
    c: out std_logic_vector (31 downto 0)
);
end q428_add;

architecture Behavioral of q428_add is

begin
    c <= std_logic_vector(signed(ain) + signed(bin));
end Behavioral;



------------------------------------ sub -----------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity q428_sub is
Port ( 
    ain, bin: in std_logic_vector (31 downto 0);
    c: out std_logic_vector (31 downto 0)
);
end q428_sub;

architecture Behavioral of q428_sub is
begin
    c <= std_logic_vector(signed(ain) - signed(bin));
end Behavioral;
