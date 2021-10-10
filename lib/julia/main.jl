#!/usr/bin/env julia

# this is first ever code that I wrote in Julia
# so performance is probably very bad :(

function CosineSimilarity(A, B)::Float64
    return A'B / √ (A'A * B'B)
end

if length(ARGS) != 4
    println("Usage: <repeat> <size> <file1> <file2>")
    exit(1)
end

k = parse(Int32, ARGS[1])
n = parse(Int32, ARGS[2])

A = Float64[parse(Float64, x) for x in readlines(ARGS[3])]
B = Float64[parse(Float64, x) for x in readlines(ARGS[4])]

t = .0
s = .0

for i = 1:k
    t1 = time()
    global s = CosineSimilarity(A, B)

    t2 = time()
    global t += t2 - t1
end

t /= k

print("$s $t")
