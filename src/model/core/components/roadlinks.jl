get_plant_name(v::RoadLink) = get_name(get_plant(v))
get_market_name(v::RoadLink) = get_name(get_market(v))

function cost_function!(
    jump_container::JuMPContainer,
    road_links::Vector{<:LinkData},
    formulation::Type{<:TransportFormulation},
)
    variable = get_variable(jump_container, ShipmentQuantities)
    total_gen_cost = JuMP.AffExpr(0.0)
    for r in road_links
        plant = get_plant_name(r)
        market = get_market_name(r)
        JuMP.add_to_expression!(total_gen_cost, get_cost(r) * variable[plant, market])
    end
    add_to_cost_expression!(jump_container, total_gen_cost)
    return
end

function mcp_profit_constraint!(
    jump_container::JuMPContainer,
    roadlinks::Vector{<:LinkData},
    formulation::Type{<:TransportMCPFormulation},
    constraint_name::Symbol,
    variable_names::Tuple{Symbol, Symbol, Symbol},
)
    plants_set = unique([get_name(get_plant(r)) for r in roadlinks])
    markets_set = unique([get_name(get_market(r)) for r in roadlinks])
    var_x = get_variable(jump_container, variable_names[1])
    var_w = get_variable(jump_container, variable_names[2])
    var_p = get_variable(jump_container, variable_names[3])

    # con = add_cons_container!(jump_container, constraint_name, plants_set, markets_set)
    exp = add_NLexpression_container!(
        jump_container,
        constraint_name,
        plants_set,
        markets_set,
    )

    for r in roadlinks
        plant = get_plant_name(r)
        market = get_market_name(r)
        exp[plant, market] = JuMP.@NLexpression(
            jump_container.JuMPmodel,
            var_w[plant] + get_cost(r) - var_p[market]
        )

        # Figure out a way to store complementarity constraint ref
        # Currently @complementarity returns a Array{ComplementarityType,1}
        Complementarity.@complementarity(
            jump_container.JuMPmodel,
            exp[plant, market],
            var_x[plant, market]
        )
    end
    return
end
