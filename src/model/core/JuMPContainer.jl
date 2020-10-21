mutable struct JuMPContainer
    JuMPmodel::Union{Nothing, JuMP.AbstractModel}
    variables::Dict{Symbol, AbstractArray}
    constraints::Dict{Symbol, AbstractArray}
    cost_function::JuMP.AbstractJuMPScalar
    expressions::Dict{Symbol, JuMP.Containers.DenseAxisArray}

    function JuMPContainer(jump_model::Union{Nothing, JuMP.AbstractModel})
        new(
            jump_model,
            Dict{Symbol, AbstractArray}(),
            Dict{Symbol, AbstractArray}(),
            zero(JuMP.GenericAffExpr{Float64, JuMP.VariableRef}),
            DenseAxisArrayContainer(),
        )
    end
end

get_variables(jump_container::JuMPContainer) = jump_container.variables
get_variable(jump_container::JuMPContainer, name::Symbol) = jump_container.variables[name]
get_constraints(jump_container::JuMPContainer) = jump_container.constraints
get_constraint(jump_container::JuMPContainer, name::Symbol) =
    jump_container.constraints[name]
get_expression(jump_container::JuMPContainer, name::Symbol) =
    jump_container.expressions[name]

function jump_container_init!(
    jump_container::JuMPContainer,
    formulation::Type{<:TransportFormulation},
    dataset::DataSet,
)
    _make_expressions_dict!(jump_container, dataset, formulation)
    return
end

function _make_expressions_dict!(
    jump_container::JuMPContainer,
    dataset::DataSet,
    formulation::Type{<:TransportFormulation},
)
    _markets = [get_name(m) for m in get_components(dataset, Market)]
    _plants = [get_name(p) for p in get_components(dataset, Plant)]
    jump_container.expressions = DenseAxisArrayContainer(
        SupplyBalance => JuMP.Containers.DenseAxisArray{GAE}(undef, _plants),
        DemandBalance => JuMP.Containers.DenseAxisArray{GAE}(undef, _markets),
    )
    return
end

function _make_expressions_dict!(
    jump_container::JuMPContainer,
    dataset::DataSet,
    formulation::Type{<:TransportMCPFormulation},
)
    _markets = [get_name(m) for m in get_components(dataset, FlexibleMarket)]
    _plants = [get_name(p) for p in get_components(dataset, Plant)]
    jump_container.expressions = DenseAxisArrayContainer(
        SupplyBalance =>
            JuMP.Containers.DenseAxisArray{JuMP.NonlinearExpression}(undef, _plants),
        DemandBalance =>
            JuMP.Containers.DenseAxisArray{JuMP.NonlinearExpression}(undef, _markets),
    )
    return
end

function get_variable_names(psi_container::JuMPContainer)
    return collect(keys(psi_container.variables))
end

""" Returns the correct container spec for the selected type of JuMP Model"""
function container_spec(m::M, axs...) where {M <: JuMP.AbstractModel}
    return JuMP.Containers.DenseAxisArray{JuMP.variable_type(m)}(undef, axs...)
end

""" Returns the correct container spec for the selected type of JuMP Model"""
function sparse_container_spec(m::M, axs...) where {M <: JuMP.AbstractModel}
    indexes = Base.Iterators.product(axs...)
    contents = Dict{eltype(indexes), Any}(indexes .=> 0)
    return JuMP.Containers.SparseAxisArray(contents)
end

function assign_variable!(psi_container::JuMPContainer, name::Symbol, value)
    @debug "assign_variable" name

    if haskey(psi_container.variables, name)
        error("variable $name is already stored", sort!(get_variable_names(psi_container)))
    end

    psi_container.variables[name] = value
    return
end

function add_var_container!(
    psi_container::JuMPContainer,
    var_name::Symbol,
    axs...;
    sparse = false,
)
    if sparse
        container = sparse_container_spec(psi_container.JuMPmodel, axs...)
    else
        container = container_spec(psi_container.JuMPmodel, axs...)
    end
    assign_variable!(psi_container, var_name, container)
    return container
end

function assign_expression!(psi_container::JuMPContainer, name::Symbol, value)
    @debug "set_expression" name

    if haskey(psi_container.expressions, name)
        error(
            "expression $name is already stored",
            sort!(get_variable_names(psi_container)),
        )
    end

    psi_container.expressions[name] = value
    return
end

function add_expression_container!(psi_container::JuMPContainer, exp_name::Symbol, axs...)
    container = JuMP.Containers.DenseAxisArray{JuMP.GenericAffExpr}(undef, axs...)
    assign_expression!(psi_container, exp_name, container)
    return container
end

function add_NLexpression_container!(psi_container::JuMPContainer, exp_name::Symbol, axs...)
    container = JuMP.Containers.DenseAxisArray{JuMP.NonlinearExpression}(undef, axs...)
    assign_expression!(psi_container, exp_name, container)
    return container
end

function assign_constraint!(psi_container::JuMPContainer, name::Symbol, value)
    @debug "set_constraint" name

    if haskey(psi_container.constraints, name)
        error(
            "constraint $name is already stored",
            sort!(get_variable_names(psi_container)),
        )
    end

    psi_container.constraints[name] = value
    return
end

function add_cons_container!(
    psi_container::JuMPContainer,
    cons_name::Symbol,
    axs...;
    sparse = false,
)
    if sparse
        container = sparse_container_spec(psi_container.JuMPmodel, axs...)
    else
        container = JuMPConstraintArray(undef, axs...)
    end
    assign_constraint!(psi_container, cons_name, container)
    return container
end

function add_to_cost_expression!(
    psi_container::JuMPContainer,
    cost_expression::JuMP.AbstractJuMPScalar,
)
    T_ce = typeof(cost_expression)
    T_cf = typeof(psi_container.cost_function)
    if T_cf <: JuMP.GenericAffExpr && T_ce <: JuMP.GenericQuadExpr
        psi_container.cost_function += cost_expression
    else
        JuMP.add_to_expression!(psi_container.cost_function, cost_expression)
    end
    return
end
