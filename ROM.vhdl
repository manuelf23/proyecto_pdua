-- ***********************************************
-- **  PROYECTO PDUA                            **
-- **  Modulo: 	ROM                           **
-- **  Creacion:	Julio 07								**
-- **  Revisi�:	Marzo 08								**
-- **  Por:		   MGH-CMUA-UNIANDES 				**
-- ***********************************************
-- Descripcion:
-- ROM (Solo lectura)
--                      cs  
--                  _____|_
--           rd -->|       |
--          dir -->|       |--> data
--                 |_______|   
--        
-- ***********************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
    Port ( cs,rd	: in std_logic;
           dir 	: in std_logic_vector(4 downto 0);
           data 	: out std_logic_vector(7 downto 0));
end ROM;

architecture Behavioral of ROM is

begin
process(cs,rd,dir)
begin
if cs = '1' and rd = '0' then
       case dir is
	    when "00000" => data <= "01010000";  -- JMP MAIN
	    when "00001" => data <= "00000011";  -- MAIN 
	    when "00010" => data <= "00001000";  -- RAI Vector de Interrupcion
	    when "00011" => data <= "00011000";  -- (INIT_DPTR): MOV ACC,CTE 
       when "00100" => data <= "10000000";  -- CTE (0x80) // 128
	    when "00101" => data <= "00101000";  -- MOV DPTR, ACC // 
	    when "00110" => data <= "00011000";  -- (INIT_COMP_DPTR): MOV ACC,CTE 
	    when "00111" => data <= "01111001";  -- CTE (0x78) // 121
	    when "01000" => data <= "10000000";  -- ADD ACC, DPTR
       when "01001" => data <= "01011000";  -- JZ DIR 	 
       when "01010" => data <= "00000011";  -- DIR= INIT_DPTR	
       when "01011" => data <= "00100000";  -- MOV ACC, [DPTR]
       when "01100" => data <= "00010000";  -- MOV A, ACC
       when "01101" => data <= "10001000";  -- AUM DPTR // DPTR = DPTR + 1 
	    when "01110" => data <= "00100000";  -- MOV ACC, [DPTR]
       when "01111" => data <= "10010000";  -- ACC = complemento A2(ACC)
		 
	    when "10000" => data <= "01001000";  -- ADD ACC,A
	    when "10001" => data <= "01101000";  -- JC DIR
	    when "10010" => data <= "00010101";  -- DIR=SWAP
	    when "10011" => data <= "01010000";  -- JUM DIR 
		when "10100" => data <= "00000110";  -- DIR= INIT_COMP_DPTR
	    when "10101" => data <= "00100000";  -- (SWAP): MOV ACC, [DPTR]  
	    when "10110" => data <= "10011000";  -- MOV [DPTR], A 
	    when "10111" => data <= "00010000";  -- MOV A, ACC
	    when "11000" => data <= "00011000";  -- MOV ACC,CTE
		when "11001" => data <= "11111111";  -- CTE (0xFF) // -1 en Comp A2	 
		when "11010" => data <= "10000000";  -- ADD ACC, DPTR
		when "11011" => data <= "00101000";  -- MOV DPTR,ACC
		when "11100" => data <= "10011000";  -- MOV [DPTR], A
		when "11101" => data <= "10001000";  -- AUM DPTR // DPTR = DPTR + 1
	    when "11110" => data <= "01010000";  -- JUM DIR
		when "11111" => data <= "00000110";  --	DIR= INIT_COMP_DPTR
		 
		 when others => data <= (others => 'X'); 
       end case;
else data <= (others => 'Z');
end if;  
end process;
end;