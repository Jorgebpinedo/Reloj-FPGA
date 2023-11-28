library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity COUNTER is
  generic (
    DIGITS : positive := 6;
    N : int0_10_vector(5 downto 0) := (3,5,6,10,6,10) -- No se puede poner N : int0_10_vector(digits -1 downto 0)
  );
  port (
    RESET_N : in  std_logic;
    CLK     : in  std_logic;
    CE_N    : in  std_logic;
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
      BCD_OUT : out int0_9
    );
  end component;

  signal cout : std_logic_vector(BCD_OUT'range);

begin
  g1: for j in BCD_OUT'range generate
  begin
    digit_0: if j = 0 generate
    begin
      c0: BCDCNTR
       generic map(N => N(j))
        port map (
          RESET_N => RESET_N,
          CLK     => CLK,
          CIN     => CE_N,
          COUT    => cout(j),
          BCD_OUT => BCD_OUT(j)
        );
    end generate;    

    digit_j: if j /= 0 generate
    begin
      cj: BCDCNTR
        generic map(N => N(j))
        port map (
          RESET_N => RESET_N,
          CLK     => CLK,
          CIN     => cout(j - 1),
          COUT    => cout(j),
          BCD_OUT => BCD_OUT(j)
        );
    end generate;

    start_all: if BCD_OUT= "240000" then
	  BCD_OUT="000000";
  end generate;
end STRUCTURAL;
