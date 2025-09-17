# GetTsAsOfTime
## About the function
Used to find values and status for a time series at a given historical time.

Returns a time series or an array of time series, depending on the value of
parameter number two.

Note! If the historical time is earlier than the first write to the series (in
the relevant period) then the function returns NaN values.

**S**yntax

- GetTsAsOfTime(t,s[,s])
- GetTsAsOfTime(t,d[,s])
- GetTsAsOfTime(t,S[,s])
- GetTsAsOfTime(t,D[,s])

## Description

| # | Type | Description |
|---|---|---|
| 1 | t | Time series. |
| 2 | s, d, S or D | s: Date as symbol. d: Date as number (number of seconds since 1970). S: List of dates (symbol). D: List of dates (number of seconds since 1970). |
| 3 | s | Optional. Possible values: 'Delta', ‘DeltaNaNIsNaN’, 'ExactTime'. For Delta codes the function returns the difference between the current time series values and historical time series values. For DeltaNaNIsNaN the delta value is NaN (Not a number / empty) when one of the values is empty. The code ExactTime returns only those values that were written at the specified time, normally used together with GetTsAuditTimes. |

## Example
Assumes a time series with historical time series values at various times:

| Time of writing | Time series version | Value time tx | Value time tx+1 | Value time tx+2 | Value time tx+3 |
|---|---|---|---|---|---|
| December 12th 2012 00:00:00 | Ts_0 | 1 | 7 | 8 | 10 |
| November 12th 2012 00:00:00 | Ts_1 | 2 | 5 | 3 | 2 |
| October 12th 2012 00:00:00 | Ts_2 | 1 | 3 | 7 |   |
| September 12th 2012 00:00:00 | Ts_3 | 1 | 3 | 8 |   |

Example 1: GetTsAsOfTime(t,s)

Res = GetTsAsOfTime(t0,'20121201000000000')

Returns time series Ts_1 which was valid December 1st 2012.

Example 2: GetTsAsOfTime(t,s,s)

Res = GetTsAsOfTime(t0,'20121201000000000','Delta')

Returns the difference between the values in Ts_0 and Ts_1: -1 2 5 8

Example 3: GetTsAsOfTime(t,S)

Res =
GetTsAsOfTime(t0,{'20121201000000000','20121101000000000','20121001000000000'})

Returns an array of time series for the relevant times.

Example 4: GetTsAsOfTime(t,S,s)

Res =
GetTsAsOfTime(t0,{'20121201000000000','20121101000000000','20121001000000000'},'DELTA')

Returns an array of the difference between the current time series and the time
series at the relevant times.
