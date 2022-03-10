using JuMP
using CPLEX
include("instances/exemple-lecture-graphe.jl")
include("exercice1.jl")
# include("exercice2.jl")
# include("exercice3.jl")

global b = 1 # broadband

time_1 = @timed Benders("benders3.txt", b) # exo 1

println("size of instance = ", n)
println(time_1.time, " seconds for exercise 1")