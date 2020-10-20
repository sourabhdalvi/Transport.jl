function construct_plant!(
    jump_container::JuMPContainer,
    dataset::DataSet,
    formulation::Type{<:TransportFormulation},
)
    plants = get_components(dataset, Plant)
    add_variables_to_expression!(jump_container, plants, SupplyBalance, ShipmentQuantities)
    balance_constraint!(jump_container, plants, formulation, SupplyBalance)
end
