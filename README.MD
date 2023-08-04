# UARTUS

## Todo

-   [ ] check TX
-   [ ] check TX parity bits
-   [ ] finish documentation

## Mini Documentation

### Setting the UART Baud-rate

The Baud-rate is set via supplying the quotient of the frequency of `clk` and the Baud-rate in Bd.
Example: for a 10MHz clock with 115200 Bd: `cfg_clkSpeed_over_bdRate`$=\frac{10000000}{115200}=86.80\overline{5}\approx 87$.
As should be obvious, there are limits on how far the speed of the UART interface can be pushed this way, but the user is assumed to be smart and therefore given all responsibility (we, after all, are not Quartus😉).

### Parity bit

The parity bit can be set for the TX (and _only_ the TX) by supplying the correct value to `cfg_parity_setting`:
|value|parity mode|
|---|---|
|00|parity off|
|10|parity odd|
|01|parity even|
|11|parity off|

### RX

The `rx_finished_out` signal stays high for at least 92 clk cycles, when using a 10MHz clock with 115200 Bd.
