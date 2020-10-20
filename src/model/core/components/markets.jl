function balance_constraint!(
    jump_container::JuMPContainer,
    markets::Vector{Market},
    formulation::Type{<:TransportFormulation},
    constraint_name::Symbol,
)
    set_name = [get_name(p) for p in markets]
    exp = get_expression(jump_container, constraint_name)
    con = add_cons_container!(jump_container, constraint_name, set_name)

    for p in markets
        name = get_name(p)
        demand = get_demand(p)
        con[name] = JuMP.@constraint(jump_container.JuMPmodel, exp[name] >= demand)
    end
    return
end
