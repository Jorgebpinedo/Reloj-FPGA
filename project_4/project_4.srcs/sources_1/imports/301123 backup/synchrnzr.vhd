--Se crea un registro de desplazamiento interno, correspondiente a las salidas de cada biestable. 
--En cada flanco de reloj se realizan 2 operaciones: asignación del bit más significativo a la salida síncrona de la entidad; 
--y desplazamiento de los bits en el registro (la salida del primer biestable se convierte en la salida del segundo biestable, 
--y la entrada asíncrona se convierte en la salida del primer biestable).

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
  port ( 
    RESET_N  : in  std_logic;
    CLK      : in  std_logic;
    ASYNC_IN : in  std_logic; -- Entrada asíncrona
    SYNC_OUT : out std_logic -- Salida sincronizada
  );
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is
-- Registro de desplazamiento con salidas de los biestables
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
       sync_out <= sreg(1);-- Bit después de pasar por los 2 flip flops (estable)
       sreg <= sreg(0) & async_in; -- Desplazamiento de bits (async_in estará en estado metaestable)
     end if;
  end process;
end BEHAVIORAL;

