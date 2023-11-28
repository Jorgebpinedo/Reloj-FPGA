library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity TEMP is
  generic (
    DIGITS : positive := 6;
    N : int0_10_vector(5 downto 0) := (3,10,6,10,6,10) -- No se puede poner N : int0_10_vector(digits -1 downto 0)
  );
  port (
    BCD_IN  : in  int0_9_vector(DIGITS - 1 downto 0); 
    RESET_N : in  std_logic;
    CLK     : in  std_logic;
    CE_N    : in  std_logic;
    BCD_OUT : inout int0_9_vector(DIGITS - 1 downto 0)
  );
end TEMP;

architecture STRUCTURAL of TEMP is

  component BCDTEMP is
    generic( N : natural := 10);
    port (
     BCD_IN  : in  int0_9;
     RESET_N : in  std_logic;
     CLK     : in  std_logic;
     CIN     : in  std_logic;
     TERMINATE:in  std_logic;
     COUT    : out std_logic;
     BCD_OUT : inout int0_9
    );
  end component;

  signal cout : std_logic_vector(BCD_OUT'range);
  signal terminate: std_logic;
begin
  terminate<='0' when BCD_OUT(5) = 0 and BCD_OUT(4) = 0 and BCD_OUT(3) = 0 
  and BCD_OUT(2) = 0 and BCD_OUT(1) = 0 and BCD_OUT(0) = 0 
  else '1';
  g1: for j in BCD_IN'range generate
  begin
    digit_0: if j = 0 generate
    begin
      c0: BCDTEMP
       generic map(N => N(j))
         port map(
     BCD_IN => BCD_IN(j),
     RESET_N => RESET_N,
     CLK     => CLK,
     CIN     => CE_N,
     TERMINATE => terminate,
     COUT    => cout(j),
     BCD_OUT => BCD_OUT(j)
    );
    end generate;    

    digit_j: if j /= 0 generate
    begin
      cj: BCDTEMP
        generic map(N => N(j))
        port map (
          BCD_IN  => BCD_IN(j),
          RESET_N => RESET_N,
          CLK     => CLK,
          CIN     => cout(j - 1),
          TERMINATE => terminate,
          COUT    => cout(j),
          BCD_OUT => BCD_OUT(j)
        );
    end generate;
  end generate;
end STRUCTURAL;