library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity TIMER is
  generic (
    MODULO  : positive := 416667
  );
  port ( 
    RESET_N : in   std_logic;
    CLK     : in   std_logic;
    STROBE  : out  std_logic
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
      count := (count + 1) mod MODULO;
    end if;

    if count = MODULO - 1 then
      STROBE <= '1';
    else
      STROBE <= '0';
    end if;
  end process;
end BEHAVIORAL;
