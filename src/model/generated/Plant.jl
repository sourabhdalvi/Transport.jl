#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Plant <: PlantData
        name::String
        capacity::Float64
    end

Stores information regarding canning plants in Transport model

# Arguments
- `name::String`: the name of the plant
- `capacity::Float64`: stores the canning capacity for the plant, validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct Plant <: PlantData
    "the name of the plant"
    name::String
    "stores the canning capacity for the plant"
    capacity::Float64
end


function Plant(; name, capacity, )
    Plant(name, capacity, )
end

# Constructor for demo purposes; non-functional.
function Plant(::Nothing)
    Plant(;
        name="init",
        capacity=0.0,
    )
end

"""Get [`Plant`](@ref) `name`."""
get_name(value::Plant) = value.name
"""Get [`Plant`](@ref) `capacity`."""
get_capacity(value::Plant) = value.capacity

"""Set [`Plant`](@ref) `name`."""
set_name!(value::Plant, val) = value.name = val
"""Set [`Plant`](@ref) `capacity`."""
set_capacity!(value::Plant, val) = value.capacity = val
