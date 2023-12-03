library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity GenOndaCuadrada is
    generic(CLK_FREQ : positive := 1E8);
    port(clk : in std_logic;
         clk_squared : out std_logic
         );
end GenOndaCuadrada;

architecture Behavioral of GenOndaCuadrada is
    signal clk_squared_s : std_logic := '0';
    signal cont : natural := 0;
begin

p1: process(clk)
begin
    if rising_edge(clk) then
        cont <= (cont + 1) mod CLK_FREQ;
        if cont = CLK_FREQ - 1 then
            clk_squared_s <= not clk_squared_s;
        end if;
    end if;
end process;
clk_squared <= clk_squared_s;
end Behavioral;
