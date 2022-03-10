using JuMP
using CPLEX
include("instances/exemple-lecture-graphe.jl")

function Benders(file::String, b::Int64)
  n, m, adj, demande = readGraph(file::String)
  #### probleme maitre ####
  # Create the model
  m0 = Model(CPLEX.Optimizer)

  ## Variables
  @variable(m0, y[1:m] >= 0, Int)

  ## Constraints


  ## Objective
  @objective(m0, Min, sum(y[i] for i in 1:m))

  #resolution
  optimize!(m0)

  y_star = JuMP.getvalue.( m0[:y] )

  valid = false

  while valid == false
    #### sous-probleme ####
    # Create the model
    m1 = Model(CPLEX.Optimizer)

    ## Variables
    @variable(m1, v[1:m+n] >= 0)

    ## Constraints
    @constraint(m1, [ij in n+1:n+m, i in 1:n, j in 1:n ; i<j], - v[ij] - v[i] + v[j] <= 0)
    @constraint(m1, [ij in n+1:n+m, i in 1:n, j in 1:n ; i<j], - v[ij] + v[i] - v[j] <= 0)
    @constraint(m1, v[1] == 0) # on saute la source
    @constraint(m1, sum(v[i] for i in 1:m+n) == 1)

    ## Objective
    @objective(m1, Max, - sum(b*y_star[ij]*v[n+ij] for ij in 1:m) + sum(demande[i]*v[i] for i in 1:n))

    #resolution
    optimize!(m1)

    v_star = JuMP.getvalue.( m1[:v] )

    if - sum(b*y_star[ij]*v_star[n+ij] for ij in 1:m) + sum(demande[i]*v_star[i] for i in 1:n) > 0 + 1e-8

      #### adding Constraints
      @constraint(m0, - sum(b*y[ij]*v_star[n+ij] for ij in 1:m) + sum(demande[i]*v_star[i] for i in 1:n) <= 0) # (4b)

      optimize!(m0)
      y_star = JuMP.getvalue.( m0[:y] )
    
    else 
      valid = true
    end
    
  end
  println(y_star)

end