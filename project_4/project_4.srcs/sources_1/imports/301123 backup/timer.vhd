--Divide la frecuencia del reloj de entrada para adaptarla de forma que el parpadeo de los displays no sea apreciable al ojo humano 
--y el consumo por conmutación no sea excesivo.

--Se basa en un contador que se incrementa en 1 en cada flanco de reloj. 
--Cuando se llega al valor indicado por MODULO se produce un flanco en el reloj de salida y se reinicia la cuenta. 


library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity TIMER is
  generic (
    MODULO  : positive := 416667
  );
  port ( 
    RESET_N : in   std_logic;
    CLK     : in   std_logic; -- Reloj de entrada
    STROBE  : out  std_logic -- Reloj a menor frecuencia
  );
end TIMER;

architecture BEHAVIORAL of TIMER is
begin
  process (RESET_N, CLK)
    subtype count_t is natural range 0 to MODULO - 1; 
    variable count : count_t;
  begin
    if RESET_N = '0' then
      count := 0;
    elsif rising_edge(CLK) then
      count := (count + 1) mod MODULO; -- En cada flanco de reloj aumenta el contador en 1
    end if;

    if count = MODULO - 1 then
      STROBE <= '1'; -- Cuando se llegue al valor de MODULO - 1 se genera un flanco
    else
      STROBE <= '0';
    end if;
  end process;
end BEHAVIORAL;
