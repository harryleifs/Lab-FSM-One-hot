library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_tb is
end entity;

architecture sim of traffic_light_tb is
    signal clk : std_logic := '0';
    signal sw  : std_logic_vector(0 downto 0) := "1";
    signal ledr : std_logic_vector(2 downto 0);

    constant clk_period : time := 20 ns;

    signal ena_R, ena_RY, ena_G, ena_Y : std_logic;
    signal clr_R, clr_RY, clr_G, clr_Y : std_logic;
    signal t_R, t_RY, t_G, t_Y         : std_logic;
    signal r_led, y_led, g_led         : std_logic;

begin
    timer_red: entity work.timer
        generic map (LIMIT => 10)
        port map (clk => clk, ena => ena_R, sync_clr => clr_R, max_tick => t_R);

    timer_red_yellow: entity work.timer
        generic map (LIMIT => 4)
        port map (clk => clk, ena => ena_RY, sync_clr => clr_RY, max_tick => t_RY);

    timer_green: entity work.timer
        generic map (LIMIT => 12)
        port map (clk => clk, ena => ena_G, sync_clr => clr_G, max_tick => t_G);

    timer_yellow: entity work.timer
        generic map (LIMIT => 4)
        port map (clk => clk, ena => ena_Y, sync_clr => clr_Y, max_tick => t_Y);

    controller: entity work.traffic_light_controller
        port map (
            clk => clk,
            rst => '0',
            stby => sw(0),
            timerRMaxTick => t_R,
            timerRYMaxTick => t_RY,
            timerGMaxTick => t_G,
            timerYMaxTick => t_Y,
            ena_timerR => ena_R,
            ena_timerRY => ena_RY,
            ena_timerG => ena_G,
            ena_timerY => ena_Y,
            ledR => r_led,
            ledY => y_led,
            ledG => g_led,
            sync_clr_timerR => clr_R,
            sync_clr_timerRY => clr_RY,
            sync_clr_timerG => clr_G,
            sync_clr_timerY => clr_Y
        );

    ledr(2) <= r_led;
    ledr(1) <= y_led;
    ledr(0) <= g_led;

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    stim_process : process
    begin
        sw(0) <= '1';
        wait for 100 ns;
        sw(0) <= '0';
        wait for 2000 ns;
        sw(0) <= '1';
        wait for 200 ns;
        sw(0) <= '0';
        wait;
    end process;

end architecture;