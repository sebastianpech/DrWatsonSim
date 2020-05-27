using DrWatson
@quickactivate "dummy_project"
using DrWatsonSim
using BSON
using Dates

function long_running_computation(p,output_path)
    sleep(p[:duration])
    result = p[:a]^p[:b]
    BSON.bson(output_path, Dict(:result=>result))
    return nothing
end

duration = [10,0.1,1.0]
a = [1,2]
b = 3
parameter = @dict duration a b

dict_list(parameter)
                                                     
if in_simulation_mode()
    m = Metadata(simdir())
    m["type"] = "Simple Computation"
    m["started at"] = Dates.now()
end

@run x->long_running_computation(x, simdir("output.bson")) dict_list(parameter) datadir("sims")
