module GR3
  @[Link("GR3")]
  lib LibGR3
    fun gr3_init(Int32*) : Int32
    fun gr3_free(Void*) : Void
    fun gr3_terminate : Void
    fun gr3_geterror(Int32, Int32*, UInt8**) : Int32
    fun gr3_getrenderpathstring : UInt8*
    fun gr3_geterrorstring(Int32) : UInt8*
    # fun gr3_setlogcallback() : Void
    fun gr3_clear : Int32
    fun gr3_usecurrentframebuffer : Void
    fun gr3_useframebuffer(UInt32) : Void
    fun gr3_setquality(Int32) : Int32
    fun gr3_getimage(Int32, Int32, Int32, UInt8*) : Int32
    fun gr3_export(UInt8*, Int32, Int32) : Int32
    fun gr3_drawimage(Float32, Float32, Float32, Float32, Int32, Int32, Int32) : Int32
    fun gr3_createmesh_nocopy(Int32*, Int32, Float32*, Float32*, Float32*) : Int32
    fun gr3_createmesh(Int32*, Int32, Float32*, Float32*, Float32*) : Int32
    fun gr3_createindexedmesh_nocopy(Int32*, Int32, Float32*, Float32*, Float32*, Int32, Int32*) : Int32
    fun gr3_createindexedmesh(Int32*, Int32, Float32*, Float32*, Float32*, Int32, Int32*) : Int32
    fun gr3_drawmesh(Int32, Int32, Float32*, Float32*, Float32*, Float32*, Float32*) : Void
    fun gr3_deletemesh(Int32) : Void
    fun gr3_cameralookat(Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32) : Void
    fun gr3_setcameraprojectionparameters(Float32, Float32, Float32) : Int32
    fun gr3_getcameraprojectionparameters(Float32*, Float32*, Float32*) : Int32
    fun gr3_setlightdirection(Float32, Float32, Float32) : Void
    fun gr3_setbackgroundcolor(Float32, Float32, Float32, Float32) : Void
    fun gr3_createheightmapmesh(Float32*, Int32, Int32) : Int32
    fun gr3_drawheightmap(Float32*, Int32, Int32, Float32*, Float32*) : Void
    fun gr3_drawconemesh(Int32, Float32*, Float32*, Float32*, Float32*, Float32*) : Void
    fun gr3_drawcylindermesh(Int32, Float32*, Float32*, Float32*, Float32*, Float32*) : Void
    fun gr3_drawspheremesh(Int32, Float32*, Float32*, Float32*) : Void
    fun gr3_drawcubemesh(Int32, Float32*, Float32*, Float32*, Float32*, Float32*) : Void
    fun gr3_setobjectid(Int32) : Void
    fun gr3_selectid(Int32, Int32, Int32, Int32, Int32*) : Int32
    fun gr3_getviewmatrix(Float32*) : Void
    fun gr3_setviewmatrix(Float32*) : Void
    fun gr3_getprojectiontype : Int32
    fun gr3_setprojectiontype(Int32) : Void
    # fun gr3_triangulate(UShort*, UShort, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64, **) : UInt32
    # fun gr3_triangulateindexed(UShort*, UShort, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64, UInt32*, **, **, UInt32*, UInt32**) : Void
    fun gr3_createisosurfacemesh(Int32*, UShort*, UShort, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64) : Int32
    fun gr3_createsurfacemesh(Int32*, Int32, Int32, Float32*, Float32*, Float32*, Int32) : Int32
    fun gr3_drawmesh_grlike(Int32, Int32, Float32*, Float32*, Float32*, Float32*, Float32*) : Void
    fun gr3_drawsurface(Int32) : Void
    fun gr3_surface(Int32, Int32, Float32*, Float32*, Float32*, Int32) : Void
    fun gr3_drawtubemesh(Int32, Float32*, Float32*, Float32*, Int32, Int32) : Int32
    fun gr3_createtubemesh(Int32*, Int32, Float32*, Float32*, Float32*, Int32, Int32) : Int32
    fun gr3_drawspins(Int32, Float32*, Float32*, Float32*, Float32, Float32, Float32, Float32) : Void
    # fun gr3_drawmolecule(Int32, Float32*, Float32*, Float32*, Float32, , Float32) : Void
    fun gr3_createxslicemesh(Int32*, UShort*, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64) : Void
    fun gr3_createyslicemesh(Int32*, UShort*, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64) : Void
    fun gr3_createzslicemesh(Int32*, UShort*, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64) : Void
    fun gr3_drawxslicemesh(UShort*, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64) : Void
    fun gr3_drawyslicemesh(UShort*, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64) : Void
    fun gr3_drawzslicemesh(UShort*, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, Float64, Float64, Float64, Float64, Float64, Float64) : Void
    fun gr3_drawtrianglesurface(Int32, Float32*) : Void
    fun gr_volume(Int32, Int32, Int32, Float64*, Int32, Float64*, Float64*) : Void
    fun gr3_setorthographicprojection(Float32, Float32, Float32, Float32, Float32, Float32) : Void
  end
end
