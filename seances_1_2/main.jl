using JuMP
using CPLEX
include("parser.jl")
include("exercice1.jl")
include("exercice2.jl")
include("exercice3.jl")
include("exercice4.jl")

start = time()

# Benders("instance1.txt") # exo 1
# Normal("instance1.txt", 1000) # exo 2
# AutoBenders("instance1.txt", 1000) # exo 3
FastBenders("instance1.txt") # exo 4

println(time() - start, " time")
