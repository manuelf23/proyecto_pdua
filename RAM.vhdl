-- ***********************************************
-- **  PROYECTO PDUA                            **
-- **  Modulo: 	RAM                           **
-- **  Creacion:	Julio 07								**
-- **  Revisi�n:	Marzo 08								**
-- **  Por :		MGH-DIMENDEZ-CMUA-UNIANDES 	**
-- ***********************************************
-- Descripcion:
-- RAM (Buses de datos independientes in-out)
--                       cs  
--                   _____|_
--            rw -->|       |
-- dir(direccion)-->|       |--> data_out
--       data_in -->|_______|   
--        
-- ***********************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM is
	Port ( cs, rw, clk	   : in std_logic;
		   rst_n  : in 	std_logic;
           dir 	   : in std_logic_vector(2 downto 0);
		   data_in 	: in std_logic_vector(7 downto 0);
		   solicita_dato : out std_logic:='0';
		   data_out 	: out std_logic_vector(7 downto 0));
end RAM;

architecture Behavioral of RAM is

type memoria is array (7 downto 0) of std_logic_vector(7 downto 0);
signal mem: memoria;

signal contador: integer:=1;
signal solicita_dato_interna: std_logic:='0';
signal ram_clk : integer:=1;

begin
process(cs,rw,dir,data_in,mem, ram_clk)
begin
if rst_n='0' then
	mem(7)<= "00001000";
	mem(0)<= "00000001";
	mem(1)<= "00000010";
	mem(4)<= "00000011";
	mem(3)<= "00000100";
	mem(2)<= "00000101";
	mem(5)<= "00000110";
	mem(6)<= "00000111";
elsif cs = '1' then
   if rw = '0' then  -- Read
		
		--if solicita_dato = 1 then
			--solicita_dato <= 0;
		--else
			--solicita_dato <= 1;
		--end if;
				
		if ram_clk = 1 then
			case dir is
				when "000" => data_out <= mem(0);
				when "001" => data_out <= mem(1);
				when "010" => data_out <= mem(2);
				when "011" => data_out <= mem(3);
				when "100" => data_out <= mem(4);
				when "101" => data_out <= mem(5);
				when "110" => data_out <= mem(6);
				when "111" => data_out <= mem(7);
				when others => data_out <= (others => 'X'); 
			end case;
			--ram_clk<=0;
			solicita_dato <= '0';
			solicita_dato_interna <= '0';
			--data_ready <= '1';
		else
			--data_ready <= '0';
			solicita_dato <= '1'; 
			solicita_dato_interna <= '1';
	   end if;
	   
	   
   else 					-- Write
       case dir is
	    when "000" => mem(0) <= Data_in;
	    when "001" => mem(1) <= Data_in;
	    when "010" => mem(2) <= Data_in;
	    when "011" => mem(3) <= Data_in;
	    when "100" => mem(4) <= Data_in;
	    when "101" => mem(5) <= Data_in;
	    when "110" => mem(6) <= Data_in;
	    when "111" => mem(7) <= Data_in;
	    when others => mem(7) <= Data_in;
       end case;
    end if;
else 
	data_out <= (others => 'Z');
	--data_ready <= '0';
end if;  
end process;

process(clk,rst_n, cs)
begin
if(rst_n/='1') then
	contador<=1;
	ram_clk<=0;
	
	--data_ready <= '0';
elsif(clk'event and clk='1')then
	if cs = '0' then
		contador <= 1;
	end if;
	if  solicita_dato_interna = '1' and cs='1' then
		contador <=contador+1;
		if (contador = 8) then
			ram_clk<=1;
			contador <= 1;
			
		end if;
	else
		
		ram_clk<=0;
	end if;

	--data_ready <= '0';
end if;
end process;

end Behavioral;
