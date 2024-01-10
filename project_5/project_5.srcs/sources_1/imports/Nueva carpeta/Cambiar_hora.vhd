-- Entidad cambiar hora en la que mediante los flancos de subida de CLK, ce_n = 1 y los INC (de seg, min y horas), podemos seleccionar cada grupo de digitos (de seg, min y horas) para ir aumentando los numeros en cambiar hora.
-- Si el Reset esta a 0 se pondrian todos los digitos a 0.
-- Si el digito es 9 entonces en la siguiente iteracion se aumentaria 1 a el siguiente digito y este anterior pasaria a ser 0 (para el primer digito de seg, min y horas).
-- Cuando se llega a las 24h todos los digitos se ponen a 0.

library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity CAMBIAR_HORA is
generic (DIGITS : int0_9 := 6);
port(
CLK:      in std_logic;
INC_SEG:  in std_logic;
INC_MIN:  in std_logic;
INC_H:    in std_logic;
RESET_N:  in std_logic;
CE_N:     in std_logic;
BCD_OUT : out int0_9_vector(DIGITS - 1 downto 0)
);
end entity;





architecture BHVL of CAMBIAR_HORA is
signal bcd_out_s: int0_9_vector(DIGITS - 1 downto 0):=(others=>0);

begin

process(CLK, RESET_N)
begin
if RESET_N = '0' then
    bcd_out_s <= (others => 0);
        
elsif rising_edge(CLK) then
    if ce_n = '1' then 
        if INC_SEG = '1' then
            bcd_out_s(0) <= (bcd_out_s(0) + 1)mod 10;
            if bcd_out_s(0)= 9  then
                bcd_out_s(1)<= (bcd_out_s(1) + 1)mod 6;
            end if;
        end if;
        
        if INC_MIN = '1' then
            bcd_out_s(2) <= (bcd_out_s(2) + 1)mod 10;
                if bcd_out_s(2)= 9 then
                    bcd_out_s(3)<= (bcd_out_s(3) + 1)mod 6;
                end if;
       end if;
        
        if INC_H = '1' then
            if bcd_out_s(5) = 2 and bcd_out_s(4) = 4 then
                bcd_out_s(4)<= 0 ;
                bcd_out_s(5)<= 0 ;
            else
                 bcd_out_s(4) <= (bcd_out_s(4) + 1)mod 10;
                     if bcd_out_s(4)= 9  then
                        bcd_out_s(5)<= (bcd_out_s(5) + 1)mod 3;
                     end if;
            end if;
        end if;
     end if;
 end if;
end process;
bcd_out <= bcd_out_s;
end architecture;
