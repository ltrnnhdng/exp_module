library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bitshift is
  Port (
    data     : in  std_logic_vector(31 downto 0);
    shift_i  : in  std_logic_vector(31 downto 0);  -- ch? c?n 5 bit
    data_out : out std_logic_vector(31 downto 0)
  );
end bitshift;

architecture Behavioral of bitshift is
  signal s0, s1, s2, s3, s4 : std_logic_vector(31 downto 0);
begin

  -- Shift 1 bit
  s0 <= data when shift_i(0) = '0' else
        data(31) & data(31 downto 1);

  -- Shift 2 bit
  s1 <= s0 when shift_i(1) = '0' else
        (s0(31) & s0(31)) & s0(31 downto 2);

  -- Shift 4 bit
  s2 <= s1 when shift_i(2) = '0' else
        (s1(31) & s1(31) & s1(31) & s1(31)) & s1(31 downto 4);

  -- Shift 8 bit
  s3 <= s2 when shift_i(3) = '0' else
        (s2(31) & s2(31) & s2(31) & s2(31) &
         s2(31) & s2(31) & s2(31) & s2(31)) & s2(31 downto 8);

  -- Shift 16 bit
  s4 <= s3 when shift_i(4) = '0' else
      (s3(31) & s3(31) & s3(31) & s3(31) &
       s3(31) & s3(31) & s3(31) & s3(31) &
       s3(31) & s3(31) & s3(31) & s3(31) &
       s3(31) & s3(31) & s3(31) & s3(31)) & s3(31 downto 16);


  data_out <= s4;

end Behavioral;
