function construct_roadlinks!(
    jump_container::JuMPContainer,
    road_links::Vector{<:LinkData},
    formulation::Type{<:TransportFormulation},
)
    add_variable!(jump_container, road_links, ShipmentQuantities, false)
    cost_function!(jump_container, road_links, formulation)
end

function construct_roadlinks!(
    jump_container::JuMPContainer,
    road_links::Vector{<:LinkData},
    formulation::Type{<:TransportMCPFormulation},
)
    add_variable!(jump_container, road_links, ShipmentQuantities, false)
    return
end
