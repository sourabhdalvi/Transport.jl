
function construct_markets!(
    jump_container::JuMPContainer,
    dataset::DataSet,
    formulation::Type{<:TransportFormulation},
)
    markets = get_components(dataset, Market)
    add_variables_to_expression!(jump_container, markets, DemandBalance, ShipmentQuantities)
    balance_constraint!(jump_container, markets, formulation, DemandBalance)
end
