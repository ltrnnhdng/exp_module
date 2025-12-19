library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- op sel = 1 -> add
-- op sel = 0 -> sub

entity addsub is
Port ( 
    op_sel :in std_logic;
    a,b : in std_logic_vector (31 downto 0);
    c : out std_logic_vector (31 downto 0)
);
end addsub;


architecture Behavioral of addsub is

    -- adder and subtractor declarations
    component q428_add -- adder
    port (
        signal ain, bin: in std_logic_vector (31 downto 0);
        signal c: out std_logic_vector (31 downto 0)
    );
    end component;
    
    component q428_sub -- subtractor
    port (
        signal ain, bin: in std_logic_vector (31 downto 0);
        signal c: out std_logic_vector (31 downto 0)
    );
    end component;
    
    -- signal declaration
    signal add_res, sub_res: std_logic_vector (31 downto 0);
    
    -- start here
    BEGIN
    adder : q428_add port map (ain => a, bin => b, c => add_res);
    subtractor: q428_sub port map (ain => a, bin => b, c => sub_res);

    c <= add_res when op_sel = '1' else sub_res;

END Behavioral;

