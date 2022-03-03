using JuMP
using CPLEX
include("parser.jl")
include("exercice1.jl")
include("exercice2.jl")
include("exercice3.jl")
include("exercice4.jl")
include("exercice5.jl")

start = time()
size = 50000
Benders("instance1.txt", size) # exo 1
time1 = time() - start

Normal("instance1.txt", size) # exo 2
time2 = time() - time1

AutoBenders("instance1.txt", size) # exo 3
time3 = time() - time2

FastBenders("instance1.txt", size) # exo 4
time4 = time() - time3

FastBendersGurobi("instance1.txt", size) # exo 5
time5 = time() - time4

println("size of instance = ", size)
println(time1, " seconds for exercise 1")
println(time2, " seconds for exercise 2")
println(time3, " seconds for exercise 3")
println(time4, " seconds for exercise 4")
println(time5, " seconds for exercise 5")
