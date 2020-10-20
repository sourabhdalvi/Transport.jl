function balance_constraint!(
    jump_container::JuMPContainer,
    plants::Vector{Plant},
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
