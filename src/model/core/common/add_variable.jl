function add_variable!(
    jump_container::JuMPContainer,
    roadlinks::Vector{RoadLink},
    var_name::Symbol,
    binary::Bool,
    kwargs...,
)
    @assert !isempty(roadlinks)
    plants_set = unique([get_name(get_plant(r)) for r in roadlinks])
    markets_set = unique([get_name(get_market(r)) for r in roadlinks])
    variable = add_var_container!(jump_container, var_name, plants_set, markets_set)

    for plant in plants_set, market in markets_set
        variable[plant, market] = JuMP.@variable(
            jump_container.JuMPmodel,
            base_name = "$(var_name)_{$(plant), $(market)}",
            binary = binary
        )

        JuMP.set_lower_bound(variable[plant, market], 0.0)
    end

    return
end

function add_variable!(
    jump_container::JuMPContainer,
    component::Vector{<:TransportComponent},
    var_name::Symbol,
    binary::Bool,
    kwargs...,
)
    @assert !isempty(component)
    name_set = unique([get_name(c) for c in component])
    variable = add_var_container!(jump_container, var_name, name_set)

    for c in name_set
        variable[c] = JuMP.@variable(
            jump_container.JuMPmodel,
            base_name = "$(var_name)_{$(c)}",
            binary = binary
        )

        JuMP.set_lower_bound(variable[c], 0.0)
    end

    return
end
