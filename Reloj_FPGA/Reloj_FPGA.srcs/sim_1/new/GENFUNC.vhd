----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2023 15:48:53
-- Design Name: 
-- Module Name: GENFUNC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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


entity clk_divider is
    Generic (frec: integer:=50000000);  -- default value is for 1hz
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_100M : out  STD_LOGIC;
           clk_1 : out std_logic);
end clk_divider;


architecture Behavioral of clk_divider is
signal clk_sig: std_logic;
begin
clk_sig <= '0';
  process (clk,reset)
  variable cnt:integer;
  begin
		if (reset='1') then
		  cnt:=0;
		  clk_sig<='0';
		elsif clk'event and clk='1' then
			cnt := cnt + 1;
            if (cnt=frec) then
				cnt:=0;
				clk_sig <=not(clk_sig);
			end if;
		end if;
  end process;
  clk_1<=clk_sig;

end Behavioral;
