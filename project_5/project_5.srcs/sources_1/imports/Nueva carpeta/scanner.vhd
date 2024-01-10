--Genera una secuencia de bits de tamaño igual al número de displays a controlar. 
--El bit que se encuentre a 0 representa el dígito que se activará. 

library ieee;
use ieee.std_logic_1164.all;

entity SCANNER is
  generic (
    DIGITS : positive := 4
  );
  port (
    RESET_N : in  std_logic;
    CLK     : in  std_logic;
    CE      : in  std_logic;
    SEL     : out std_logic_vector(DIGITS - 1 downto 0) -- Salida a las entradas de selección
  );
end SCANNER;

architecture BEHAVIORAL of SCANNER is

  signal sel_i : std_logic_vector(SEL'range);

begin

  process (RESET_N, CLK)
  begin
    if RESET_N = '0' then
      sel_i <= (0 => '0', others => '1'); 
    elsif rising_edge(CLK) then
      if CE = '1' then
        sel_i <= sel_i(sel_i'high - 1 downto 0) & sel_i(sel_i'high); -- Rota los bits hacia la izquierda
      end if;
    end if;
  end process;
  
  SEL <= sel_i;

end BEHAVIORAL;
