-- Integra SYNCHRNZR y EDGEDTCTR usando la arquitectura structural

library ieee;
use ieee.std_logic_1164.all;

entity INPUT_CNDTNR is
  port (
    RESET_N  : in  std_logic;
    CLK      : in  std_logic;
    ASYNC_IN : in  std_logic;
    EDGE     : out std_logic
  );
end INPUT_CNDTNR;

architecture STRUCTURAL of INPUT_CNDTNR is

  component SYNCHRNZR is -- Sincronizador
    port ( 
      RESET_N  : in  std_logic;
      CLK      : in  std_logic;
      ASYNC_IN : in  std_logic;
      SYNC_OUT : out std_logic
    );
  end component;
  
  component EDGEDTCTR is -- Detector de flancos
    port (
      RESET_N  : in  std_logic;
      CLK      : in  std_logic;
      SYNC_IN  : in  std_logic;
      EDGE     : out std_logic
    );
  end component;

  signal sync_out : std_logic;

begin
-- Conexiones de las entidades
  synchro1: SYNCHRNZR
    port map ( 
      RESET_N  => RESET_N,
      CLK      => CLK,
      ASYNC_IN => ASYNC_IN,
      SYNC_OUT => sync_out
    );

  edgedtctr1: EDGEDTCTR
    port map (
      RESET_N  => RESET_N,
      CLK      => CLK,
      SYNC_IN  => sync_out,
      EDGE     => EDGE
    );
end STRUCTURAL;

