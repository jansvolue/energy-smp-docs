# DisableCache
The `@DisableCache()` function disables caching of calculation results for the
calculation expression it is used in. This is useful when calculations used for
their side effects, such as `@CopyTs` or `@PDLOG`, are referenced by another
 expression.

When executing a calculation, Mesh may cache the result of the calculation to
avoid re-calculation on future requests. For "pure" calculations — those without
side effects — this is invisible to the user. However for calculations that
involve a side effect, such as `@PDLOG`, caching is disabled
 to ensure that the side effect happens on each user request.

Mesh does however not disable the cache automatically when a function with a
side effect is referenced by a function without any direct side effects. For
example a calculation attribute `.a` with contents `@PDLOG(...)` will not be
cached, but the expression `@t(".a")` will be. Executing `@t(".a")` multiple
times may therefore not execute `@PDLOG(...)` multiple times, even
 though it logically should.

The `@DisableCache()` function can be used to explicitly disable caching for a
calculation expression. So if we change the above example to the following we
will see the desired behaviour of multiple executions calling `@PDLOG`
 multiple times.

`@DisableCache()`

`@t(".a")`
