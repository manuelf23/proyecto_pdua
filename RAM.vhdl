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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
	Port ( cs, rw, clk	   : in std_logic;
		   rst_n  : in 	std_logic;
           dir 	   : in std_logic_vector(6 downto 0);
		   data_in 	: in std_logic_vector(7 downto 0);
		   solicita_dato : out std_logic:='0';
		   data_out 	: out std_logic_vector(7 downto 0));
end RAM;

architecture Behavioral of RAM is

type memoria is array (127 downto 0) of std_logic_vector(7 downto 0);
signal mem: memoria;

type memoria_cache is array (31 downto 0) of std_logic_vector(7 downto 0);
signal mem_cache: memoria_cache;

type change_val is array (31 downto 0) of std_logic;
signal c: change_val;

type valid_block is array (7 downto 0) of std_logic;
signal v: valid_block;

type tag_block is array (7 downto 0) of std_logic_vector(1 downto 0);
signal tag: tag_block;


signal dir_aux: std_logic_vector(6 downto 0);


signal ram_ready: std_logic:='0';
signal cache_ready: std_logic:='0';

signal contador: integer:=1;
signal contador_2: integer:=0;

signal copy_index_ram: integer:=0;
signal copy_index_cache: integer:=0;

signal save_index_ram: integer:=0;
signal valid_index: integer:=0;

signal solicita_dato_interna: std_logic:='0';
signal actualizar_cache: std_logic:='0';
signal nuevoD_cache: std_logic:='0';

signal flag: integer:=0;
signal ram_clk : integer:=1;
signal vall : integer:=0;
signal valc : integer:=0;
signal pos_v : integer:=0;

constant cost: unsigned(1 downto 0):= to_unsigned(0,2);

begin
	valid_index <= to_integer(unsigned(dir(4 downto 2)));
	--copy_index_cache <= to_integer(unsigned(dir(4 downto 2) sll 2));

	copy_index_cache <= 0 when dir(4 downto 2) = "000" else
						4 when dir(4 downto 2) = "001" else
						8 when dir(4 downto 2) = "010" else
						12 when dir(4 downto 2) = "011" else
						16 when dir(4 downto 2) = "100" else
						20 when dir(4 downto 2) = "101" else
						24 when dir(4 downto 2) = "110" else
						28 when dir(4 downto 2) = "111";



	
	copy_index_ram <= to_integer(unsigned((dir srl 2)sll 2 ));
	save_index_ram <= to_integer(unsigned( tag(valid_index)(1 downto 0))   & unsigned(dir(4 downto 2)) & cost);
	process(cs,rw,dir,data_in,mem, ram_clk, mem_cache)
	begin
		if rst_n='0' then
			for i in 0 to 127 loop
				mem(i) <= std_logic_vector(to_unsigned(i+1, 8));
			end loop;
			for i in 0 to 31 loop
					mem_cache(i) <= "00000000";
					c(i) <= '0';
			end loop;
			for i in 0 to 7 loop
					tag(i) <= "00";
					v(i) <= '0';
			end loop;
		elsif cs = '1' then
			if rw = '0' then  -- Read
				pos_v <= to_integer(unsigned(dir(4 downto 2)));	
				if v(pos_v)='1' and solicita_dato_interna = '1' then
					if tag(to_integer(unsigned(dir(4 downto 2)))) = dir(6 downto 5) then
						data_out <= mem_cache(to_integer(unsigned(dir(4 downto 0))));
						flag <= 1;
						solicita_dato <= '0';
						solicita_dato_interna <= '0';
					else
						actualizar_cache <= '1';
					end if;	
				elsif ram_clk = 1 then

					
					nuevoD_cache <= '1';
					vall <= to_integer(unsigned(dir)) mod 128;
					dir_aux <= dir;
					if actualizar_cache = '1'then
						--valid_index <= to_integer(unsigned(dir(4 downto 2))); 
						--copy_index_ram <= to_integer(unsigned(dir sll 2 ));
						--copy_index_cache <= to_integer(unsigned(dir(4 downto 2) sll 2));
						--save_index_ram <= to_integer(unsigned( tag(valid_index)(1 downto 0))   & unsigned(dir(4 downto 2)) & cost    );
						for i in 0 to 3 loop
							if c(i + copy_index_cache) = '1' then
								mem(i + save_index_ram) <= mem_cache(i + copy_index_cache);
								c(i + copy_index_cache) <= '0';
							end if;
						end loop;
						for i in 0 to 3 loop
							mem_cache(i + valid_index) <= mem(i + copy_index_ram);
						end loop;
						tag(valid_index) <= dir(6 downto 5);
						actualizar_cache <= '0';
					elsif nuevoD_cache = '1' then
						contador_2 <= contador_2 + 1;
						

						mem_cache(0 + copy_index_cache) <= mem(0 + copy_index_ram);
						mem_cache(1 + copy_index_cache) <= mem(1 + copy_index_ram);
						mem_cache(2 + copy_index_cache) <= mem(2 + copy_index_ram);
						mem_cache(3 + copy_index_cache) <= mem(3 + copy_index_ram);

						--for i in 0 to 3 loop
						--	mem_cache(i + copy_index_cache) <= mem(i + copy_index_ram);
						--end loop;
						tag(valid_index) <= dir(6 downto 5);
						v(valid_index) <= '1';
						nuevoD_cache <= '0';

					end if;
					flag <= 2;
					data_out <= mem(vall);
					solicita_dato <= '0';
					solicita_dato_interna <= '0';			
					



					
					
				else
					solicita_dato <= '1'; 
					solicita_dato_interna <= '1';

					
				end if;
			else 		
				vall <= to_integer(unsigned(dir)) mod 128;			-- Write
				mem(vall) <= Data_in;
			end if;
		else 
			data_out <= (others => 'Z');
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
				if (contador = 7) then
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
