library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

entity fpga_reloj is
    generic(DIGITS : positive := 6;
            RFRSH_RATE : positive := 100;
            CLK_FREQ : positive := 1E8
            );
    port(modo, pausar_reanudar, chorag, reset_button : in std_logic;
         reset_n : in std_logic;
         CLK100MHZ : in std_logic;
         digits_n, segments_n : out std_logic_vector(7 downto 0)
         );
end fpga_reloj;

architecture Behavioral of fpga_reloj is

-- Sincronizador entradas (pulsadores)
component INPUT_CNDTNR is
  port (
    RESET_N  : in  std_logic;
    CLK      : in  std_logic;
    ASYNC_IN : in  std_logic;
    EDGE     : out std_logic
  );
end component;

-- Máquina de estados
component fsm is
    generic(DIGITS : positive := 6);
    port( clk, reset_n, modo, pausar_reanudar, chorag, reset_button : in std_logic;
          BCD_OUT : out int0_9_vector(DIGITS - 1 downto 0);
          seg_blink, min_blink, h_blink : out std_logic;
          state_g, state_c: out states
          );
end component;

-- Visualizador
component VisualizadorBlinker is 
    generic
  (
    DIGITS     : positive :=  6; 
    RFRSH_RATE : positive := 100;
    CLK_FREQ   : positive := 1E8
  );
  port (
    RESET_N    : in  std_logic;
    CLK        : in  std_logic;
    BCD_IN     : in  int0_9_vector(DIGITS - 1 downto 0);
    seg_blink  : in std_logic;
    min_blink  : in std_logic;
    h_blink    : in std_logic;
    SEGMNTS_N  : out std_logic_vector(7 downto 0); -- Qué segmentos activar
    DIGITS_N   : out std_logic_vector(7 downto 0) -- Qué dígitos activar
  );
end component;

-- Generador de pulsos de reloj
component TIMER is
  generic (
    MODULO  : positive := 416667
  );
  port ( 
    RESET_N : in   std_logic;
    CLK     : in   std_logic;
    STROBE  : out  std_logic
  );
end component;

signal clk_seg : std_logic := '0'; -- Señal de reloj en segundo
signal modo_synch, pausar_reanudar_synch, chorag_synch, reset_button_synch : std_logic := '0'; -- Señales de entrada sincronizadas
signal bcd_fsm_vblinker : int0_9_vector(5 downto 0) := (0,0,0,0,0,0);
signal seg_blink, min_blink, h_blink : std_logic := '0';

-- Temporales mientras se prueban las unidades funcionales
signal state_g, state_c : states;

begin
-- Señales de reloj
segundero1: timer 
        generic map(modulo => 1E8+1)
        port map(reset_n => '1',
                 clk => CLK100MHZ,
                 strobe => clk_seg
                 );

-- Sincronizadores de las entradas
sync_modo1: INPUT_CNDTNR 
  port map (
    RESET_N  => '1', -- Siempre funciona
    CLK      => CLK100MHZ, 
    ASYNC_IN => modo,
    EDGE     => modo_synch
  );

sync_pausar_reanudar1: INPUT_CNDTNR 
  port map (
    RESET_N  => '1', -- Siempre funciona
    CLK      => CLK100MHZ, 
    ASYNC_IN => pausar_reanudar,
    EDGE     => pausar_reanudar_synch
  );
  
sync_chorag1: INPUT_CNDTNR 
  port map (
    RESET_N  => '1', -- Siempre funciona
    CLK      => CLK100MHZ, 
    ASYNC_IN => chorag,
    EDGE     => chorag_synch
  );
  
sync_reset_button1: INPUT_CNDTNR 
  port map (
    RESET_N  => '1', -- Siempre funciona
    CLK      => CLK100MHZ, 
    ASYNC_IN => reset_button,
    EDGE     => reset_button_synch
  );
  
-- FSM
fsm1: FSM 
    port map(clk => CLK100MHZ, 
             reset_n => '1',
             modo => modo_synch, 
             pausar_reanudar => pausar_reanudar_synch, 
             chorag => chorag_synch,
             reset_button => reset_button_synch, 
             bcd_out => bcd_fsm_vblinker,
             seg_blink => seg_blink,
             min_blink => min_blink,
             h_blink => h_blink, 
             state_g => state_g, 
             state_c => state_c
             );

-- Visualizador de la salida
vblinker1: VisualizadorBlinker
            generic map(digits => digits, rfrsh_rate => rfrsh_rate, clk_freq => clk_freq)
            port map(reset_n => reset_n,
                     clk => CLK100MHZ,
                     bcd_in => bcd_fsm_vblinker,
                     seg_blink => seg_blink,
                     min_blink => min_blink,
                     h_blink => h_blink,
                     segmnts_n => segments_n,
                     digits_n => digits_n
                     );
end Behavioral;
