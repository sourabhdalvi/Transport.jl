#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct FlexibleMarket <: MarketData
        name::String
        demand::Float64
        price_elasticity::Float64
    end

Stores information regarding markets in Transport model

# Arguments
- `name::String`: the name of the market
- `demand::Float64`: demand for the market, validation range: `(0, nothing)`, action if invalid: `warn`
- `price_elasticity::Float64`: price elasticity of demand (at prices equal to unity), validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct FlexibleMarket <: MarketData
    "the name of the market"
    name::String
    "demand for the market"
    demand::Float64
    "price elasticity of demand (at prices equal to unity)"
    price_elasticity::Float64
end


function FlexibleMarket(; name, demand, price_elasticity, )
    FlexibleMarket(name, demand, price_elasticity, )
end

# Constructor for demo purposes; non-functional.
function FlexibleMarket(::Nothing)
    FlexibleMarket(;
        name="init",
        demand=0.0,
        price_elasticity=0.0,
    )
end

"""Get [`FlexibleMarket`](@ref) `name`."""
get_name(value::FlexibleMarket) = value.name
"""Get [`FlexibleMarket`](@ref) `demand`."""
get_demand(value::FlexibleMarket) = value.demand
"""Get [`FlexibleMarket`](@ref) `price_elasticity`."""
get_price_elasticity(value::FlexibleMarket) = value.price_elasticity

"""Set [`FlexibleMarket`](@ref) `name`."""
set_name!(value::FlexibleMarket, val) = value.name = val
"""Set [`FlexibleMarket`](@ref) `demand`."""
set_demand!(value::FlexibleMarket, val) = value.demand = val
"""Set [`FlexibleMarket`](@ref) `price_elasticity`."""
set_price_elasticity!(value::FlexibleMarket, val) = value.price_elasticity = val
