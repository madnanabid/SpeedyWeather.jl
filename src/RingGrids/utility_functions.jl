"""
    true/false = is_power_2(i::Integer)

Checks whether an integer `i` is a power of 2, i.e. i = 2^k, with k = 0,1,2,3,...."""
is_power_2(i::Integer) = i != 0 ? i & (i-1) == 0 : false
is_power_2_or_0(i::Integer) = i & (i-1) == 0

"""
    m = roundup_fft(n::Int;
                    small_primes::Vector{Int}=[2,3,5])

Returns an integer `m >= n` with only small prime factors 2, 3, 5 (default, others can be specified
with the keyword argument `small_primes`) to obtain an efficiently fourier-transformable number of
longitudes, m = 2^i * 3^j * 5^k >= n, with i,j,k >=0.
"""
function roundup_fft(n::Integer;small_primes::Vector{T}=[2,3,5]) where {T<:Integer}
    factors_not_in_small_primes = true      # starting condition for while loop
    n += isodd(n) ? 1 : 0                   # start with an even n
    while factors_not_in_small_primes
        
        factors = Primes.factor(n)          # prime factorization
        all_factors_small = true            # starting condition
        
        for i in 1:length(factors)          # loop over factors and check they are small
            factor = factors.pe[i].first    # extract factor from factors
            all_factors_small &= factor in small_primes
        end
        
        factors_not_in_small_primes = ~all_factors_small    # all factors small will abort while loop
        n += 2                                              # test for next larger even n
    
    end
    return n-2      # subtract unnecessary last += 2 addition
end

"""
    true/false = isincreasing(v::Vector)

Check whether elements of a vector `v` are strictly increasing."""
function isincreasing(x::Vector)
    is_increasing = true
    for i in 2:length(x)
        is_increasing &= x[i-1] < x[i] ? true : false
    end
    return is_increasing
end

"""
    true/false = isdecreasing(v::Vector)

Check whether elements of a vector `v` are strictly decreasing."""
function isdecreasing(x::Vector)
    is_decreasing = true
    for i in 2:length(x)
        is_decreasing &= x[i-1] > x[i] ? true : false
    end
    return is_decreasing
end

"""
    true/false = extrema_in(v::Vector,a::Real,b::Real)

For every element vᵢ in v does a<=vi<=b hold?"""
function extrema_in(v::Vector,
                    a::Real,
                    b::Real)
    
    vmin,vmax = extrema(v)
    return (vmin >= a) && (vmax <= b)
end

# MATRIX rotations
"""
    i_new,j_new = rotate_matrix_indices_90(i,j,s)

Rotate indices `i,j` of a square matrix of size s x s anti-clockwise by 90˚.""" 
@inline function rotate_matrix_indices_90(i::Integer,j::Integer,s::Integer)
    @boundscheck 0 < i <= s || throw(BoundsError)
    @boundscheck 0 < j <= s || throw(BoundsError)
    i_new = s+1-j   # new i from rotation
    j_new = i       # corresponding new j
    return i_new, j_new
end

"""
    i_new,j_new = rotate_matrix_indices_180(i,j,s)

Rotate indices `i,j` of a square matrix of size s x s by 180˚.""" 
@inline function rotate_matrix_indices_180(i::Integer,j::Integer,s::Integer)
    @boundscheck 0 < i <= s || throw(BoundsError)
    @boundscheck 0 < j <= s || throw(BoundsError)
    i_new = s+1-i   # new i from rotation
    j_new = s+1-j   # corresponding new j
    return i_new, j_new
end

"""
    i_new,j_new = rotate_matrix_indices_270(i,j,s)

Rotate indices `i,j` of a square matrix of size s x s anti-clockwise by 270˚.""" 
@inline function rotate_matrix_indices_270(i::Integer,j::Integer,s::Integer)
    @boundscheck 0 < i <= s || throw(BoundsError)
    @boundscheck 0 < j <= s || throw(BoundsError)
    i_new = j       # new i from rotation
    j_new = s+1-i   # corresponding new j
    return i_new, j_new
end

@inline function rotate_matrix_indices(i::Integer,j::Integer,s::Integer,r::Integer)
    r = mod(r,4)    # map 4 to 0 rotation, 5 to 1 rotation etc.
    r == 0 && return i,j
    r == 1 && return rotate_matrix_indices_90(i,j,s)
    r == 2 && return rotate_matrix_indices_180(i,j,s)
    r == 3 && return rotate_matrix_indices_270(i,j,s)
end