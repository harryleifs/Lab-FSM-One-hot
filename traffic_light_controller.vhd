library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_controller is
    port (
        clk              : in std_logic;
        rst              : in std_logic;
        stby             : in std_logic;
        timerRMaxTick    : in std_logic;
        timerRYMaxTick   : in std_logic;
        timerGMaxTick    : in std_logic;
        timerYMaxTick    : in std_logic;
        ena_timerR       : out std_logic;
        ena_timerRY      : out std_logic;
        ena_timerG       : out std_logic;
        ena_timerY       : out std_logic;
        ledR             : out std_logic;
        ledY             : out std_logic;
        ledG             : out std_logic;
        sync_clr_timerR  : out std_logic;
        sync_clr_timerRY : out std_logic;
        sync_clr_timerG  : out std_logic;
        sync_clr_timerY  : out std_logic
    );
end entity;

architecture rtl of traffic_light_controller is
    type state_type is (YY_state, R_state, RY_state, G_state, Y_state);
    signal current_state, next_state : state_type := YY_state;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= YY_state;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, stby, timerRMaxTick, timerRYMaxTick, timerGMaxTick, timerYMaxTick)
    begin
        next_state <= current_state;
        case current_state is
            when YY_state =>
                if stby = '0' then
                    next_state <= R_state;
                end if;
            when R_state =>
                if stby = '1' then
                    next_state <= YY_state;
                elsif timerRMaxTick = '1' then
                    next_state <= RY_state;
                end if;
            when RY_state =>
                if timerRYMaxTick = '1' then
                    next_state <= G_state;
                end if;
            when G_state =>
                if timerGMaxTick = '1' then
                    next_state <= Y_state;
                end if;
            when Y_state =>
                if timerYMaxTick = '1' then
                    next_state <= R_state;
                end if;
        end case;
    end process;

    process(current_state)
    begin
        ena_timerR <= '0';
        ena_timerRY <= '0';
        ena_timerG <= '0';
        ena_timerY <= '0';
        sync_clr_timerR <= '0';
        sync_clr_timerRY <= '0';
        sync_clr_timerG <= '0';
        sync_clr_timerY <= '0';
        ledR <= '0';
        ledY <= '0';
        ledG <= '0';

        case current_state is
            when YY_state =>
                ledY <= '1';
                sync_clr_timerR <= '1';
                sync_clr_timerRY <= '1';
                sync_clr_timerG <= '1';
                sync_clr_timerY <= '1';
            when R_state =>
                ledR <= '1';
                ena_timerR <= '1';
                sync_clr_timerRY <= '1';
            when RY_state =>
                ledR <= '1';
                ledY <= '1';
                ena_timerRY <= '1';
                sync_clr_timerG <= '1';
            when G_state =>
                ledG <= '1';
                ena_timerG <= '1';
                sync_clr_timerRY <= '1';
            when Y_state =>
                ledY <= '1';
                ena_timerY <= '1';
                sync_clr_timerG <= '1';
        end case;
    end process;
end architecture;