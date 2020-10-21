function balance_constraint!(
    jump_container::JuMPContainer,
    plants::Vector{<:PlantData},
    formulation::Type{<:TransportFormulation},
    constraint_name::Symbol,
)
    set_name = [get_name(p) for p in plants]
    exp = get_expression(jump_container, constraint_name)
    con = add_cons_container!(jump_container, constraint_name, set_name)

    for p in plants
        name = get_name(p)
        capacity = get_capacity(p)
        con[name] = JuMP.@constraint(jump_container.JuMPmodel, exp[name] <= capacity)
    end
    return
end

function mcp_balance_constraint!(
    jump_container::JuMPContainer,
    plants::Vector{<:PlantData},
    formulation::Type{<:TransportMCPFormulation},
    constraint_name::Symbol,
    variable_name::Symbol,
)
    set_name = [get_name(p) for p in plants]
    exp = get_expression(jump_container, constraint_name)
    var = get_variable(jump_container, variable_name)
    # con = add_cons_container!(jump_container, constraint_name, set_name)

    for p in plants
        name = get_name(p)

        # Figure out a way to store complementarity constraint ref
        # Currently `get_MCP_data(m)`  stores the reference to the complementarity constraint
        Complementarity.add_complementarity(
            jump_container.JuMPmodel,
            var[name],
            exp[name],
            String(constraint_name),
        )
    end
    return
end
