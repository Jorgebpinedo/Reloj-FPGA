library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.common.all;

entity BCDTEMP is
  generic ( N : natural := 10);
  port (
    BCD_IN  : in  int0_9;
    RESET_N : in  std_logic;
    CLK     : in  std_logic;
    CIN     : in  std_logic;
    TERMINATE:in  std_logic;
    COUT    : out std_logic;
    BCD_OUT : inout int0_9
  );
end BCDTEMP;

architecture BEHAVIORAL of BCDTEMP is
  subtype count_t is integer range 0 to N -1;
  signal count : count_t;
begin
  process (RESET_N, CLK, TERMINATE)
  begin
    if RESET_N = '0' then
      count <= N - 1 - integer(BCD_IN); --cargar último valor inicial al contador
    elsif TERMINATE = '0' then
      count <= N - 1;
    elsif rising_edge(CLK) then
      if CIN = '1' then
        count <= (count + 1) mod N;
      end if;
    end if;
   end process;

  BCD_OUT <= int0_9(N - 1 - count);
  COUT <= '1' when CIN = '1' and BCD_OUT = 0 else
          '0';
end BEHAVIORAL;
