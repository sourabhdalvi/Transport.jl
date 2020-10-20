abstract type AbstractTransportProblem end

const DenseAxisArrayContainer = Dict{Symbol, JuMP.Containers.DenseAxisArray}
const GAE = JuMP.GenericAffExpr{Float64, JuMP.VariableRef}
const JuMPConstraintArray = JuMP.Containers.DenseAxisArray{JuMP.ConstraintRef}

const ShipmentQuantities = :x
const SupplyBalance = :supply_balance
const DemandBalance = :demand_balance
