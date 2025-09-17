## MAX
About the functions

Finds the highest values in time series, numbers, arrays or combinations of
these.

The result series has the same resolution as the input time series.

**Syntax**

- MAX(T)
- MAX(d)
- MAX(D)
- MAX(t)
- MAX(t,t)
- MAX(T,t)
- MAX(t,T)
- MAX(t,d)
- MAX(d,d)
- MAX(T,T)

| # | Type | Description |
|---|---|---|
| 1 | t T d D | Time series. Array of time series. Number. Array of numbers. |
| 2 | t d T | Time series. Optional. Number. Optional. Array of time series. Optional. |

## Example
### Example 1: @MAX(t)

ResTs = @MAX(@t('Ts')

Returns the highest value of the time series for the requested period. See
similar example for the [@MIN(t) function](../functions/min.md).

### Example 2: @MAX(t,t)

ResTs = @MAX(@t('Ts1'),@t('Ts2'))

Returns the highest value of time series 1 and 2 for every time step.

See similar example for the [@MIN(t,t) function](../functions/min.md).

### Example 3: @MAX(d,d)

Res = @MAX(8,2.5)

Res = 8

Returns the largest of the two values.

### Example 4: @MAX(D)

Res = @MAX({1,5,8,2.5,11})

Res = 11

Returns the largest value of the array of numbers.

### Example 5: @MAX(T)

ResTs = @MAX({@t('Ts1'),@t('Ts2'),@t('Ts3')})

{@t('Ts1'),@t('Ts2'),@t('Ts3')} is an array of time series.

Returns the largest value of all the time series of the array for every time
step.
