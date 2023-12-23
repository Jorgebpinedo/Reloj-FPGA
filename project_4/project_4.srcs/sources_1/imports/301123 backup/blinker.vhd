library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

-- Actúa como un filtro: mediante las señales de parpadeo (x_blink) le indico
-- si tienen que parpadear los segundos, minutos u horas.
-- Cada segundo (clk_seg) se cambia el valor de los bits de digits, provocando
-- un parpadeo.
entity Blinker is
	port(
		clk_seg, reset_n: in std_logic;
		seg_blink, min_blink, h_blink : in std_logic;
		digits_in_n : in std_logic_vector(7 downto 0);
		digits_out_n : out std_logic_vector(7 downto 0)
	);

end entity;

architecture bhvl of Blinker is 

begin
    digits_out_n(1 downto 0) <= (others => '1') when (clk_seg = '1' and seg_blink = '1' and 
                                (digits_in_n(1) = '0' or digits_in_n(0) = '0')) else digits_in_n(1 downto 0);
                                
    digits_out_n(3 downto 2) <= (others => '1') when (clk_seg = '1' and min_blink = '1' and 
                                (digits_in_n(3) = '0' or digits_in_n(2) = '0')) else digits_in_n(3 downto 2);

    digits_out_n(5 downto 4) <= (others => '1') when (clk_seg = '1' and h_blink = '1' and 
                                (digits_in_n(5) = '0' or digits_in_n(4) = '0')) else digits_in_n(5 downto 4);
                                
    digits_out_n(7 downto 6) <= digits_in_n(7 downto 6);
end architecture;
