library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modk is
    port(
        x_in       : in  std_logic_vector(31 downto 0);  -- Q2.30
        k_out      : out std_logic_vector(3 downto 0);   -- signed 4-bit
        x_minimize : out std_logic_vector(31 downto 0)   -- Q2.30
    );
end entity;

architecture behave of modk is

    -- h?ng s? ln(2) ~ 0.693147 trong Q2.30
    constant LN2_Q30 : signed(31 downto 0) := to_signed(integer(0.693147 * 2.0**30), 32);
    constant HALF_LN2_Q30 : signed(31 downto 0) := to_signed(integer(0.34657359 * 2.0**30), 32);

    signal x, x_temp : signed(31 downto 0);
    signal k         : signed(3 downto 0);

begin
    process(x_in)
    begin
        x := signed(x_in);
        k := (others => '0');

        -- l?p t?i ?a 3 l?n ?? ??a v? [-ln(2)/2, ln(2)/2]
        for i in 0 to 2 loop
            if x > HALF_LN2_Q30 then
                x := x - LN2_Q30;
                k := k + 1;
            elsif x < -HALF_LN2_Q30 then
                x := x + LN2_Q30;
                k := k - 1;
            else
                exit;
            end if;
        end loop;

        x_minimize <= std_logic_vector(x);
        k_out <= std_logic_vector(k);
    end process;

end architecture;
