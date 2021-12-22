"""
Struct holding the parameters needed at runtime in number format NF.
"""
@with_kw struct Constants{NF<:AbstractFloat}
    R_earth::NF      # Radius of Earth
    Ω::NF            # Angular frequency of Earth's rotation
    g::NF            # Gravitational acceleration
    akap::NF         # Ratio of gas constant to specific heat of dry air at constant pressure
    R::NF            # Gas constant
    γ::NF            # Reference temperature lapse rate (-dT/dz in deg/km)
    hscale::NF       # Reference scale height for pressure (in km)
    hshum::NF        # Reference scale height for specific humidity (in km)
    rh_ref::NF       # Reference relative humidity of near-surface air

    # TIME STEPPING
    Δt::NF                  # time step [s] 
    robert_filter::NF       # Robert (1966) time filter coefficient to suppress comput. mode
    williams_filter::NF     # Williams time filter (Amezcua 2011) coefficient for 3rd order acc

    # DIFFUSION AND DRAG
    sdrag::NF               # drag [1/s] for zonal wind in the stratosphere
end

"""
Generator function for a Constants struct.
"""
function Constants{NF}(P::Params) where NF      # number format NF

    @unpack R_earth, Ω, g, akap, R, γ, hscale, hshum, rh_ref, Δt = P
    @unpack robert_filter, williams_filter = P
    @unpack tdrs = P

    # stratospheric drag [1/s] from drag time timescale tdrs [hrs]
    sdrag = 1/(tdrs*3600)

    # This implies conversion to NF
    return Constants{NF}(R_earth,Ω,g,akap,R,γ,hscale,hshum,rh_ref,
                            Δt,robert_filter,williams_filter,
                            sdrag)
end
