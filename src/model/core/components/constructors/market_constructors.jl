function construct_markets!(
    jump_container::JuMPContainer,
    markets::Vector{<:MarketData},
    formulation::Type{<:TransportFormulation},
)
    add_variables_to_expression!(jump_container, markets, DemandBalance, ShipmentQuantities)
    balance_constraint!(jump_container, markets, formulation, DemandBalance)
end

function construct_markets!(
    jump_container::JuMPContainer,
    markets::Vector{FlexibleMarket},
    formulation::Type{<:TransportMCPFormulation},
)
    add_variable!(jump_container, markets, DemandPrice, false)
    add_variables_to_NLexpression!(
        jump_container,
        markets,
        DemandBalance,
        ShipmentQuantities,
    )
end
