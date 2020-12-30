module example.org/go_bench

go 1.15

require (
    example.org/cos_sim v0.0.0
)

replace (
    example.org/cos_sim => ./cos_sim
)
