using ModernGraphs
using Documenter

DocMeta.setdocmeta!(ModernGraphs, :DocTestSetup, :(using ModernGraphs); recursive=true)

makedocs(;
    modules=[ModernGraphs],
    authors="Jean-Francois Baffier",
    repo="https://github.com/Humans-of-Julia/ModernGraphs.jl/blob/{commit}{path}#{line}",
    sitename="ModernGraphs.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Humans-of-Julia.github.io/ModernGraphs.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Humans-of-Julia/ModernGraphs.jl",
    devbranch="main",
)
