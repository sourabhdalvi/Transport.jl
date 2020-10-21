using Revise
using Transport
using JuMP
using GLPK
using Ipopt
const TR = Transport
struct GenericProblem <: TR.AbstractTransportProblem end
struct GenericMCPProblem <: TR.AbstractMCPTransportProblem end
ipopt_optimizer =
    JuMP.optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-6, "print_level" => 0)
GLPK_optimizer =
    JuMP.optimizer_with_attributes(GLPK.Optimizer, "msg_lev" => GLPK.GLP_MSG_OFF)

canning_plants = ["seattle", "san-diego"]
markets = ["new-york", "chicago", "topeka"];

plant_capacity = Dict("seattle" => 350.0, "san-diego" => 600.0)

market_demand = Dict("new-york" => 325.0, "chicago" => 300.0, "topeka" => 275.0)

market_demand_elasticity = Dict("new-york" => 1.5, "chicago" => 1.2, "topeka" => 2.0)

distance = Dict(
    ("seattle", "new-york") => 2.5,
    ("seattle", "chicago") => 1.7,
    ("seattle", "topeka") => 1.8,
    ("san-diego", "new-york") => 2.5,
    ("san-diego", "chicago") => 1.8,
    ("san-diego", "topeka") => 1.4,
)

freight_cost = 90.0;

############ Determistic Example ################
dataset =
    DataSet(canning_plants, markets, plant_capacity, market_demand, distance, freight_cost)
t_problem = TR.TransportProblem(GenericProblem, dataset, TR.BasicFormulation, JuMP.Model());
TR.solve!(t_problem; optimizer = GLPK_optimizer)

############ MCP Example ################

dataset_mcp = DataSet(
    canning_plants,
    markets,
    plant_capacity,
    market_demand,
    market_demand_elasticity,
    distance,
    freight_cost,
)
t_mcpproblem = TR.TransportProblem(
    GenericMCPProblem,
    dataset_mcp,
    TR.BasicMCPFormulation,
    TR.Complementarity.MCPModel(),
);
TR.solve!(t_mcpproblem)

############## MCP with Elastic Demand Example ################
