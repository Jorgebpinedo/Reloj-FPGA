# Reloj digital

## Objetivos
Diseñar un reloj digital con funcionalidades de cronómetro y temporizador usando VHDL.

## Integrantes 

- Jorge Bengoa Pinedo: <j.bpinedo@alumnos.upm.es>
- Jorge Bachiller Cordero: <jorge.bachiller.cordero@alumnos.upm.es>
- Luis Miguel Muro García: <l.muro@alumnos.upm.es>

## Funcionalidades 
El reloj tendrá las siguientes funcionalidades:

- Marcar la hora en horas, minutos y segundos:
  - Mostrar la hora a través de displays de 7 segmentos.
  - Formatos 12 horas y 24 horas.
  - Cambiar la hora manualmente.
  - Regular el nivel de brillo según sea am o pm.
- Cronómetro:
  - Pausar.
  - Reanudar.
  - Reseter.
- Temporizador:
  - Cargar tiempo.
  - Pausar.
  - Reanudar.
  - Resetear.

 ## Convenciones de escritura de código
 - Todo el código en español.
 - Paquetes y entidades: la 1ª letra de cada palabra en mayúsculas: RelojDigital.
 - Funciones y procedimientos: 1ª letra de cada palabra en mayúsculas salvo la 1ª palabra que irá en minúsculas: relojDigital.
 - Variables y señales: todo en minúsculas, separando las palabras por guiones bajos: reloj_digital.
 - Genéricos: todo en mayúsculas y separado por guiones bajos: RELOJ_DIGITAL
 - Señales internas de las arquitecturas: igual que las variables y señales, finalizando en _s: reloj_digital_s
