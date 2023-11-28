----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:52:59 11/21/2019 
-- Design Name: 
-- Module Name:    bin2seg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity BIN2SEG is
  port (
    BCDVAL   : in  bcd;
    SEGMENTS : out std_logic_vector(6 downto 0)
  );
end BIN2SEG;

architecture DATAFLOW of BIN2SEG is
begin

  --     a
  --    ---
  -- f | g | b
  --    ---
  -- e | d | c
  --    ---

  with BCDVAL select
              -- GFEDCBA
    SEGMENTS <= "0111111" when X"0",
                "1111001" when X"1",
                "0100100" when X"2",
                "0110000" when X"3",
                "0011001" when X"4",
                "0010010" when X"5",
                "0000010" when X"6",
                "1111000" when X"7",
                "0000000" when X"8",
                "0010000" when X"9",
                "0100000" when X"A",
                "0000011" when X"B",
                "1000110" when X"C",
                "0100001" when X"D",
                "0000110" when X"E",
                "0001110" when others;

end DATAFLOW;

