@testset "TimeSet" begin
    ts₁ = TimeSet()
    λ₁ = (0., 0., 0., 0.)
    Λ₁ = sum(λ₁)

    ts₂ = TimeSet{Float64}(instants = [1.,2.,3.])
    λ₂ = (3., 0., 0., 0.)
    Λ₂ = sum(λ₂)

    ts₃ = TimeSet{Float64}(instants_folds = [VectorFold([1.,2.], 10., 5)])
    λ₃ = (0., 10., 0., 0.)
    Λ₃ = sum(λ₃)

    ts₄ = TimeSet{Float64}(intervals = [1.0..2.0, 3.0..7.0, 3.14..42.0])
    λ₄ = (0., 0., 43.86, 0.)
    Λ₄ = sum(λ₄)

    ts₅ = TimeSet{Float64}(intervals_folds = [IntervalsFold(1.0..3.0, 5., 3)])
    λ₅ = (0., 0., 0., 6.)
    Λ₅ = sum(λ₅)

    ts₆ = TimeSet{Float64}(
        instants_folds = [VectorFold([1.,2.], 10., 5)],
        intervals_folds = [IntervalsFold(1.0..3.0, 5., 3)],
    )
    λ₆ = (0., 10., 0., 6.)
    Λ₆ = sum(λ₆)

    ts₇ = unfold(ts₆)
    λ₇ = (10., 0., 6., 0.)
    Λ₇ = sum(λ₇)

    time_sets = Dict([
        ts₁ => Dict([
            :has_instants => false,
            :has_intervals => false,
            :has_folds => false,
            :is_instants => false,
            :is_intervals => false,
            :isempty => true,
            :∋ => [(1., false), (2, false)],
            :lengths => λ₁,
            :length => Λ₁,
        ]),
        ts₂ => Dict([
            :has_instants => true,
            :has_intervals => false,
            :has_folds => false,
            :is_instants => true,
            :is_intervals => false,
            :isempty => false,
            :∋ => [(1., true), (4., false)],
            :lengths => λ₂,
            :length => Λ₂,
        ]),
        ts₃ => Dict([
            :has_instants => true,
            :has_intervals => false,
            :has_folds => true,
            :is_instants => true,
            :is_intervals => false,
            :isempty => false,
            :∋ => [(1., true), (12., true), (88., false)],
            :lengths => λ₃,
            :length => Λ₃,
        ]),
        ts₄ => Dict([
            :has_instants => false,
            :has_intervals => true,
            :has_folds => false,
            :is_instants => false,
            :is_intervals => true,
            :isempty => false,
            :∋ => [(1., true), (3.5, true), (42.42, false)],
            :lengths => λ₄,
            :length => Λ₄,
        ]),
        ts₅ => Dict([
            :has_instants => false,
            :has_intervals => true,
            :has_folds => true,
            :is_instants => false,
            :is_intervals => true,
            :isempty => false,
            :∋ => [(1., true), (5.5, false), (6.5, true), (42.42, false)],
            :lengths => λ₅,
            :length => Λ₅,
        ]),
        ts₆ => Dict([
            :has_instants => true,
            :has_intervals => true,
            :has_folds => true,
            :is_instants => false,
            :is_intervals => false,
            :isempty => false,
            :∋ => [(1., true), (5.5, false), (6.5, true), (42.42, false)],
            :lengths => λ₆,
            :length => Λ₆,
        ]),
        ts₇ => Dict([
            :has_instants => true,
            :has_intervals => true,
            :has_folds => false,
            :is_instants => false,
            :is_intervals => false,
            :isempty => false,
            :∋ => [(1., true), (5.5, false), (6.5, true), (42.42, false)],
            :lengths => λ₇,
            :length => Λ₇,
        ]),
    ])

    for (ts, results) in time_sets, (f, result) in results
        if typeof(result) <: AbstractVector{<:Tuple}
            for subresult in result
                @test eval(f)(ts, subresult[1]) == subresult[2]
            end
        else
            @test eval(f)(ts) == result
        end
    end

    for ts in keys(time_sets)
        if isempty(ts)
            @test_throws AssertionError rand(ts)
        else
            @test rand(ts) ∈ ts
        end
    end
end
