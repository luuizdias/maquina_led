library ieee ; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

entity maquina is
	port (
		botao : in std_logic_vector (1 downto 0);
		clk : in std_logic;
		led : out std_logic_vector (1 downto 0)
		);
end entity maquina;









architecture simples of maquina is 
	type estados is (state1 , state2 , state3, state4);
	
	signal s_estado : estados  := state1;
	signal s_count : std_logic_vector(28 downto 0);
	signal s_led: std_logic_vector(1 downto 0);
	
begin
	process( botao(0), botao(1) , clk )
	begin	

		if ( clk 'event and clk = '1') then 
			case ( s_estado ) is 
				when state1 =>
					s_led(0) <= '1';
					s_led(1) <= '0';
					if(botao(0) = '0') then
						s_estado <= state2;
						s_count <= b"00000000000000000000000000000";
						s_led <= b"01";
						-- s_count  <= 0
					end if;
				when state2 =>
					if(s_count(24) = '1') then -- o quanto o contador tem que ir depende da frequencia do fpga. Lembro que calculamos isso em algum momento. 
						s_led(0) <= not s_led(0);
						s_led(1) <= not s_led(1);
					end if;
					s_count <= s_count + 1;
					if(botao(1) = '0') then
						s_count <= b"00000000000000000000000000000";
						s_estado <= state3;
						s_led <= b"00";
					end if;
					-- led(0) = 1 >1 seg> led(0) = 0
					-- led(1) = 0 >1 seg> led(1) = 1						
				when state3 =>
					if(s_count(24) = '1') then
						s_led(0) <= not s_led(0);
						s_led(1) <= not s_led(1);
					end if;
					s_count <= s_count + 1;
					if(botao(0) = '0') then
						s_count <= b"00000000000000000000000000000";
						s_estado <= state4;
					end if;
					-- led(0) = 1 >1 seg> led(0) = 0
					-- led(1) = 1 >1 seg> led(1) = 0
				when state4 =>
					s_led(0) <= '0'; 
					s_led(1) <= '1';
					if(s_count(28) = '1') then
						s_estado <= state1;
						s_count <= b"00000000000000000000000000000";
					end if;
					s_count <= s_count + 1;
				when others =>
					s_led(0) <= '1';
					s_led(1) <= '1';
					s_estado <= state1;
			end case ;
		end if ; 
	end process;
led <= s_led;	
end simples ;


