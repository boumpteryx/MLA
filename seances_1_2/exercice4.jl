using JuMP
using CPLEX
include("parser.jl")

function FastBenders(MyFileName::String, nn = 0, bendersbool = false)
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
  b = 1
  v = Array{Int64,1}(zeros(n-1))

  #### probleme maitre ####
  # Create the model
  m = Model(CPLEX.Optimizer)

  ## Variables
  @variable(m, y[1:n-1], Bin)
  @variable(m, w >= 0)

  ## Constraints
  @constraint(m, w >= d*b - sum(y[i]*v[i] for i in 1:n-1))
  @constraint(m, y[1] >= y[2])
  @constraint(m, y[1] >= y[3])


  ## Objective
  @objective(m, Min, w + sum(f[i]*y[i] for i in 1:n-1))

  #resolution
  optimize!(m)

  y_star = JuMP.getvalue.( m[:y] )
  y_star = Array{Int64,1}(ones(n-1))
  w_star = JuMP.getvalue.( m[:w] )
  b_star = 1000
  v_star = v

  while w_star < d*b_star - sum(y_star[i]*v_star[i] for i in 1:n-1)
    if sum(y_star[i] for i in 1:n-1) > d
      #### sous-probleme ####
      # Create the model
      m1 = Model(CPLEX.Optimizer)

      ## Variables
      @variable(m1, v[1:n-1] >= 0)
      @variable(m1, b)

      ## Constraints
      @constraint(m1, [i in 1:n-1], b - v[i] <= c[i])

      ## Objective
      @objective(m1, Max, d*b - sum(y_star[i]*v[i] for i in 1:n-1))

      #resolution
      optimize!(m1)

      w_star  = JuMP.objective_value.(m1)
      v_star = JuMP.getvalue.( m1[:v] )
      b_star = JuMP.getvalue.( m1[:b] )

      #### adding Constraints
      @constraint(m, w >= d*b_star - sum(y[i]*v_star[i] for i in 1:n-1))

      optimize!(m)
      y_star = JuMP.getvalue.( m[:y] )
      w_star = JuMP.getvalue.( m[:w] )
    end
    if sum(y_star[i] for i in 1:n-1) == d
      # sans PL
      b_star = max(c[i], i in 1:n-1)
      for i in 1:n-1
        v_star[i] = b_star - c[i]
      end
    end
  end
end
