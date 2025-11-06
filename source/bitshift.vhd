library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bitshift is
  Port ( 
    data     : in  std_logic_vector(15 downto 0);
    shift_i  : in  std_logic_vector(15 downto 0);   -- ch? c?n 4 bit vì t?i ?a 16 v? trí
    data_out : out std_logic_vector(15 downto 0)
  );
end bitshift;

architecture Behavioral of bitshift is
  signal s0, s1, s2, s3 : std_logic_vector(15 downto 0);
begin

  -- D?ch 1 bit (n?u shift_i(0) = '1')
  s0 <= data when shift_i(0) = '0' else 
        data(15) & data(15) & data(14 downto 1);  -- Gi? bit d?u (data(15))

  -- D?ch thêm 2 bit (n?u shift_i(1) = '1')
  s1 <= s0 when shift_i(1) = '0' else 
        s0(15) & s0(15) & s0(15) & s0(14 downto 2);

  -- D?ch thêm 4 bit (n?u shift_i(2) = '1')
  s2 <= s1 when shift_i(2) = '0' else 
        (s1(15) & s1(15) & s1(15) & s1(15) & s1(15) & s1(14 downto 4));

  -- D?ch thêm 8 bit (n?u shift_i(3) = '1')
  s3 <= s2 when shift_i(3) = '0' else 
        (s2(15) & s2(15) & s2(15) & s2(15) & s2(15) & s2(15) & s2(15) & s2(15) &
         s2(15) & s2(14 downto 8));

  -- K?t qu? cu?i
  data_out <= s3;

end Behavioral;
