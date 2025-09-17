## TS
## About the function
Creates time series for further use in expressions or as a separate time series.

## Syntax
- TS(s[,d])
- TS(s,s[,d])

Description TS(s[,d])

| # | Type | Description | Example |
|---|---|---|---|
| 1 | s | Unit. | 'VARINT', 'MIN15', 'HOUR' etc. |
| 2 | d | Optional. Value. |   |

Description TS(s,s[,d])

| # | Type | Description | Example |
|---|---|---|---|
| 1 | s | Unit. | 'VARINT', 'MIN15', 'HOUR' etc. |
| 2 | s | Type of curve. | Type of curve is 'NONE', 'STEP' or 'LINEAR'. |
| 3 | d | Optional. Value. |   |

The value is assigned to all points in time.

## Example
@TS(s)

` TS1 = @TS('VARINT')`

Time series TS1 is defined as a break point series and is set empty (NaN) as
default.

@TS(s,d)

`TS2 = @TS('VARINT',1)`

Time series TS2 is defined as break point series and get 1 as value.

Series with other resolutions:

`TS3 = @TS('HOUR')`

Time series TS3 gives an empty time series (NaN) with hourly resolution.

`TS4 = @TS('HOUR',0)`

Time series TS4 gives a time series with 0 in all of the hours.

Other common resolutions are 'DAY' and 'WEEK'.
