# Time examples
This topic provides examples of how to use some of the Time related functions.

An expression:

| Expression | Description |
|---|---|
| tstart = @Time('YEAR',@Time('SOP')) | Start of the year where requested time interval starts |
| viewEndTime = @Time('EOP') | End of requested time interval |
| @PushExtPeriod('x', tstart - @TimeSpan('HOUR'), viewEndTime) | Change execution time interval to one hour before tstart and keep the same end |
| Precip = @t('PrecipBucket') * 1.0 |   |
| @PopExtPeriod('x') | Unregister the temporary execution time interval |
| @PushExtPeriod('y', tstart, @Time('EOP')) | Register another time interval |
| Delta = @DELTA(Precip) |   |
| DeltaClipped = Delta >= -2 ? Delta : 0 |   |
| @PopExtPeriod('y') | Unregister |
| ## = @ACCUMULATE(DeltaClipped,'>', 'YEAR') | Accumulate from start of year |

The system aims at handling the extended time intervals automatically, but this
manual example illustrates the usage of some of the Time functions.

Instead of the last statement, you could enter as follows:

`## = @ACCUMULATE(0.0, @TimeToString(tstart), DeltaClipped, 1, 0)`

I.e. accumulate values continuously from `tstart` to requested time interval
end.
