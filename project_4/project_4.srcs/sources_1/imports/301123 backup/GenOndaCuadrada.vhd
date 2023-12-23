--Transforma la señal de reloj por flanco en una señal de reloj por nivel, de tipo cuadrada. 
--Su funcionamiento se basa en un contador de flancos del reloj de entrada. 
--Cuando se llegue al valor indicado en CLK_FREQ la señal de salida cambiará de valor y se mantendrá en el nivel correspondiente 
--hasta que la siguiente cuenta vuelva a alcanzar CLK_FREQ.


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
        cont <= (cont + 1) mod CLK_FREQ; -- En cada flanco de reloj aumenta en 1 la cuenta
        if cont = CLK_FREQ - 1 then
            clk_squared_s <= not clk_squared_s; -- Cuando se llegue a CLK_FREQ - 1 se cambia el nivel de la señal cuadrada
        end if;
    end if;
end process;
clk_squared <= clk_squared_s;
end Behavioral;
