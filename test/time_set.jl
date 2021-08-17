@testset "TimeSet" begin
    ts₁ = TimeSet()
    ts₂ = TimeSet{Float64}(instants = [1.,2.,3.])
    ts₃ = TimeSet{Float64}(instants_folds = [VectorFold([1.,2.], 10., 5)])
    ts₄ = TimeSet{Float64}(intervals = [1.0..2.0, 3.0..7.0, 3.14..42.0])
    ts₅ = TimeSet{Float64}(intervals_folds = [IntervalsFold(1.0..3.0, 5., 3)])
    ts₆ = TimeSet{Float64}(
        instants_folds = [VectorFold([1.,2.], 10., 5)],
        intervals_folds = [IntervalsFold(1.0..3.0, 5., 3)],
    )

    time_sets = Dict([
        ts₁ => Dict([
            :has_instants => false,
            :has_intervals => false,
            :has_folds => false,
            :is_instants => false,
            :is_intervals => false,
            :isempty => true,
            :in => [(1., false), (2, false)],
        ]),
        ts₂ => Dict([
            :has_instants => true,
            :has_intervals => false,
            :has_folds => false,
            :is_instants => true,
            :is_intervals => false,
            :isempty => false,
            :in => [(1., true), (4., false)],
        ]),
        ts₃ => Dict([
            :has_instants => true,
            :has_intervals => false,
            :has_folds => true,
            :is_instants => true,
            :is_intervals => false,
            :isempty => false,
            :in => [(1., true), (12., true), (88., false)],
        ]),
        ts₄ => Dict([
            :has_instants => false,
            :has_intervals => true,
            :has_folds => false,
            :is_instants => false,
            :is_intervals => true,
            :isempty => false,
            :in => [(1., true), (3.5, true), (42.42, false)],
        ]),
        ts₅ => Dict([
            :has_instants => false,
            :has_intervals => true,
            :has_folds => true,
            :is_instants => false,
            :is_intervals => true,
            :isempty => false,
            :in => [(1., true), (5.5, false), (6.5, true), (42.42, false)],
        ]),
        ts₆ => Dict([
            :has_instants => true,
            :has_intervals => true,
            :has_folds => true,
            :is_instants => false,
            :is_intervals => false,
            :isempty => false,
            :in => [(1., true), (5.5, false), (6.5, true), (42.42, false)],
        ]),
        unfold(ts₆) => Dict([
            :has_instants => true,
            :has_intervals => true,
            :has_folds => false,
            :is_instants => false,
            :is_intervals => false,
            :isempty => false,
            :in => [(1., true), (5.5, false), (6.5, true), (42.42, false)],
        ]),
    ])

    for (ts, results) in time_sets, (f, result) in results
        if typeof(result) <: AbstractVector{<:Any}
            for subresult in result
                @test eval(f)(ts, subresult[1]) == subresult[2]
                if eval(f)(ts, subresult[1]) != subresult[2]
                    @warn f ts (eval(f)(ts, subresult[1])) subresult[1] subresult[2]
                end
            end
        else
            @test eval(f)(ts) == result
        end
    end
end
