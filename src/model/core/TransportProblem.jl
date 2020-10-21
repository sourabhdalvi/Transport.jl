mutable struct TransportProblem{M <: AbstractTransportProblem}
    formulation::Type{<:TransportFormulation}
    dataset::DataSet
    jump_container::JuMPContainer
end

get_formulation(v::TransportProblem) = v.formulation
get_dataset(v::TransportProblem) = v.dataset
get_jump_container(v::TransportProblem) = v.jump_container

function TransportProblem(
    ::Type{M},
    dataset::DataSet,
    formulation::Type{<:TransportFormulation},
    jump_model::Union{Nothing, JuMP.AbstractModel} = nothing;
    kwargs...,
) where {M <: AbstractTransportProblem}
    t_problem = TransportProblem{M}(formulation, dataset, JuMPContainer(jump_model))
    build!(t_problem)
    return t_problem
end

function build!(t_problem::TransportProblem{M}) where {M <: AbstractTransportProblem}
    jump_container_init!(t_problem.jump_container, t_problem.formulation, t_problem.dataset)
    _build!(t_problem.jump_container, t_problem.formulation, t_problem.dataset)
    return
end

function _build!(
    jump_container::JuMPContainer,
    formulation::Type{<:TransportFormulation},
    dataset::DataSet,
)
    @debug "Building RoadLinks with $formulation"
    roadlinks = get_components(dataset, RoadLink)
    construct_roadlinks!(jump_container, roadlinks, formulation)

    @debug "Building Plants with $formulation"
    plants = get_components(dataset, Plant)
    construct_plant!(jump_container, plants, formulation)

    @debug "Building Markets with $formulation"
    markets = get_components(dataset, Market)
    construct_markets!(jump_container, markets, formulation)

    @debug "Building Objective"
    JuMP.@objective(
        jump_container.JuMPmodel,
        JuMP.MOI.MIN_SENSE,
        jump_container.cost_function
    )
    return
end

function _build!(
    jump_container::JuMPContainer,
    formulation::Type{<:TransportMCPFormulation},
    dataset::DataSet,
)
    @debug "Building RoadLinks with $formulation"
    roadlinks = get_components(dataset, RoadLink)
    construct_roadlinks!(jump_container, roadlinks, formulation)

    @debug "Building Plants with $formulation"
    plants = get_components(dataset, Plant)
    construct_plant!(jump_container, plants, formulation)

    @debug "Building Markets with $formulation"
    markets = get_components(dataset, FlexibleMarket)
    construct_markets!(jump_container, markets, formulation)

    @debug "Building Objective"
    JuMP.@objective(
        jump_container.JuMPmodel,
        JuMP.MOI.MIN_SENSE,
        jump_container.cost_function
    )
    return
end

function solve!(
    t_problem::TransportProblem{T};
    kwargs...,
) where {T <: AbstractTransportProblem}

    timed_log = Dict{Symbol, Any}()
    if t_problem.jump_container.JuMPmodel.moi_backend.state == JuMP.MOIU.NO_OPTIMIZER
        if !(:optimizer in keys(kwargs))
            error("No Optimizer has been defined, can't solve the operational problem")
        end
        JuMP.set_optimizer(t_problem.jump_container.JuMPmodel, kwargs[:optimizer])
        JuMP.optimize!(t_problem.jump_container.JuMPmodel)
    else
        JuMP.optimize!(t_problem.jump_container.JuMPmodel)
    end
    model_status = JuMP.primal_status(t_problem.jump_container.JuMPmodel)
    return model_status
end

function solve!(
    t_problem::TransportProblem{T};
    kwargs...,
) where {T <: AbstractMCPTransportProblem}

    timed_log = Dict{Symbol, Any}()
    Complementarity.PATHSolver.options(convergence_tolerance=1e-8, output=:yes, time_limit=3600)
    model_status = Complementarity.solveMCP(t_problem.jump_container.JuMPmodel)
    return model_status
end

function construct_complementarity_conditions!(
    jump_container::JuMPContainer,
    dataset::DataSet,
    formulation::Type{<:TransportMCPFormulation},
)
    road_links = get_components(dataset, RoadLink)
    plants = get_components(dataset, Plant)
    markets = get_components(dataset, Market)

    mcp_balance_constraint!(
        jump_container,
        markets,
        formulation,
        DemandBalance,
        DemandPrice,
    )
    mcp_balance_constraint!(jump_container, plants, formulation, SupplyBalance, SupplyPrice)
    mcp_profit_constraint!(
        jump_container,
        road_links,
        formulation,
        ProfitCondition,
        (ShipmentQuantities, SupplyPrice, DemandPrice),
    )
    return
end
