get_plant_name(v::RoadLink) = get_name(get_plant(v))
get_market_name(v::RoadLink) = get_name(get_market(v))

function cost_function!(
    jump_container::JuMPContainer,
    road_links::Vector{RoadLink},
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
