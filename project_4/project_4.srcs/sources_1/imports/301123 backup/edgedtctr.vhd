----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:40:05 12/11/2019 
-- Design Name: 
-- Module Name:    synchrnzr - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
  port ( 
    RESET_N  : in  std_logic;
    CLK      : in  std_logic;
    SYNC_IN  : in  std_logic;
    EDGE     : out std_logic
  );
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is
  signal sreg : std_logic_vector(2 downto 0);
begin
  process (RESET_N, CLK)
  begin
    if RESET_N = '0' then
      sreg <= (others => '0');
    elsif rising_edge(CLK) then
      sreg <= sreg(1 downto 0) & SYNC_IN;
    end if;
  end process;
 
  with sreg select
    EDGE <= '1' when "011",
            '0' when others;
end BEHAVIORAL;