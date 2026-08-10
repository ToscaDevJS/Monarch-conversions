# Table Filtering Specification

## Requirement
The table header must present interactive dropdown filters allowing users to slice conversion records by Status, Input Format, Output Format, and Project name, plus a Reset button to clear active filters.

## Functional Specs
1. **Filter Criteria**:
   - `Status`: `Working`, `Done`, or `All` (default)
   - `Input Format`: Any valid `ImageFormat` or `All` (default)
   - `Output Format`: Any valid `ImageFormat` or `All` (default)
   - `Project`: Unique non-empty projects in dataset or `All` (default)
2. **Filtering Behavior**:
   - Filters are cumulative (AND logic).
   - Displayed records update reactively as filter choices change.
3. **Reset Behavior**:
   - Clicking `Reset` resets all 4 filters back to `All`.
