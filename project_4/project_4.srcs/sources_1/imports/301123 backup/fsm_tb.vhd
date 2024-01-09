-- Test bench de la entidad fsm

library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity fsm_tb is
end fsm_tb;

architecture tb of fsm_tb is

    component fsm is
        generic(DIGITS : positive := 6);
        port( clk, reset_n, modo, pausar_reanudar, chorag, reset_button : in std_logic;
              BCD_OUT : out int0_9_vector(DIGITS - 1 downto 0);
              seg_blink, min_blink, h_blink : out std_logic;
              state_g, state_c : out states
              );
    end component;
    
    signal clk : std_logic := '0';
    signal reset_n : std_logic := '1';
    signal modo, pausar_reanudar, chorag, reset_button : std_logic := '0';
    signal bcd_out : int0_9_vector(5 downto 0);
    signal seg_blink, min_blink, h_blink : std_logic;
    signal state_g, state_c : states;

begin

    dut : fsm 
          port map(clk => clk, reset_n => reset_n, modo => modo, pausar_reanudar => pausar_reanudar, chorag => chorag,
                   reset_button => reset_button, bcd_out => bcd_out, 
                   seg_blink => seg_blink, min_blink => min_blink, h_blink => h_blink,
                   state_g => state_g, state_c => state_c);

	clock: clk <= not clk after 5 ns;
    reset_signal: reset_n <= '1';
    
    stimuli : process
    begin
       wait for 90 ns;
        modo <= '1'; -- Crono
       wait for 20 ns; 
        modo <= '0';
        wait for 20 ns;
        modo <= '1'; -- Temp (cambiar segundos)
       wait for 20 ns; 
        modo <= '0';
       wait for 20 ns;
       
       for i in 10 downto 0 loop -- Carga 10 segundos
        pausar_reanudar <= '1';
        wait for 10 ns;
        pausar_reanudar <= '0';
        wait for 10 ns;
       end loop;
       
        wait for 20 ns;
        reset_button <= '1'; -- Cambiar minutos
       wait for 20 ns; 
        reset_button <= '0';
        wait for 20 ns;
        
         for i in 6 downto 0 loop -- Carga 6 minutos
        pausar_reanudar <= '1';
        wait for 10 ns;
        pausar_reanudar <= '0';
        
        wait for 10 ns;
       end loop;
        wait for 20 ns;
        reset_button <= '1'; -- Cambiar horas
       wait for 20 ns; 
        reset_button <= '0';
       wait for 20 ns; 
        reset_button <= '1'; -- Pausa
       wait for 20 ns;
        reset_button <= '0';
       wait for 20 ns;
        pausar_reanudar <= '1'; -- Temporizando
       wait for 20 ns;
        pausar_reanudar <= '0';
       wait for 100 ns;
        pausar_reanudar <= '1'; -- Pausa
       wait for 20 ns;
        modo <= '1';
        wait for 20 ns;
        modo <= '1';
        wait;

    end process;

end tb;
