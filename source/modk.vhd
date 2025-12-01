-- module nay thuc hien trich xuat k va x'
-- trong do k = mod(x, ln2 )
--          x' = x - k*ln2
-- tuy nhien trong pham vi -2 va 2, tap gia tri cua k chi co +-2, +-1 va 0
-- doi voi gia tri x_in = 1,  k = 1 nhung do module co the tinh toan voi x = 1 nen co the bo qua, chi giu lai +-2 va 0
-- module nay la 1 bo chon gia tri cua x' va k
--  

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity xtinyk_sel is port( 
    x_in : in std_logic_vector(31 downto 0); -- Q4.28
    k_out : out std_logic_vector(31 downto 0); -- signed 4-bit 
    x_tiny : out std_logic_vector(31 downto 0) -- Q4.28
); 
end entity;
architecture behave of xtinyk_sel is
   
begin
   -- Process ch?n k_out và kln2
   control : process(x_in)
   begin
      if ((x_in(29) = '1' or x_in(28) = '1') and x_in(31) = '0') then
            k_out <= x"00000002";  -- 2
            x_tiny  <= x"162E42FF"; -- (2)* ln2
            
       elsif (x_in(31) = '1' and x_in(28) = '0') then 
            k_out <= x"80000002"; -- -2
            x_tiny  <= x"E9D1BD03"; -- (-2)* ln2
       else 
            k_out <= (others => '0');  -- 0
            x_tiny  <= (others => '0');
            
       end if;
    end process;

end architecture;
