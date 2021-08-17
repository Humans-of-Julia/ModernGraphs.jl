"""
    TimeSet{T <: Real}

A structure to store any collection of time instants and intervals.
- `instants`: a set of discrete instants
- `instants_folds`: a set of pattern-periodic time instants
- `intervals`: a vector of time intervals
- `intervals`: a set of time intervals with pattern-periodic properties
"""
struct TimeSet{T <: Real}
    instants::Set{T}
    instants_folds::Set{VectorFold{T}}
    intervals::Vector{Interval{T, <:Bound, <:Bound}}
    intervals_folds::Set{IntervalsFold{T, <:Bound, <:Bound}}

    function TimeSet{T}(;
        instants = Set{T}(),
        instants_folds = Set{VectorFold{T}}(),
        intervals = Vector{Interval{T, Bound, Bound}}(),
        intervals_folds = Set{IntervalsFold{T, Bound, Bound}}(),
    ) where {T}
        return new{T}(
            Set(collect(instants)),
            Set(collect(instants_folds)),
            Vector(collect(intervals)),
            Set(collect(intervals_folds)),
        )
    end

    TimeSet() = TimeSet{Float64}()
end

"""
    has_instants(time_set)
Check whether a time set has time instants (discrete).
"""
has_instants(ts) = !isempty(ts.instants) || !isempty(ts.instants_folds)

"""
    has_intervals(time_set)
Check whether a time set has time intervals (continuous).
"""
has_intervals(ts) = !isempty(ts.intervals) || !isempty(ts.intervals_folds)

"""
    has_folds(time_set)
Check whether a time set has folded time sets (periodic-like).
"""
has_folds(ts) = !isempty(ts.instants_folds) || !isempty(ts.intervals_folds)

"""
    is_instants(time_set)
Check if a time set is made of only time instants (discrete).
"""
is_instants(ts) = has_instants(ts) && !has_intervals(ts)

"""
    is_intervals(time_set)
Check if a time set is made of only time intervals (continuous).
"""
is_intervals(ts) = !has_instants(ts) && has_intervals(ts)

"""
    isempty(time_set)
Check if a time set is empty.
"""
Base.isempty(ts::TimeSet) = !has_instants(ts) && !has_intervals(ts)

"""
    in(ts::TimeSet{T}, t::T) where {T <: Real}
    ∈(ts::TimeSet{T}, t::T) where {T <: Real}
Check whether `t` is in `ts`.
"""
function Base.in(ts::TimeSet{T}, t::T) where {T <: Real}
    t ∈ ts.instants && return true
    any(vf -> t ∈ vf, ts.instants_folds) && return true
    any(ivl -> t ∈ ivl, ts.intervals) && return true
    any(ivl -> t ∈ ivl, ts.intervals_folds) && return true
    return false
end

"""
    unfold!(time_set)
Unfold the folded parts of a time set and add them to the non-folded components of `time_set`. Guarantee that `has_folds(time_set) == false` after it.
"""
function unfold!(ts::TimeSet)
    for vf in ts.instants_folds, t in vf
        push!(ts.instants, t)
    end
    for isf in ts.intervals_folds, interval in isf
        push!(ts.intervals, interval)
    end
    union!(ts.intervals)
    empty!(ts.instants_folds)
    empty!(ts.intervals_folds)
    return nothing
end

"""
    PatternFolds.unfold(ts::TimeSet)
Return an unfolded copy of `ts`.
"""
function PatternFolds.unfold(ts::TimeSet)
    ts₂ = deepcopy(ts)
    unfold!(ts₂)
    return ts₂
end
