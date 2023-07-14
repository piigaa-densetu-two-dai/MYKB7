library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SLOT is
	port(
		INPUT_CPU_A15_A14 : in std_logic_vector(1 downto 0);
		INPUT_CPU_A7_A0 : in std_logic_vector(7 downto 0);
		INPUT_CPU_DATA : in std_logic_vector(7 downto 0);
		INPUT_CPU_IORQ : in std_logic;
		INPUT_CPU_MREQ : in std_logic;
		INPUT_CPU_RFSH : in std_logic;
		INPUT_CPU_WR : in std_logic;
		INPUT_RESET : in std_logic;
		OUTPUT_SLTSL2 : out std_logic;
		OUTPUT_SLTSL3 : out std_logic;
		UNUSED : out std_logic_vector(8 downto 0)
	);
	attribute pin_assign : string;
	attribute pin_assign of INPUT_CPU_A15_A14 : signal is "36,35";
	attribute pin_assign of INPUT_CPU_A7_A0 : signal is "34,33,29,28,27,26,25,24";
	attribute pin_assign of INPUT_CPU_DATA : signal is "22,20,19,18,14,13,12,11";
	attribute pin_assign of INPUT_CPU_IORQ : signal is "39";
	attribute pin_assign of INPUT_CPU_MREQ : signal is "40";
	attribute pin_assign of INPUT_CPU_RFSH : signal is "42";
	attribute pin_assign of INPUT_CPU_WR : signal is "38";
	attribute pin_assign of INPUT_RESET : signal is "37";
	attribute pin_assign of OUTPUT_SLTSL2 : signal is "43";
	attribute pin_assign of OUTPUT_SLTSL3 : signal is "44";
	attribute pin_assign of UNUSED : signal is "9,8,7,6,5,4,3,2,1";
end SLOT;

architecture RTL of SLOT is
	signal REG_A8 : std_logic_vector(7 downto 0) := "00000000";
	signal CLK_A8 : std_logic := '0';
begin
	process(INPUT_CPU_A15_A14, INPUT_CPU_A7_A0, INPUT_CPU_DATA, INPUT_CPU_IORQ, INPUT_CPU_WR, INPUT_CPU_MREQ, INPUT_CPU_RFSH, INPUT_RESET, REG_A8)
	begin
		if INPUT_CPU_IORQ='0' and INPUT_CPU_WR='0' and INPUT_CPU_A7_A0="10101000" then -- IOWR 0xa8
			CLK_A8 <= '1';
		else
			CLK_A8 <= '0';
		end if;

		if    INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="00" and REG_A8="------10" then -- 0000-3ffff
			OUTPUT_SLTSL2 <= '0';
		elsif INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="01" and REG_A8="----10--" then -- 4000-7ffff
			OUTPUT_SLTSL2 <= '0';
		elsif INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="10" and REG_A8="--10----" then -- 8000-bffff
			OUTPUT_SLTSL2 <= '0';
		elsif INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="11" and REG_A8="10------" then -- c000-fffff
			OUTPUT_SLTSL2 <= '0';
		else
			OUTPUT_SLTSL2 <= '1';
		end if;

		if    INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="00" and REG_A8="------11" then -- 0000-3ffff
			OUTPUT_SLTSL3 <= '0';
		elsif INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="01" and REG_A8="----11--" then -- 4000-7ffff
			OUTPUT_SLTSL3 <= '0';
		elsif INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="10" and REG_A8="--11----" then -- 8000-bffff
			OUTPUT_SLTSL3 <= '0';
		elsif INPUT_CPU_MREQ='0' and INPUT_CPU_RFSH='1' and INPUT_CPU_A15_A14="11" and REG_A8="11------" then -- c000-fffff
			OUTPUT_SLTSL3 <= '0';
		else
			OUTPUT_SLTSL3 <= '1';
		end if;

		if INPUT_RESET='0' then
			REG_A8 <= "00000000";
		elsif CLK_A8'event and CLK_A8='1' then
			REG_A8 <= INPUT_CPU_DATA;
		end if;
	end process;

	UNUSED <= "000000000";
end RTL;
