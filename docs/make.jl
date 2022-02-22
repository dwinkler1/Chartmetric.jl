using Chartmetric
using Documenter

DocMeta.setdocmeta!(Chartmetric, :DocTestSetup, :(using Chartmetric); recursive=true)

makedocs(;
    modules=[Chartmetric],
    authors="Daniel Winkler <danielw2904@disroot.org> and contributors",
    repo="https://github.com/danielw2904/Chartmetric.jl/blob/{commit}{path}#{line}",
    sitename="Chartmetric.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://danielw2904.github.io/Chartmetric.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/danielw2904/Chartmetric.jl",
    devbranch="main",
)
