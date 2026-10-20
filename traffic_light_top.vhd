library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_top is
    port (
        CLOCK_50 : in std_logic;
        SW       : in std_logic_vector(0 downto 0);
        LEDR     : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of traffic_light_top is

    component timer is
        generic (
            LIMIT : integer := 50000000
        );
        port (
            clk      : in std_logic;
            ena      : in std_logic;
            sync_clr : in std_logic;
            max_tick : out std_logic
        );
    end component;

    component traffic_light_controller is
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
    end component;

    signal ena_R, ena_RY, ena_G, ena_Y : std_logic;
    signal clr_R, clr_RY, clr_G, clr_Y : std_logic;
    signal t_R, t_RY, t_G, t_Y         : std_logic;
    signal r_led, y_led, g_led         : std_logic;

begin

    timer_red: timer
        generic map (LIMIT => 100000000)
        port map (clk => CLOCK_50, ena => ena_R, sync_clr => clr_R, max_tick => t_R);

    timer_red_yellow: timer
        generic map (LIMIT => 25000000)
        port map (clk => CLOCK_50, ena => ena_RY, sync_clr => clr_RY, max_tick => t_RY);

    timer_green: timer
        generic map (LIMIT => 150000000)
        port map (clk => CLOCK_50, ena => ena_G, sync_clr => clr_G, max_tick => t_G);

    timer_yellow: timer
        generic map (LIMIT => 25000000)
        port map (clk => CLOCK_50, ena => ena_Y, sync_clr => clr_Y, max_tick => t_Y);

    controller: traffic_light_controller
        port map (
            clk => CLOCK_50,
            rst => '0',
            stby => SW(0),
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

    LEDR(2) <= r_led;
    LEDR(1) <= y_led;
    LEDR(0) <= g_led;

end architecture;