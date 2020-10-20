#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Market <: MarketData
        name::String
        demand::Float64
    end

Stores information regarding markets in Transport model

# Arguments
- `name::String`: the name of the market
- `demand::Float64`: demand for the market, validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct Market <: MarketData
    "the name of the market"
    name::String
    "demand for the market"
    demand::Float64
end


function Market(; name, demand, )
    Market(name, demand, )
end

# Constructor for demo purposes; non-functional.
function Market(::Nothing)
    Market(;
        name="init",
        demand=0.0,
    )
end

"""Get [`Market`](@ref) `name`."""
get_name(value::Market) = value.name
"""Get [`Market`](@ref) `demand`."""
get_demand(value::Market) = value.demand

"""Set [`Market`](@ref) `name`."""
set_name!(value::Market, val) = value.name = val
"""Set [`Market`](@ref) `demand`."""
set_demand!(value::Market, val) = value.demand = val
