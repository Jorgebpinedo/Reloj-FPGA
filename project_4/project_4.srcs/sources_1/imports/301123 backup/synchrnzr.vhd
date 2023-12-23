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

entity SYNCHRNZR is
  port ( 
    RESET_N  : in  std_logic;
    CLK      : in  std_logic;
    ASYNC_IN : in  std_logic;
    SYNC_OUT : out std_logic
  );
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is
  signal sreg : std_logic_vector(1 downto 0);
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of sreg : signal is "TRUE";
begin
  process (RESET_N, CLK)
  begin
     if RESET_N = '0' then
       sync_out <= '0';
       sreg <= (others => '0');
     elsif rising_edge(CLK) then  
       sync_out <= sreg(1);
       sreg <= sreg(0) & async_in;
     end if;
  end process;
end BEHAVIORAL;

