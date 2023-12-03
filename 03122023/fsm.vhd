library ieee;
use ieee.std_logic_1164.all;

use work.common.all;


entity fsm is
    generic(DIGITS : positive := 6);
    port( clk, reset_n, modo, pausar_reanudar, chorag, reset_button : in std_logic;
          BCD_OUT : out int0_9_vector(DIGITS - 1 downto 0);
          seg_blink, min_blink, h_blink : out std_logic;
          state_g, state_c: out states
          );
end fsm;

architecture Behavioral of fsm is
    -- Estados actuales (globales + locales)
    signal current_global_state : STATES := RELOJ;
    signal current_cambiar_hora_state : STATES := CAMBIAR_SEG;
    signal current_crono_state : STATES := PAUSA;
    signal current_temp_state : STATES := CAMBIAR_SEG;
    -- Estados siguientes (globales + locales)
    signal next_global_state : STATES;
    signal next_cambiar_hora_state : STATES;
    signal next_crono_state : STATES;
    signal next_temp_state : STATES;
    
    -- Reloj y cronómetro
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
    
    -- Timer interno
    component TIMER is
        generic (
            MODULO  : positive 
        );
        port ( 
            RESET_N : in   std_logic;
            CLK     : in   std_logic;
            STROBE  : out  std_logic
        );
    end component;
    
    -- Temporizador
    component TEMPORIZADOR is
      generic (
        DIGITS : positive := 6;
        N : int0_10_vector(5 downto 0) := (3,10,6,10,6,10) -- No se puede poner N : int0_10_vector(digits -1 downto 0)
      );
      port (
        BCD_IN  : in  int0_9_vector(DIGITS - 1 downto 0); 
        RESET_N : in  std_logic;
        CLK     : in  std_logic;
        CE_N    : in  std_logic;
        BCD_OUT : inout int0_9_vector(DIGITS - 1 downto 0)
      );
    end component;
    
    -- Cambiar hora
    component CAMBIAR_HORA is
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
    end component;
    
    signal clk_seg : std_logic;
    signal bcd_out_reloj, bcd_out_crono, bcd_out_temp : int0_9_vector(DIGITS -1 downto 0) := (others => 0);
    signal ce_crono, reset_crono_n : std_logic := '0'; -- Señales cronómetro
    signal ce_temp, load_temp_n : std_logic := '0';
    signal bcd_in_temp : int0_9_vector(DIGITS -1 downto 0) := (0,0,0,0,0,0);
    signal ce_chora_temp : std_logic := '1';
    signal inc_seg_temp, inc_min_temp, inc_h_temp : std_logic := '0';
    
    
begin
state_g <= current_global_state;
state_c <= current_temp_state;

-- Cambiar el valor del temporizador
ce_chora_temp <= '1' when (current_global_state = TEMP and 
                (current_temp_state = CAMBIAR_SEG or current_temp_state = CAMBIAR_MIN or current_temp_state = CAMBIAR_H)) else '0';
inc_seg_temp <= pausar_reanudar when (current_global_state = TEMP and current_temp_state = CAMBIAR_SEG and
 reset_button /= '1') else '0';
inc_min_temp <= pausar_reanudar when (current_global_state = TEMP and current_temp_state = CAMBIAR_MIN and
 reset_button /= '1') else '0';
inc_h_temp <= pausar_reanudar when (current_global_state = TEMP and current_temp_state = CAMBIAR_H and
 reset_button /= '1') else '0';
 
-- Blinkers
seg_blink <= '1' when (current_global_state = TEMP and current_temp_state = CAMBIAR_SEG) else '0';
min_blink <= '1' when (current_global_state = TEMP and current_temp_state = CAMBIAR_MIN) else '0';
h_blink <= '1' when (current_global_state = TEMP and current_temp_state = CAMBIAR_H) else '0';

-- Cronómetro
ce_crono <= '1' when current_crono_state = CRONOMETRANDO else '0';
reset_crono_n <= '0' when (current_global_state = CRONO and (current_crono_state = CRONOMETRANDO or current_crono_state = PAUSA) and reset_button = '1') else '1';

-- Temporizador
ce_temp <= '1' when current_temp_state = TEMPORIZANDO else '0';
load_temp_n <= '1' when (current_temp_state = TEMPORIZANDO or current_temp_state = PAUSA) else '0'; 

segundero1: timer 
        generic map(modulo => 1E8+1)-- 1E8+1 para cargarlo en la fpga
        port map(reset_n => reset_n,
                 clk => clk,
                 strobe => clk_seg
                 );

reloj1: counter
          port map(reset_n => reset_n,
                   clk => clk_seg,
                   ce_n => '1',-- Reloj siempre activo
                   bcd_out => bcd_out_reloj
                   );
                   
cronometro1: counter
          port map(reset_n => reset_crono_n,
                   clk => clk_seg,
                   ce_n => ce_crono,
                   bcd_out => bcd_out_crono
                   );

temporizador1: TEMPORIZADOR 
        port map(
        BCD_IN  => bcd_in_temp,
        RESET_N => load_temp_n,
        CLK     => clk_seg,
        CE_N    => ce_temp,
        BCD_OUT => bcd_out_temp
      );
      
cambiar_hora_temp1: CAMBIAR_HORA 
        port map(
            CLK => clk,
            INC_SEG => inc_seg_temp,
            INC_MIN => inc_min_temp,
            INC_H => inc_h_temp,
            RESET_N => reset_n,
            CE_N => ce_chora_temp,
            BCD_OUT => bcd_in_temp
        );


state_register: process(clk, reset_n)
    begin
        if reset_n = '0' then 
            current_global_state <= RELOJ;
            current_cambiar_hora_state <= CAMBIAR_SEG;
            current_crono_state <= PAUSA;
            current_temp_state <= CAMBIAR_SEG;
        elsif rising_edge(clk) then
            current_global_state <= next_global_state;
            current_cambiar_hora_state <= next_cambiar_hora_state;
            current_crono_state <= next_crono_state;
            current_temp_state <= next_temp_state;
        end if;
    end process;

nextstate_decoder: process(reset_button, modo, pausar_reanudar, chorag)

    begin
        next_global_state <= current_global_state;
        next_cambiar_hora_state <= current_cambiar_hora_state;
        next_crono_state <= current_crono_state;
        next_temp_state <= current_temp_state;
        
        -- Máquina de estados global
        case current_global_state is
            when RELOJ =>  
                 if modo = '1' then
                    next_global_state <= CRONO;
                 elsif chorag = '1' then 
                    next_global_state <= CAMBIAR_HORA_G;
                 else 
                    next_global_state <= RELOJ;
                 end if;
             
             when CRONO =>
                  if modo = '1' then 
                    next_global_state <= TEMP;
                  else 
                    next_global_state <= CRONO;
                  end if;
                  
                  -- Máquina de estados local de cronómetro
                  case current_crono_state is
                    when PAUSA =>
                        if pausar_reanudar = '1' then 
                            next_crono_state <= CRONOMETRANDO;
                            -- ce_crono <= '1'; -- Activa el cronómetro
                            -- reset_crono_n <= '1';
                        else 
                            next_crono_state <= PAUSA;
                        end if;
                    when CRONOMETRANDO => 
                        if pausar_reanudar = '1' then 
                            next_crono_state <= PAUSA;
                           -- ce_crono <= '0'; -- Deja de cronometrar
                        elsif reset_button = '1' then 
                            next_crono_state <= PAUSA;
                            -- ce_crono <= '0'; -- Deja de cronometrar
                            -- reset_crono_n <= '0'; -- Reset a 0
                        else 
                            next_crono_state <= CRONOMETRANDO;
                        end if;
                    when others => next_crono_state <= PAUSA;
                  end case;
                  
             when TEMP => 
                if modo = '1' then 
                    next_global_state <= RELOJ;
                else 
                    next_global_state <= TEMP;
                end if;
                
                -- Máquina de estados local de temporizador
                case current_temp_state is 
                    when CAMBIAR_SEG => 
                        if reset_button = '1' then
                            next_temp_state <= CAMBIAR_MIN;
                        else
                            next_temp_state <= CAMBIAR_SEG;
                        end if;
                    when CAMBIAR_MIN => 
                        if reset_button = '1' then 
                            next_temp_state <= CAMBIAR_H;
                        else 
                            next_temp_state <= CAMBIAR_MIN;
                        end if;
                    when CAMBIAR_H => 
                        if reset_button = '1' then 
                            next_temp_state <= PAUSA;
                          --  load_temp_n <= '0'; -- Carga el valor en el temporizador
                          --  ce_chora_temp <= '0'; -- Deshabilita chip para cambiar la hora
                        else 
                            next_temp_state <= CAMBIAR_H;
                        end if;
                    when PAUSA =>
                        if reset_button = '1' then
                            next_temp_state <= CAMBIAR_SEG;
                          --  ce_chora_temp <= '1'; -- Habilita chip para cambiar la hora
                        elsif pausar_reanudar = '1' then  
                            next_temp_state <= TEMPORIZANDO;
                          --  ce_temp <= '1'; -- Activa el temporizador
                          --  load_temp_n <= '1'; -- Desactiva la carga del temporizador (empieza a temporizar)
                        else 
                            next_temp_state <= PAUSA;
                        end if;       
                     when TEMPORIZANDO =>
                        if pausar_reanudar = '1' then
                            next_temp_state <= PAUSA;
                          --  ce_temp <= '0';
                        elsif reset_button = '1' then
                            next_temp_state <= CAMBIAR_SEG;
                        else 
                            next_temp_state <= TEMPORIZANDO;
                        end if;
                     when others => next_temp_state <= CAMBIAR_SEG;
                end case;
                
             when CAMBIAR_HORA_G =>
                if chorag = '1' then 
                    next_global_state <= RELOJ;
                else 
                    next_global_state <= CAMBIAR_HORA_G;
                end if;
                
                -- Máquina de estados local de cambiar hora
                case current_cambiar_hora_state is 
                    when CAMBIAR_SEG => 
                        if reset_button = '1' then
                            next_cambiar_hora_state <= CAMBIAR_MIN;
                        else
                            next_cambiar_hora_state <= CAMBIAR_SEG;
                        end if;
                    when CAMBIAR_MIN => 
                        if reset_button = '1' then 
                            next_cambiar_hora_state <= CAMBIAR_H;
                        else 
                            next_cambiar_hora_state <= CAMBIAR_MIN;
                        end if;
                    when CAMBIAR_H => 
                        if reset_button = '1' then 
                            next_cambiar_hora_state <= CONFIRMAR;
                        else 
                            next_cambiar_hora_state <= CAMBIAR_H;
                        end if;
                    when CONFIRMAR =>
                        if reset_button = '1' then
                            next_cambiar_hora_state <= CAMBIAR_SEG;
                        else 
                            next_cambiar_hora_state <= CONFIRMAR;
                        end if;
                    when others => next_cambiar_hora_state <= CAMBIAR_SEG;    
                end case;
            
            when others => next_global_state <= RELOJ;
        end case;
    end process;
    
output_decoder: process(clk)
    begin
        if rising_edge(clk) then 
            case current_global_state is
                when RELOJ => 
                    bcd_out <= bcd_out_reloj;
                when CRONO =>
                    bcd_out <= bcd_out_crono;
                when TEMP =>
                    bcd_out <= bcd_out_temp;
                when CAMBIAR_HORA_G => 
                    bcd_out <= bcd_out_reloj;  
                when others => bcd_out <= bcd_out_reloj;     
            end case;
        end if;
    end process;
end Behavioral;
