library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity COUNTER is
  generic (
    DIGITS : positive := 6;
    N : int0_10_vector(5 downto 0) := (3,10,6,10,6,10) -- No se puede poner N : int0_10_vector(digits -1 downto 0)
  );
  port (
    RESET_N : in  std_logic;
    CLK     : in  std_logic;
    CE_N    : in  std_logic;
    LOAD    : in  std_logic;
    BCD_IN  : in int0_9_vector(DIGITS - 1 downto 0);
    BCD_OUT : inout int0_9_vector(DIGITS - 1 downto 0)
  );
end COUNTER;

architecture STRUCTURAL of COUNTER is

  component BCDCNTR is
    generic( N : natural := 10);
    port (
      RESET_N : in  std_logic;
      CLK     : in  std_logic;
      CIN     : in  std_logic;
      COUT    : out std_logic;
      LOAD    : in  std_logic;
      BCD_IN  : in int0_9;
      BCD_OUT : inout int0_9
    );
  end component;

  signal cout : std_logic_vector(BCD_OUT'range);
  signal restart: std_logic;
begin
  restart<='0' when BCD_OUT(5) = 2 and BCD_OUT(4) = 4  else RESET_N;
  g1: for j in BCD_OUT'range generate
  begin
    digit_0: if j = 0 generate
    begin
      c0: BCDCNTR
       generic map(N => N(j))
        port map (
          RESET_N => restart,
          CLK     => CLK,
          CIN     => CE_N,
          COUT    => cout(j),
          LOAD    => load,
          BCD_IN  => BCD_IN(j),
          BCD_OUT => BCD_OUT(j)
          
        );
    end generate;    

    digit_j: if j /= 0 generate
    begin
      cj: BCDCNTR
        generic map(N => N(j))
        port map (
          RESET_N => restart,
          CLK     => CLK,
          CIN     => cout(j - 1),
          COUT    => cout(j),
          LOAD    => load,
          BCD_IN  => BCD_IN(j),
          BCD_OUT => BCD_OUT(j)
        );
    end generate;
  end generate;
end STRUCTURAL;
