abstract type AbstractTransportProblem end
abstract type AbstractMCPTransportProblem <: AbstractTransportProblem end

const DenseAxisArrayContainer = Dict{Symbol, JuMP.Containers.DenseAxisArray}
const GAE = JuMP.GenericAffExpr{Float64, JuMP.VariableRef}
const JuMPConstraintArray = JuMP.Containers.DenseAxisArray{JuMP.ConstraintRef}

const ShipmentQuantities = :x
const SupplyPrice = :w
const DemandPrice = :p
const SupplyBalance = :supply_balance
const DemandBalance = :demand_balance
const ElasticDemandBalance = :elastic_demand_balance
const ProfitCondition = :profit
