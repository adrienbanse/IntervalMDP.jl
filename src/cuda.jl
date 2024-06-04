# NOTE: This file does not explicitly use the CUDA.jl package, but it is
# included to allow the CUDA extension to define the necessary functions and types.

struct CuModelAdaptor{Tv} end

valtype(::Type{CuModelAdaptor{Tv}}) where {Tv} = Tv

function cu end

struct OutOfSharedMemory <: Exception
    min_shared_memory::Int
end

function Base.showerror(io::IO, e::OutOfSharedMemory)
    println(
        io,
        "Out of shared memory: minimum required size is ",
        e.min_shared_memory,
        " bytes.",
    )
    println(
        io,
        "Please try either the CPU implementation, the (dense) decomposed representation (preferred), or use a larger GPU..",
    )
end
