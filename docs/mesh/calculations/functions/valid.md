# Valid
## About the function
A time series reference specified by **@t(‘TheReference’)** may give no result.
The reason for this may be one of the following:

- **TheReference** does not exist.
- There is no connection to a physical time series from the current context.

In these cases the system will display a warning message. The warning message
tells the user it did not manage to resolve **TheReference** for a given object.

You may use either [IsValid](../functions/isvalid.md) or Valid to handle these cases.

## Syntax
- IsValid(t)

## Syntax
- Valid(T)

## Description

| Type | Description |
|---|---|
| t | Array of source time series, where each of them is normally the result of a @t(‘TheReference’). |

The function returns an array of valid time series.
