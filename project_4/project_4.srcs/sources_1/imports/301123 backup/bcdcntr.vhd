-- Componente simple que cuenta de 0 a 9 cuando detecte que CLK  y CIN esten a 1.
-- SI detecta que el reset esta a 0 reinicia la cuenta y si ve que LOAD esta a 1, la cuenta adquiere el valor que tenga BCD_IN.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.common.all;

entity BCDCNTR is
  generic ( N : natural := 10);
  port (
    LOAD    : in  std_logic;
    RESET_N : in  std_logic;
    CLK     : in  std_logic;
    CIN     : in  std_logic;
    COUT    : out std_logic;
    BCD_IN  : in int0_9;
    BCD_OUT : inout int0_9
  );
end BCDCNTR;

architecture BEHAVIORAL of BCDCNTR is
  subtype count_t is integer range 0 to N -1;
  signal count : count_t;
begin
  process (RESET_N, CLK)
  begin
    if RESET_N = '0' then
      count <= 0;
    elsif LOAD = '1' then
        count <= BCD_IN;
    elsif rising_edge(CLK) then
      if CIN = '1' then
        count <= (count + 1) mod N;
      end if;
    end if;
  end process;

  BCD_OUT <= int0_9(count);
  COUT <= '1' when CIN = '1' and count = N -1 else
          '0';
end BEHAVIORAL;
