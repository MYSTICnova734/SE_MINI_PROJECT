# 12. Suspension & Resumption Criteria

## Suspend testing if:
* Environment is unavailable for $> 4$ consecutive hours.
* Build is too unstable (blocking defects prevent execution of $> 30\%$ of planned test cases).
* Cascading database migration failures invalidate test data seeds.

## Resume testing if:
* Blocking defects are resolved and verified with a smoke test.
* Environment is stabilized and synthetic test data is re-seeded.
