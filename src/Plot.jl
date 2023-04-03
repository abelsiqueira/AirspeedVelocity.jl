module BenchPkgPlot

using ..PlotUtils: load_results, combined_plots
using Comonicon
using Plots

"""
    benchpkgplot package_name [-r --rev <arg>] [-i --input_dir <arg>]
                              [-o --output-dir <arg>] [-n --npart <arg>]
                              [-f --format <arg>]

Plot the benchmarks of a package as created with `benchpkg`.

# Arguments

- `package_name`: Name of the package.

# Options

- `-r, --rev <arg>`: Revisions to test (delimit by comma).
- `-i, --input-dir <arg>`: Where the JSON results were saved (default: ".").
- `-o, --output-dir <arg>`: Where to save the plots results (default: ".").
- `-n, --npart <arg>`: Max number of plots per page (default: 10).
- `-f, --format <arg>`: File type to save the plots as (default: "png").
"""
@main function benchpkgplot(
    package_name::String;
    rev::String,
    input_dir::String=".",
    output_dir::String=".",
    npart::Int=10,
    format::String="png",
)
    revs = convert(Vector{String}, split(rev, ","))
    # Filter empty strings:
    revs = filter(x -> length(x) > 0, revs)
    @assert length(revs) > 0 "No revisions specified."
    combined_results = load_results(package_name, revs; input_dir=input_dir)

    plots = combined_plots(combined_results; npart=npart)
    @info "Saving plots."
    if length(plots) == 1
        savefig(first(plots), joinpath(output_dir, "plot_$(package_name).$(format)"))
    else
        for (i, p) in enumerate(plots)
            savefig(p, joinpath(output_dir, "plot_$(package_name)_$i.$(format)"))
        end
    end

    return nothing
end

end # AirspeedVelocity.BenchPkgPlot
