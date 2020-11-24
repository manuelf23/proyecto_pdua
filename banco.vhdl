-- ***********************************************
-- **  PROYECTO PDUA                            **
-- **  Modulo: 	BANCO                         **
-- **  Creacion:	Julio 07								**
-- **  Revisión:	Julio 09								**
-- **  Por:	   	MGH-CMUA-UNIANDES 				**
-- ***********************************************
-- Descripcion:
-- Banco de registros
--            reset_n    HR (Habilitador)  
--                  _|___|_
--          clk -->|  PC   |
--						 |  SP   |
--						 |  DPTR |
--                 |  A    |--> BUSB
--         BUSC -->|  AVI   |--> BUSA
--						 |  CTE1 |
--						 |  ACC  |
--                 |_______|   
--                   |   |
--                   SC  SB
--  Selector de destino  Selector de Origen 
--          reg <--BUSC  BUSB <-- reg
-- ***********************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity banco is
    Port ( CLK 	: in 	std_logic;
    		  RESET_n: in 	std_logic;
           HR		: in 	std_logic;
           SC,SB 	: in 	std_logic_vector(2 downto 0);
           BUSC 	: in 	std_logic_vector(7 downto 0);
           BUSA,BUSB : out 	std_logic_vector(7 downto 0)
		 );
end banco;

architecture Behavioral of banco is

SIGNAL PC,SP,DPTR,A,AVI,TEMP,CTE1,ACC : std_logic_vector(7 downto 0);

begin
process (clk)
begin
if (clk'event and clk = '0') then
    if RESET_n = '0' then
       PC 	<= "00000000";
       SP 	<= "10000000"; 	-- Primera posicion de RAM
       DPTR <= "00000000";
       A 	<= "00000000";
       AVI 	<= "00000010"; 	-- Apuntador al Vector de Interrupcion
       TEMP <= "00000000";
	    CTE1 <= "11111111";  	-- Constante Menos 1 (Compl. a 2)
	    ACC 	<= "00000000";
    elsif HR = '1' then
    case SC is
       when "000" => PC 	<= BUSC;
       when "001" => SP 	<= BUSC;
       when "010" => DPTR  <= BUSC;
       when "011" => A 		<= BUSC;
	 -- when "100" => B 		<= BUSC; -- B es constante (vector de Int)
       when "101" => TEMP 	<= BUSC;
    -- when "110" => CTE 1				-- Es constante (menos 1)
       when "111" => ACC 	<= BUSC;
	    when others => CTE1 <= "11111111";
	end case;
   end if;
 end if;
 end process;

 process(SB,PC,SP,DPTR,A,AVI,TEMP,ACC,CTE1)
 begin
    case SB is
       when "000" => BUSB <= PC;
       when "001" => BUSB <= SP;
       when "010" => BUSB <= DPTR;
       when "011" => BUSB <= A;
	    when "100" => BUSB <= AVI;
       when "101" => BUSB <= TEMP;
       when "110" => BUSB <= CTE1;
       when "111" => BUSB <= ACC;
	    when others=> BUSB <= ACC;
	end case;
end process;

BUSA <= ACC;

end Behavioral;
