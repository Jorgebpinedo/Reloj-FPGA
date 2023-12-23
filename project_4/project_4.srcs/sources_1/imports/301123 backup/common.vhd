--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common is

  subtype bcd is unsigned(3 downto 0);
  subtype int0_9 is integer range 0 to 9;
  subtype int0_10 is integer range 0 to 10;
  type bcd_vector is array(integer range <>) of bcd;
  type int0_9_vector is array(integer range <>) of int0_9;
  type int0_10_vector is array(integer range <>) of int0_10;
  
  type states is (RELOJ, CAMBIAR_HORA_G, TEMP, CRONO, -- Globales
                CAMBIAR_SEG, CAMBIAR_MIN, CAMBIAR_H, CONFIRMAR, -- Cambiar hora
                PAUSA, CRONOMETRANDO, -- Cronómetro
                TEMPORIZANDO -- Temporizador
                );

end common;

package body common is
end common;
