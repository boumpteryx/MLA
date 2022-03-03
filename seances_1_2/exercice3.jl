using JuMP
using CPLEX
include("parser.jl")

function AutoBenders(MyFileName::String, nn = 0, bendersbool = false)
  n, f, c, w, d = read_instance(MyFileName)
  if nn != 0
    n = nn
    d = n÷2
    f = Array{Int64,1}(zeros(n))
    c = Array{Int64,1}(zeros(n))
    f[1], c[1] = 7, 8
    for i in 2:n
      f[i] = (f[i-1]*f[1])%159
      c[i] = (c[i-1]*c[1])%61
    end
  end
  if bendersbool
    w = 1
  end

  # Create the model
  m = Model(CPLEX.Optimizer)

  ## Variables
  @variable(m, y[1:n-1], Bin)
  @variable(m, x[1:n-1] >= 0)

  ## Constraints
  @constraint(m, sum(x[i] for i in 1:n-1) == d)
  @constraint(m, [i in 1:n-1], x[i] <= y[i])
  @constraint(m, y[1] >= y[2])
  @constraint(m, y[1] >= y[3])

  ## Objective
  @objective(m, Min, sum(f[i]*y[i] + c[i]*x[i] for i in 1:n-1))

  #resolution
  set_optimizer_attribute(m, "CPXPARAM_Benders_Strategy",3)
  optimize!(m)
end
