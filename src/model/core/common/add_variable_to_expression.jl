function add_variables_to_expression!(
    jump_container::JuMPContainer,
    plants::Vector{Plant},
    expression_name::Symbol,
    var_name::Symbol,
    sign::Float64 = 1.0;
    kwargs...,
)
    variable = get_variable(jump_container, var_name)
    exp = get_expression(jump_container, expression_name)
    for p in plants
        name = get_name(p)
        for var in variable[name, :]
            if isassigned(exp, name)
                JuMP.add_to_expression!(exp[name], sign, var)
            else
                exp[name] = sign * var
            end
        end
    end
    return
end

function add_variables_to_NLexpression!(
    jump_container::JuMPContainer,
    plants::Vector{Plant},
    expression_name::Symbol,
    var_name::Symbol,
    sign::Float64 = 1.0;
    kwargs...,
)
    variable = get_variable(jump_container, var_name)
    exp = get_expression(jump_container, expression_name)
    for p in plants
        name = get_name(p)
        capacity = get_capacity(p)
        exp[name] = JuMP.@NLexpression(
            jump_container.JuMPmodel,
            capacity - sum(sign * v for v in variable[name, :])
        )
    end
    return
end

function add_variables_to_expression!(
    jump_container::JuMPContainer,
    markets::Vector{Market},
    expression_name::Symbol,
    var_name::Symbol,
    sign::Float64 = 1.0;
    kwargs...,
)
    variable = get_variable(jump_container, var_name)
    exp = get_expression(jump_container, expression_name)
    for m in markets
        name = get_name(m)
        for var in variable[:, name]
            if isassigned(exp, name)
                JuMP.add_to_expression!(exp[name], sign, var)
            else
                exp[name] = sign * var
            end
        end
    end
    return
end

function add_variables_to_NLexpression!(
    jump_container::JuMPContainer,
    markets::Vector{FlexibleMarket},
    expression_name::Symbol,
    var_name::Symbol,
    sign::Float64 = 1.0;
    kwargs...,
)
    variable = get_variable(jump_container, var_name)
    exp = get_expression(jump_container, expression_name)
    for m in markets
        name = get_name(m)
        demand = get_demand(m)
        exp[name] = JuMP.@NLexpression(
            jump_container.JuMPmodel,
            sum(sign * v for v in variable[:, name]) - demand
        )
    end
    return
end
