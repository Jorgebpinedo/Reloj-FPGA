-- Diseñar un demultiplexor con un número genérico de salidas usando código concurrente.
-- Todos los canales estarán a 0 salvo el canal en el que se escribe.

library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity tb_blinker is
end tb_blinker;

architecture tb of tb_blinker is

    component VisualizadorBlinker is 
    generic
  (
    DIGITS     : positive :=  6; 
    RFRSH_RATE : positive := 30;
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
    
    constant digits : positive := 6;
    constant rfrsh_rate : positive := 30;
    constant clk_freq : positive := 1E8;
    signal clk, clk_seg, reset_n, seg_b, min_b, h_b : std_logic := '0';
    signal segments_n : std_logic_vector(7 downto 0);
    signal digits_n : std_logic_vector(7 downto 0);
    signal bcd_in : int0_9_vector(digits -1 downto 0);

begin

    dut : VisualizadorBlinker
    generic map(digits => digits, rfrsh_rate => rfrsh_rate, clk_freq => clk_freq)
    port map (clk => clk,
              reset_n => reset_n,
              seg_blink => seg_b,
              min_blink => min_b,
              h_blink => h_b,
              segmnts_n => segments_n,
              digits_n => digits_n,
              bcd_in => bcd_in
              );

	clock: clk <= not clk after 50 ns;
    reset_signal: reset_n <= '0', '1' after 75 ns;
    
    stimuli : process
    begin
        bcd_in <= (1,2,3,4,5,6); 
        seg_b <= '1'; min_b <= '0'; h_b <= '0';
        wait;

    end process;

end tb;

configuration cfg_tb_blinker of tb_blinker is
    for tb
    end for;
end cfg_tb_blinker;
