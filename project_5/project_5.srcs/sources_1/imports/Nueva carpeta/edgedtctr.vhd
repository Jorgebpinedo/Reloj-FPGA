--Se usa un registro de desplazamiento de 3 bits. 
--En cada ciclo de reloj se corren los bits hacia la siguiente posición del registro, eliminando el bit más antiguo. 
--Cuando se detecte un flanco de bajada (es decir 011, donde el 0 es el bit más antiguo y los 11son los bits recibidos a continuación) 
--se genera un pulso de nivel alto (Edge). En cualquier otro caso, la salida será 0, por lo que se tendrá una onda de pulsos por cada flanco de bajada. 
--La razón de usar 3 bits en el registro de desplazamiento es asegurar que la bajada del flanco se mantiene y no es un estado transitorio.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
  port ( 
    RESET_N  : in  std_logic;
    CLK      : in  std_logic;
    SYNC_IN  : in  std_logic;
    EDGE     : out std_logic
  );
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is
  signal sreg : std_logic_vector(2 downto 0);-- Registro de desplazamiento de 3 bits. Se pretende detectar
begin
  process (RESET_N, CLK)
  begin
    if RESET_N = '0' then
      sreg <= (others => '0');
    elsif rising_edge(CLK) then
      sreg <= sreg(1 downto 0) & SYNC_IN; -- Desplazamiento de los bits
    end if;
  end process;
 
  with sreg select
    EDGE <= '1' when "011", -- Detección de flanco
            '0' when others;
end BEHAVIORAL;