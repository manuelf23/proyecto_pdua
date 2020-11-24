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
	    when "00011" => data <= "00011000";  -- MOV ACC,CTE 
       when "00100" => data <= "00000100";  -- CTE (0x04)
	    when "00101" => data <= "10000000";  -- COMP2 ACC
	    when "00110" => data <= "00011000";  -- MOV ACC,CTE
	    when "00111" => data <= "10100101";  -- CTE (0xA5)
	    when "01000" => data <= "10000000";  -- COMP2 ACC
       when "01001" => data <= "01010000";  -- FIN: JUMP FIN 	 
       when "01010" => data <= "00001001";  -- FIN	
       when "01011" => data <= "00000000";  -- 
       when "01100" => data <= "00000000";  -- 
       when "01101" => data <= "00000000";  -- 
	    when "01110" => data <= "00000000";  -- 
       when "01111" => data <= "00000000";  -- 
		 
	    when "10000" => data <= "00000000";  -- 
	    when "10001" => data <= "00000000";  --  
	    when "10010" => data <= "00000000";  -- 
	    when "10011" => data <= "00000000";  -- 
		 when "10100" => data <= "00000000";  -- 
	    when "10101" => data <= "00000000";  -- 
	    when "10110" => data <= "00000000";  -- 
	    when "10111" => data <= "00000000";  -- 
	    when "11000" => data <= "00000000";  -- 
		 when "11001" => data <= "00000000";  -- 	 
		 when "11010" => data <= "00000000";  -- 
		 when "11011" => data <= "00000000";  -- 
		 when "11100" => data <= "00000000";  -- 
		 when "11101" => data <= "00000000";  -- 
	    when "11110" => data <= "00000000";  -- 
		 when "11111" => data <= "00000000";  --	 
		 
		 when others => data <= (others => 'X'); 
       end case;
else data <= (others => 'Z');
end if;  
end process;
end;