struct DataSet
    data::Dict{DataType, Dict{String, <:TransportComponent}}
end

get_data(v::DataSet) = v.data

function DataSet()
    return DataSet(Dict{DataType, Dict{String, <:TransportComponent}}())
end

function DataSet(
    plants::Dict{String, Plant},
    markets::Dict{String, Market},
    road::Dict{String, RoadLink},
)
    data = DataSet()
    add_to_dataset!(data, plants)
    add_to_dataset!(data, markets)
    add_to_dataset!(data, road)
    return data
end

function DataSet(
    canning_plants::Vector{String},
    markets::Vector{String},
    plant_capacity::Dict{String, T},
    market_demand::Dict{String, T},
    distance::Dict{Tuple{String, String}, T},
    freight_cost::T,
) where {T <: Real}
    data = DataSet()
    add_plants!(data, canning_plants, plant_capacity)
    add_markets!(data, markets, market_demand)
    add_roadlinks!(data, distance, freight_cost)
    return data
end

function DataSet(
    canning_plants::Vector{String},
    markets::Vector{String},
    plant_capacity::Dict{String, T},
    market_demand::Dict{String, T},
    elasticity::Dict{String, T},
    distance::Dict{Tuple{String, String}, T},
    freight_cost::T,
) where {T <: Real}
    data = DataSet()
    add_plants!(data, canning_plants, plant_capacity)
    add_markets!(data, markets, market_demand, elasticity)
    add_roadlinks!(data, distance, freight_cost)
    return data
end

function add_plants!(
    data::DataSet,
    canning_plants::Vector{String},
    plant_capacity::Dict{String, T},
) where {T <: Real}
    plants_structs = Dict{String, Plant}()
    for p in canning_plants
        plants_structs[p] = Plant(p, plant_capacity[p])
    end
    add_to_dataset!(data, plants_structs)
end

function add_markets!(
    data::DataSet,
    markets::Vector{String},
    market_demand::Dict{String, T},
) where {T <: Real}
    markets_struct = Dict{String, Market}()
    for m in markets
        markets_struct[m] = Market(m, market_demand[m])
    end
    add_to_dataset!(data, markets_struct)
end

function add_markets!(
    data::DataSet,
    markets::Vector{String},
    market_demand::Dict{String, T},
    elasticity::Dict{String, T},
) where {T <: Real}
    markets_struct = Dict{String, FlexibleMarket}()
    for m in markets
        markets_struct[m] = FlexibleMarket(m, market_demand[m], elasticity[m])
    end
    add_to_dataset!(data, markets_struct)
end

function add_roadlinks!(
    data::DataSet,
    distance::Dict{Tuple{String, String}, T},
    freight_cost::T,
) where {T <: Real}
    roadlink_struct = Dict{String, RoadLink}()
    for ((p, m), dist) in distance
        name = "$(p)_$m"
        plant = get_component_by_name(data, PlantData, p)
        market = get_component_by_name(data, MarketData, m)
        roadlink_struct[name] =
            RoadLink(name, market, plant, dist, freight_cost * dist / 1000)
    end
    add_to_dataset!(data, roadlink_struct)
end

function add_to_dataset!(dataset::DataSet, components::Dict{String, <:TransportComponent})
    dataset.data[eltype(values(components))] = components
end

function get_components(dataset::DataSet, type::Type{<:TransportComponent})
    data = get_data(dataset)
    if haskey(data, type)
        return collect(values(data[type]))
    else
        error("No components of type $(type) found in dataset")
    end
end

function get_component_by_name(
    dataset::DataSet,
    type::Type{<:TransportComponent},
    name::String,
)
    data = get_data(dataset)
    if Base.isabstracttype(type)
        for (k_type, component_dict) in data
            if k_type <: type
                if haskey(component_dict, name)
                    return component_dict[name]
                end
            end
        end
    else
        if haskey(data, type)
            if haskey(data[type], name)
                return data[type][name]
            else
                error("No components with name $(name) found in dataset for type $(type)")
            end
        else
            error("No components of type $(type) found in dataset")
        end
    end
    return error("No components with name $(name) found in dataset for type $(type)")
end
