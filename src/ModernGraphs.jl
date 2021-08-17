module ModernGraphs

# Reexport
using Reexport

# Imports
@reexport using PatternFolds

# Exports
export TimeSet

export has_folds
export has_instants
export has_intervals
export is_instants
export is_intervals
export lengths
export unfold!

# Includes
include("time_set.jl")

end
