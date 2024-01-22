library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity fsm_tb is
end fsm_tb;

architecture tb of fsm_tb is

    component fsm is
        generic(DIGITS : positive := 6);
        port( clk, reset_n, modo, pausar_reanudar, chorag, reset_button : in std_logic;
              BCD_OUT : out int0_9_vector(DIGITS - 1 downto 0)
             -- state : out states
              );
    end component;
    
    signal clk : std_logic := '0';
    signal reset_n : std_logic := '1';
    signal modo, pausar_reanudar, chorag, reset_button : std_logic := '0';
    signal bcd_out : int0_9_vector(5 downto 0);
    signal state : states;

begin

    dut : fsm 
          port map(clk => clk, reset_n => reset_n, modo => modo, pausar_reanudar => pausar_reanudar, chorag => chorag,
                   reset_button => reset_button, bcd_out => bcd_out);

	clock: clk <= not clk after 5 ns;
    reset_signal: reset_n <= '0', '1' after 75 ns;
    
    stimuli : process
    begin
        wait for 10ns;
            modo <= '0'; -- Modo reloj
        wait for 90 ns; 
            modo <= '1'; -- Modo crono
        wait for 50 ns; 
            modo <= '0';
        wait;

    end process;

end tb;
