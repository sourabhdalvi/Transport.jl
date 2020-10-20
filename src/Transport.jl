module Transport

## Exports
export Market
export Plant
export RoadLink

export get_name
export get_demand
export get_capacity
export get_market
export get_plant
export get_distance
export get_cost
export set_name!
export set_demand!
export set_capacity!
export set_market!
export set_plant!
export set_distance!
export set_cost!

export TransportComponent
export LinkData
export PlantData
export MarketData

export DataSet
export get_components
export get_component_by_name
export add_to_dataset!
export add_roadlinks!
export add_markets!
export add_plants!

export TransportProblem
export get_formulation
export get_dataset
export get_jump_container
export build!
export solve!

export JuMPContainer
export get_variables
export get_variable
export get_constraints
export get_expression
export get_constraint
export get_variable_names

export TransportFormulation
export BasicFormulation

export AbstractTransportProblem
export ShipmentQuantities
export SupplyBalance
export DemandBalance


## Imports
import JuMP

## Includes

include("./abstract_types.jl")
include("model/generated/includes.jl")
include("./base.jl")

include("model/core/definations.jl")
include("model/core/formulations.jl")
include("model/core/JuMPContainer.jl")
include("model/core/TransportProblem.jl")
include("model/core/common/add_variable.jl")
include("model/core/common/add_variable_to_expression.jl")
include("model/core/components/roadlinks.jl")
include("model/core/components/plants.jl")
include("model/core/components/markets.jl")
include("model/core/components/constructors/roadlink_constructors.jl")
include("model/core/components/constructors/plant_constructors.jl")
include("model/core/components/constructors/market_constructors.jl")

end # module
