library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    generic (
        LIMIT : integer := 50000000
    );
    port (
        clk      : in std_logic;
        ena      : in std_logic;
        sync_clr : in std_logic;
        max_tick : out std_logic
    );
end entity;

architecture rtl of timer is
    signal count : integer range 0 to LIMIT := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if sync_clr = '1' then
                count <= 0;
                max_tick <= '0';
            elsif ena = '1' then
                if count = LIMIT - 1 then
                    count <= 0;
                    max_tick <= '1';
                else
                    count <= count + 1;
                    max_tick <= '0';
                end if;
            else
                max_tick <= '0';
            end if;
        end if;
    end process;
end architecture;