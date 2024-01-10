-- La entidad top recoge mediante una arquitectura structural los componentes Counter, VisualizadorBlinker y timer.


library ieee;
use ieee.std_logic_1164.all;

use work.common.all;


entity top is 
port(CLK100MHZ, sblink, mblink, hblink, cen, reset_n : in std_logic;
    SEGMNTS_N  : out std_logic_vector(7 downto 0); -- Qué segmentos activar
    DIGITS_N   : out std_logic_vector(7 downto 0) -- Qué dígitos activar
    );
end entity;


architecture structural of top is

component COUNTER is
  generic (
    DIGITS : positive := 6;
    N : int0_10_vector(5 downto 0) := (3,10,6,10,6,10) -- No se puede poner N : int0_10_vector(digits -1 downto 0)
  );
  port (
    RESET_N : in  std_logic;
    CLK     : in  std_logic;
    CE_N    : in  std_logic;
    BCD_OUT : inout int0_9_vector(DIGITS - 1 downto 0)
  );
end component;

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

    constant digits : positive := 6;
    constant rfrsh_rate : positive := 100;
    constant clk_freq : positive := 1E8;
    signal clk, clk_seg, seg_b, min_b, h_b : std_logic := '0';
    signal segments_n : std_logic_vector(7 downto 0);
    signal bcd_in_out : int0_9_vector(digits -1 downto 0);


begin

timer1: timer 
        generic map(modulo => 1E8+1)
        port map(reset_n => reset_n,
                 clk => CLK100MHZ,
                 strobe => clk_seg
                 );
                 
vblinker1: VisualizadorBlinker
            generic map(digits => digits, rfrsh_rate => rfrsh_rate, clk_freq => clk_freq)
            port map(reset_n => reset_n,
                     clk => CLK100MHZ,
                     bcd_in => bcd_in_out,
                     seg_blink => sblink,
                     min_blink => mblink,
                     h_blink => hblink,
                     segmnts_n => segmnts_n,
                     digits_n => digits_n
                     );

counter1: counter
          port map(reset_n => reset_n,
                   clk => clk_seg,
                   ce_n => cen,
                   bcd_out => bcd_in_out
                   );

end architecture;