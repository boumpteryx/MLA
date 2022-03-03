using JuMP
using CPLEX
include("parser.jl")
include("exercice1.jl")
include("exercice2.jl")
include("exercice3.jl")
include("exercice4.jl")
include("exercice5.jl")

timee = Array{Float64,2}(zeros(10,5))
for i in 10000:10000:50000
  size = i
  j = i÷10000
  time_1 = @timed Benders("instance1.txt", size) # exo 1
  timee[j,1] = time_1.time

  time_2 = @timed Normal("instance1.txt", size) # exo 2
  timee[j,2] = time_2.time

  time_3 = @timed AutoBenders("instance1.txt", size) # exo 3
  timee[j,3] = time_3.time

  time_4 = @timed FastBenders("instance1.txt", size) # exo 4
  timee[j,4] = time_4.time

  time_5 = @timed FastBendersGurobi("instance1.txt", size) # exo 5
  timee[j,5] = time_5.time
end

for j in 1:5
  println("size of instance = ", j*10000)
  println(timee[j,1], " seconds for exercise 1")
  println(timee[j,2], " seconds for exercise 2")
  println(timee[j,3], " seconds for exercise 3")
  println(timee[j,4], " seconds for exercise 4")
  println(timee[j,5], " seconds for exercise 5")
end
