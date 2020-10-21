function balance_constraint!(
    jump_container::JuMPContainer,
    markets::Vector{<:MarketData},
    formulation::Type{<:TransportFormulation},
    constraint_name::Symbol,
)
    set_name = [get_name(m) for m in markets]
    exp = get_expression(jump_container, constraint_name)
    con = add_cons_container!(jump_container, constraint_name, set_name)

    for m in markets
        name = get_name(m)
        demand = get_demand(m)
        con[name] = JuMP.@constraint(jump_container.JuMPmodel, exp[name] >= demand)
    end
    return
end

function mcp_balance_constraint!(
    jump_container::JuMPContainer,
    markets::Vector{<:MarketData},
    formulation::Type{<:TransportMCPFormulation},
    constraint_name::Symbol,
    variable_name::Symbol,
)
    set_name = [get_name(p) for p in markets]
    exp = get_expression(jump_container, constraint_name)
    var = get_variable(jump_container, variable_name)
    # con = add_cons_container!(jump_container, constraint_name, set_name)

    for m in markets
        name = get_name(m)

        # Figure out a way to store complementarity constraint ref
        # Currently @complementarity returns a Array{ComplementarityType,1}
        Complementarity.@complementarity(jump_container.JuMPmodel, exp[name], var[name])
    end
    return
end
