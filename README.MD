# UARTUS

## Todo

-   [x] Check RX functionality
-   [x] Check TX
-   [x] Check TX parity bits
-   [x] Check half duplex
-   [x] Check full duplex
-   [ ] Check theory of high baud-rates
-   [ ] Why is the time to transmit 1 data package steadily decreasing?
-   [ ] Finish documentation

## Mini Documentation

### Setting the UART Baud-rate

The Baud-rate is set via supplying the quotient of the frequency of `clk` and the Baud-rate in Bd.
Example: for a 10MHz clock with 115200 Bd: `cfg_clkSpeed_over_bdRate`$=\frac{10000000}{115200}=86.80\overline{5}\approx 87$[^1].
As should be obvious, there are limits on how far the speed of the UART interface can be pushed this way, but the user is assumed to be smart and therefore given all responsibility (we, after all, are not Quartus😉).
[^1]: If you incorporate this calculation into your VHDL code (like we did in the test-bench) your signal will actually have the 86 as its value.

### TX

After settings `tx_start=1` time for each transmission varies a bit. This is not calculated, but was observed when using the test-bench with GHDL. Some transmissions only take about 960 clk cycles, but we only stop observing fails for sending multiple TX packages quickly after one another, when we wait 1135 clk cycles in total. This number is purely heuristic and was obtained after looking at the waveform of the following test-bench:

```
for i in 0 to 50 loop
    s_tx_data_word_in <= x"AA";
    s_tx_start        <= '1';
    wait for clk_period * 10;
    s_tx_start <= '0';
    wait for clk_period * 1100;
end loop;
```

You can find screenshots of the corresponding waveforms of some of the conducted tests in `rtl/tb/waveforms`. The periods given in each of the screenshots correspond to the last line of the loop above.

#### Parity bit

The parity bit can be set for the TX (and _only_ the TX) by supplying the correct value to `cfg_parity_setting`:
|value|parity mode|
|---|---|
|00|parity off|
|10|parity odd|
|01|parity even|
|11|parity off|

### RX

The `rx_finished_out` signal stays high for at least 44 clk cycles, when using a 10MHz clock with 115200 Bd (heuristic, just measured from the GHDL waveform).
