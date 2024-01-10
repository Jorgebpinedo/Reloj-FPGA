--Implementa un multiplexor que elige el canal a activar en función de la entrada de selección.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.common.all;

entity MUXER is
  generic (
    DIGITS : positive := 4
  );
  port (
    SEL     : in  std_logic_vector(DIGITS - 1 downto 0);
    BCD_IN  : in  bcd_vector(DIGITS - 1 downto 0);
    BCD_OUT : out bcd
  );
end MUXER;

architecture BEHAVIORAL of MUXER is

-- Comprueba que únicamente uno de los bits de la secuencia generada por el scanner está a 0.
  function has_one_zero(signal data : std_logic_vector) return boolean is
    variable count : natural := 0;
  begin
    for i in data'high downto data'low loop
      if data(i) = '0' then
        count := count + 1; -- Contador del número de bits a 0
      end if;
    end loop;
    return count = 1; -- Devuelve 1 siempre que solamente uno de los bits esté a 0
  end function;

-- Localiza la posición del bit de la secuencia que está a 0
  function msz(signal data : std_logic_vector) return integer is
  begin
    for i in data'high downto data'low loop
      if data(i) = '0' then
        return i; -- Devuelve la posición del bit que está a 0
      end if;
    end loop;
    return integer'low; -- En caso de no encontrar ningún bit a 0 devuelve la posición más baja
  end function;

begin
-- Habilita la entrada cuyo bit en la secuencia generada por el scanner está a 0
-- Debe existir un 0 en la secuencia
  BCD_OUT <= BCD_IN(msz(SEL)) when has_one_zero(SEL) else
             (others => '-');
end BEHAVIORAL;

