## AT
## About the function
Retrieves an element from an object. Relevant object types are array of time
series, numbers or time series.

## Syntax
- AT(T,d)
- AT(D,d)
- AT(t,s)

## Description

| # | Type | Description |
|---|---|---|
| 1 | T | Array of time series. |
| 1 | t | Time series. |
| 1 | D | Array of floating-point numbers. |
| 2 | s | Time argument. May be a macro expanded to time point. Examples: DAY+10h, UTC20141124 |
| 2 | d | Lookup index, the first value has index 0. |

The following variants exist:

| Variant | Description |
|---|---|
| @AT(T,d) | Returns one of the time series in the input array, based on the lookup index in argument 2. Index 0, returns the first time series in the array, index 1 returns the second time series in the array, etc. |
| @AT(D,d) | Returns a single number from the array in argument 1, based on the lookup index in argument 2. |
| @AT(t,s) | Treats t as an array. Returns a single value (a double) from the time series, based on the lookup time in argument 2. The time argument may be a macro expanded to time point. |

Looking up an index outside [0,n-1], where n is the number of elements, returns
NaN.

## Example
DArray = {10,11,12,13,14}

Res1 = @AT(DArray,0)

Res2 = @AT(DArray,2)

Result: Res1=10 and Res2=12, that is 0-based index lookup.
