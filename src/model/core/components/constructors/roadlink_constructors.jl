function construct_roadlinks!(
    jump_container::JuMPContainer,
    dataset::DataSet,
    formulation::Type{<:TransportFormulation},
)
    road_links = get_components(dataset, RoadLink)
    add_variable!(jump_container, road_links, ShipmentQuantities, false)
    cost_function!(jump_container, road_links, formulation)
end
