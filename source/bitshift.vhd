library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bitshift is
  Port ( 
    data     : in  std_logic_vector(15 downto 0);
    shift_i  : in  std_logic_vector(15 downto 0);   
    data_out : out std_logic_vector(15 downto 0)
  );
end bitshift;

architecture Behavioral of bitshift is
  signal s0, s1, s2, s3 : std_logic_vector(15 downto 0);
begin

  -- Dịch 1 bit (nếu shift_i(0) = '1')
  s0 <= data when shift_i(0) = '0' else 
        data(15) & data(15) & data(14 downto 1);  -- Giữ bit dấu (data(15))

  -- Dịch thêm 2 bit (nếu shift_i(1) = '1')
  s1 <= s0 when shift_i(1) = '0' else 
        s0(15) & s0(15) & s0(15) & s0(14 downto 2);

  -- Dịch thêm 4 bit (nếu shift_i(2) = '1')
  s2 <= s1 when shift_i(2) = '0' else 
        (s1(15) & s1(15) & s1(15) & s1(15) & s1(15) & s1(14 downto 4));

  -- Dịch thêm 8 bit (nếu shift_i(3) = '1')
  s3 <= s2 when shift_i(3) = '0' else 
        (s2(15) & s2(15) & s2(15) & s2(15) & s2(15) & s2(15) & s2(15) & s2(15) &
         s2(15) & s2(14 downto 8));

  -- Kết quả cuối
  data_out <= s3;

end Behavioral;
