# Status group functions

Functions in the status group are used to make changes on the status of time series. This is done in the following way:

When performing time series calculations the operation is divided into a sequence of binary operations.

For example, evaluating "TS1 + TS2"  for a time period of 24 hours is divided into 24 operations in case the time series has hourly resolution.

The binary operation combines two operands and an operator,  for example value at time t:Ts1(t) + Ts2(t). A value in this context is a numeric value and a status flag.

The status flag is bit based, which means it can hold different independent statuses.

When the calculator engine is processing such binary operations, the following rules are applied to both the numeric part and the status part:

2 + 10 = 12  with status suspect NOT set

NaN + 10 = 10  with status suspect set (because one of the operands is missing value)

10 – NaN = 10 with status suspect set

10 * NaN = NaN with status suspect and missing set

10 / NaN = NaN with status notok and missing set

 

An example where you may see a suspect value from a higher level calculation is when there is a SUM calculation applied for a group of time series.

If some of the series are missing a value at a given time point, the result will be marked as suspect for this time point.
