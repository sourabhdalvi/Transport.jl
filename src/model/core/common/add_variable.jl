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
