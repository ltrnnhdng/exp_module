library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ThresCompare is
    port (
        din  : in  std_logic_vector(31 downto 0);  -- Q4.28 input
        dout : out std_logic                      -- 1 = in range, 0 = out
    );
end entity ThresCompare;

architecture rtl of ThresCompare is

    -- Q4.28 thresholds
    constant THRESH_POS : signed(31 downto 0) := to_signed(11585542, 32);
    constant THRESH_NEG : signed(31 downto 0) := to_signed(-11585542, 32);

begin

    process(din)
        variable x : signed(31 downto 0);
    begin
        x := signed(din);

        if (x >= THRESH_NEG) and (x <= THRESH_POS) then
            dout <= '1';
        else
            dout <= '0';
        end if;
    end process;

end architecture rtl;
