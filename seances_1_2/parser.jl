# parser

function read_instance(MyFileName::String)
  path = "./" * MyFileName
  # Si le fichier path existe
  if isfile(path)
    # L’ouvrir
    myFile = open(path)
    n = parse(Int64, split(readline(myFile), " ")[3])
    f = Array{Int64,1}(zeros(n-1)) # on met a zero pour l'instant
    c = Array{Int64,1}(zeros(n-1)) # on met a zero pour l'instant
    line1 =  split(readline(myFile), " ")
    line2 =  split(readline(myFile), " ")
    for i in 1:n-1
      f[i] = parse(Int64,line1[i+2])
      if parse(Int64,line2[i+2]) == 66
        c[i] = typemax(Int64)
      end
      if parse(Int64,line2[i+2]) != 66
        c[i] = parse(Int64,line2[i+2])
      end

    end
    w = parse(Int64,line1[n])
    d = parse(Int64, split(readline(myFile), " ")[3])
    return n, f, c, w, d
  end
end
