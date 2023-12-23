--Convierte la señal en formato int0_9_vector a binario, aprovechando la función to_unsigned(). 
--Como el número máximo es 9, se indica que la función que la conversión será a 4 bits. La arquitectura es en dataflow, 
--de forma que cada dígito se convierte de forma concurrente. 

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity Int09ToBcd is
	generic( DIGITS : positive := 6);
	port(
		BCD_IN : in int0_9_vector(DIGITS -1 downto 0);
		BCD_OUT: out bcd_vector(DIGITS -1 downto 0)
	);
end entity;

architecture df of Int09ToBcd is

begin
	g: for i in bcd_in'range generate
		bcd_out(i) <= to_unsigned(bcd_in(i), 4); -- Conversión a unsigned de 4 bits
	end generate;

end architecture;