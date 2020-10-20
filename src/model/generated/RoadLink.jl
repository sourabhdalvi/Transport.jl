#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RoadLink <: LinkData
        name::String
        market::Market
        plant::Plant
        distance::Float64
        cost::Float64
    end

Stores information regarding the distance between plants and

# Arguments
- `name::String`: the name of the link
- `market::Market`: stores the market that road link connects to
- `plant::Plant`: stores the plant that road link connects to
- `distance::Float64`: stores the distance between market and plant, validation range: `(0, nothing)`, action if invalid: `warn`
- `cost::Float64`: stores the cost of using the road link, validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct RoadLink <: LinkData
    "the name of the link"
    name::String
    "stores the market that road link connects to"
    market::Market
    "stores the plant that road link connects to"
    plant::Plant
    "stores the distance between market and plant"
    distance::Float64
    "stores the cost of using the road link"
    cost::Float64
end


function RoadLink(; name, market, plant, distance, cost, )
    RoadLink(name, market, plant, distance, cost, )
end

# Constructor for demo purposes; non-functional.
function RoadLink(::Nothing)
    RoadLink(;
        name="init",
        market=Market(nothing),
        plant=Plant(nothing),
        distance=0.0,
        cost=0.0,
    )
end

"""Get [`RoadLink`](@ref) `name`."""
get_name(value::RoadLink) = value.name
"""Get [`RoadLink`](@ref) `market`."""
get_market(value::RoadLink) = value.market
"""Get [`RoadLink`](@ref) `plant`."""
get_plant(value::RoadLink) = value.plant
"""Get [`RoadLink`](@ref) `distance`."""
get_distance(value::RoadLink) = value.distance
"""Get [`RoadLink`](@ref) `cost`."""
get_cost(value::RoadLink) = value.cost

"""Set [`RoadLink`](@ref) `name`."""
set_name!(value::RoadLink, val) = value.name = val
"""Set [`RoadLink`](@ref) `market`."""
set_market!(value::RoadLink, val) = value.market = val
"""Set [`RoadLink`](@ref) `plant`."""
set_plant!(value::RoadLink, val) = value.plant = val
"""Set [`RoadLink`](@ref) `distance`."""
set_distance!(value::RoadLink, val) = value.distance = val
"""Set [`RoadLink`](@ref) `cost`."""
set_cost!(value::RoadLink, val) = value.cost = val
