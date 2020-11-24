-- Vhdl Test Bench template for design  :  sistema
-- Simulation tool : ModelSim-Altera (VHDL)
-- Author: Diego MeCha (2020-01)

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY test_sistema IS
END test_sistema;

ARCHITECTURE sistema_arch OF test_sistema IS
-- constants                                                 
-- signals                                                   
SIGNAL bus_data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL clk : STD_LOGIC :='0';
SIGNAL int : STD_LOGIC :='0';
SIGNAL rst_n : STD_LOGIC :='1';
constant clk_period : time := 1 us;


COMPONENT sistema
	PORT (
	clk : IN STD_ULOGIC;
	rst_n : IN STD_LOGIC;
	int : IN STD_LOGIC;
	bus_data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

BEGIN

-- list connections between master ports and signals
	uut1 : sistema
	PORT MAP (
		bus_data_out => bus_data_out,
		clk => clk,
		int => int,
		rst_n => rst_n
	);

-- clock generation (depends on clk_period constant)
   clk_process :PROCESS
   BEGIN
		clk <= '0';
		WAIT FOR clk_period/2;
		clk <= '1';
		WAIT FOR clk_period/2;
   END PROCESS;

-- Testbench
	always : PROCESS                                              
	BEGIN                                                         
		-- code executes for every event on sensitivity list  
		int		<= '0';	
		rst_n	<= '0', '1' after 5 us;
		WAIT;                                                        
	END PROCESS always;                                         

END sistema_arch;
