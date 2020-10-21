function construct_plant!(
    jump_container::JuMPContainer,
    plants::Vector{<:PlantData},
    formulation::Type{<:TransportFormulation},
)
    add_variables_to_expression!(jump_container, plants, SupplyBalance, ShipmentQuantities)
    balance_constraint!(jump_container, plants, formulation, SupplyBalance)
    return
end

function construct_plant!(
    jump_container::JuMPContainer,
    plants::Vector{<:PlantData},
    formulation::Type{<:TransportMCPFormulation},
)
    add_variable!(jump_container, plants, SupplyPrice, false)
    add_variables_to_NLexpression!(
        jump_container,
        plants,
        SupplyBalance,
        ShipmentQuantities,
    )
    return
end
