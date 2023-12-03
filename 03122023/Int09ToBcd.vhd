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
		bcd_out(i) <= to_unsigned(bcd_in(i), 4);
	end generate;

end architecture;