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
		when "00000" => data <= "00011000";  -- 1. (INIT_DPTR): MOV ACC,CTE
		when "00001" => data <= "10000000";  -- 2. CTE (0x80) // 128 
		when "00010" => data <= "00101000";  -- 3. MOV DPTR, ACC //
		when "00011" => data <= "00110000";  -- 4. MOV [DPTR],ACC
		when "00100" => data <= "00011000";   -- 5. (INIT_DPTR): MOV ACC,CTE
		when "00101" => data <= "10000001";  -- 6. CTE (0x80) // 129 
		when "00110" => data <= "00101000";  -- 3. MOV DPTR, ACC //
		when "00111" => data <= "00110000";  -- 4. MOV [DPTR],ACC
		when "01000" => data <= "00011000";   -- 5. (INIT_DPTR): MOV ACC,CTE
		when "01001" => data <= "10000010";  -- 6. CTE (0x80) // 130 
		when "01010" => data <= "00101000";  -- 3. MOV DPTR, ACC //
		when "01011" => data <= "00110000";  -- 4. MOV [DPTR],ACC
		when "01100" => data <= "00011000";  -- 1. (INIT_DPTR): MOV ACC,CTE
		when "01101" => data <= "10100000";  -- 2. CTE (0x80) // 160
		when "01110" => data <= "00101000";  -- 3. MOV DPTR, ACC // 
		when "01111" => data <= "00110000";  -- 4. MOV [DPTR],ACC
		when "10000" => data <= "01010000";  -- 7. JUM DIR 
		when "10001" => data <= "00010000";  -- 8. DIR= INIT_DPTR 00 001 000
	    	
		 when others => data <= (others => 'X'); 
       end case;
else data <= (others => 'Z');
end if;  
end process;
end;