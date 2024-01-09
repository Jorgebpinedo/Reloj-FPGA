-- Desplaza los dos ultimos bits de sreg y se sustituye el ultimo por el SYNC_RESET. 
-- Este detectara que hay EDGE cuando todos los bits sean 1.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity reset2s is
 port (
 CLK_1S : in std_logic;
 SYNC_RESET : in std_logic;
 EDGE : out std_logic
 );
end reset2s;
architecture BEHAVIORAL of reset2s is
 signal sreg : std_logic_vector(2 downto 0);
begin
 process (CLK_1S)
 begin
 if rising_edge(CLK_1S) then
 sreg <= sreg(1 downto 0) & SYNC_RESET;
 end if;
 end process;
 with sreg select
 EDGE <= '1' when "111",
 '0' when others;
end BEHAVIORAL;