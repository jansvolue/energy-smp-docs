# **GetTsAuditTimes**
## About the function
Returns an array of timepoints related to change events on given time series and
restricted to a given maximum number.

The function is often used together with GetTsAsOfTime in 'ExactTime' mode to
extract explicitly what parts of the series that where changed at these times.

## Syntax
- GetTsAuditTimes(t,d)

## Description

| # | Type | ## Description |
|---|---|---|
| 1 | t | Time series. |
| 2 | d | Desired maximum number of audit times for the time series. |

Note! If the number of change events for given time series and period is less
than the given number, then a reduced set is returned.

## Example
GetTsAuditTimes (t0,3) returns the time points related to the last 3 changes
made within requested period for time series t0.

@GetTsAsOfTime( t0, @GetTsAuditTimes(t0,3), 'ExactTime') returns an array of 3
time series with changes related to each time returned from GetTsAuditTimes.
Values not part of an explicit change is NaN
