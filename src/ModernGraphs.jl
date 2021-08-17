module ModernGraphs

# Reexport
using Reexport

# Imports
@reexport using PatternFolds

# Constants
const Bound = Intervals.Bound

# Exports
export TimeSet

export has_folds
export has_instants
export has_intervals
export is_instants
export is_intervals
export unfold!

# Includes
include("time_set.jl")

end
