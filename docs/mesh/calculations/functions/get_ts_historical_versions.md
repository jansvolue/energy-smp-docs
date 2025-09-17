# GetTsHistoricalVersions
**About the function**

Returns an array of a given number of versions of a time series.

## Syntax
- GetTsHistoricalVersions(t,d)

## Description

| # | Type | Description |
|---|---|---|
| 1 | t | Time series. |
| 2 | d | Desired number of historical versions of a time series. |

Note! If you ask for more versions than there exists, the system returns only
the versions which exist. That is, potentially fewer than the number given as
input to the function.

**Example**

GetTsHistoricalVersions(ts,1) returns the last change made, i.e. the latest
historical version that is different from the current time series.

GetTsHistoricalVersions(ts,3) returns the three last changes. The first series
displays the state before the last change, the second displays the state before
the second last change, etc.
