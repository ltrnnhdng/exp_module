LIBRARY ieee ;
 USE ieee.std_logic_1164.all ;
 USE ieee.std_logic_unsigned.all ;
 ENTITY upcount IS
 PORT(
  Clock, nReset, E : IN STD_LOGIC ; --E: enable
 Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)) ;
 END upcount ;

 ARCHITECTURE Behavior OF upcount IS
 signal count: std_logic_vector(3 downto 0) := "0000";
 BEGIN
 PROCESS (   CLock, nReset)       
BEGIN
    if nReset = '0' then
        count <= "0000";
    elsif Clock'event and clock = '1' then
        if 'e' = '1' then
                count <= count +1;
        end if;
    end if;


 END PROCESS;
 
    Q <= count;
 END Behavior ;
