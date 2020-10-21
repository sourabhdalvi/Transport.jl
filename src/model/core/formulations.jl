abstract type TransportFormulation end
abstract type TransportMCPFormulation <: TransportFormulation end
struct BasicFormulation <: TransportFormulation end
struct BasicMCPFormulation <: TransportMCPFormulation end
