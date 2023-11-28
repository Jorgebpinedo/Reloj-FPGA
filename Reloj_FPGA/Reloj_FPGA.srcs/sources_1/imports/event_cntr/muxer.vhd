----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:31:03 11/21/2019 
-- Design Name: 
-- Module Name:    muxer - Behavioral 
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
use ieee.numeric_std.all;

use work.common.all;

entity MUXER is
  generic (
    DIGITS : positive := 4
  );
  port (
    SEL     : in  std_logic_vector(DIGITS - 1 downto 0);
    BCD_IN  : in  bcd_vector(DIGITS - 1 downto 0);
    BCD_OUT : out bcd
  );
end MUXER;

architecture BEHAVIORAL of MUXER is

  function has_one_zero(signal data : std_logic_vector) return boolean is
    variable count : natural := 0;
  begin
    for i in data'high downto data'low loop
      if data(i) = '0' then
        count := count + 1;
      end if;
    end loop;
    return count = 1;
  end function;

  function msz(signal data : std_logic_vector) return integer is
  begin
    for i in data'high downto data'low loop
      if data(i) = '0' then
        return i;
      end if;
    end loop;
    return integer'low;
  end function;

begin
  BCD_OUT <= BCD_IN(msz(SEL)) when has_one_zero(SEL) else
             (others => '-');
end BEHAVIORAL;

