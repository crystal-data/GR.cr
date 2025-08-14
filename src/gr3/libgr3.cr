module GR3
  {% if env("GRDIR") %}
    @[Link(ldflags: "-L `echo $GRDIR/lib` -lGR3 -Wl,-rpath,`echo $GRDIR/lib`")]
  {% else %}
    @[Link("gr3")]
  {% end %}
  lib LibGR3
    # Type aliases
    alias Gr3McDtype = LibC::UShort

    # Structures
    struct CoordT
      x : LibC::Float
      y : LibC::Float
      z : LibC::Float
    end

    struct TriangleT
      vertices : CoordT[3]
      normal : CoordT[3]
    end

    struct Volume2PassT
      dmin : LibC::Double
      dmax : LibC::Double
      priv : Void* # gr3_volume_2pass_priv_t *
    end

    # Initialization and termination
    fun init = gr3_init(attrib_list : LibC::Int*) : LibC::Int
    fun free = gr3_free(pointer : Void*)
    fun terminate = gr3_terminate

    # Error handling
    fun geterror = gr3_geterror(clear : LibC::Int, line : LibC::Int*, file : LibC::Char**) : LibC::Int
    fun getrenderpathstring = gr3_getrenderpathstring : LibC::Char*
    fun geterrorstring = gr3_geterrorstring(error : LibC::Int) : LibC::Char*
    fun setlogcallback = gr3_setlogcallback(log_func : (LibC::Char* -> Void))

    # Rendering control
    fun clear = gr3_clear : LibC::Int
    fun usecurrentframebuffer = gr3_usecurrentframebuffer
    fun useframebuffer = gr3_useframebuffer(framebuffer : LibC::UInt)
    fun setquality = gr3_setquality(quality : LibC::Int) : LibC::Int

    # Image operations
    fun getimage = gr3_getimage(width : LibC::Int, height : LibC::Int, use_alpha : LibC::Int, pixels : LibC::Char*) : LibC::Int
    fun export = gr3_export(filename : LibC::Char*, width : LibC::Int, height : LibC::Int) : LibC::Int
    fun drawimage = gr3_drawimage(xmin : LibC::Float, xmax : LibC::Float, ymin : LibC::Float, ymax : LibC::Float, width : LibC::Int, height : LibC::Int, drawable_type : LibC::Int) : LibC::Int

    # Mesh creation and management
    fun createmesh_nocopy = gr3_createmesh_nocopy(mesh : LibC::Int*, n : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*) : LibC::Int
    fun createmesh = gr3_createmesh(mesh : LibC::Int*, n : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*) : LibC::Int
    fun createindexedmesh_nocopy = gr3_createindexedmesh_nocopy(mesh : LibC::Int*, number_of_vertices : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*, number_of_indices : LibC::Int, indices : LibC::Int*) : LibC::Int
    fun createindexedmesh = gr3_createindexedmesh(mesh : LibC::Int*, number_of_vertices : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*, number_of_indices : LibC::Int, indices : LibC::Int*) : LibC::Int
    fun deletemesh = gr3_deletemesh(mesh : LibC::Int)

    # Mesh drawing
    fun drawmesh = gr3_drawmesh(mesh : LibC::Int, n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, ups : LibC::Float*, colors : LibC::Float*, scales : LibC::Float*)
    fun drawmesh_grlike = gr3_drawmesh_grlike(mesh : LibC::Int, n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, ups : LibC::Float*, colors : LibC::Float*, scales : LibC::Float*)

    # Camera control
    fun cameralookat = gr3_cameralookat(camera_x : LibC::Float, camera_y : LibC::Float, camera_z : LibC::Float, center_x : LibC::Float, center_y : LibC::Float, center_z : LibC::Float, up_x : LibC::Float, up_y : LibC::Float, up_z : LibC::Float)
    fun setcameraprojectionparameters = gr3_setcameraprojectionparameters(vertical_field_of_view : LibC::Float, z_near : LibC::Float, z_far : LibC::Float) : LibC::Int
    fun getcameraprojectionparameters = gr3_getcameraprojectionparameters(vfov : LibC::Float*, znear : LibC::Float*, zfar : LibC::Float*) : LibC::Int

    # View and projection matrices
    fun getviewmatrix = gr3_getviewmatrix(matrix : LibC::Float*)
    fun setviewmatrix = gr3_setviewmatrix(matrix : LibC::Float*)
    fun getprojectiontype = gr3_getprojectiontype : LibC::Int
    fun setprojectiontype = gr3_setprojectiontype(type : LibC::Int)
    fun setorthographicprojection = gr3_setorthographicprojection(left : LibC::Float, right : LibC::Float, bottom : LibC::Float, top : LibC::Float, znear : LibC::Float, zfar : LibC::Float)

    # Lighting and background
    fun setlightdirection = gr3_setlightdirection(x : LibC::Float, y : LibC::Float, z : LibC::Float)
    fun setbackgroundcolor = gr3_setbackgroundcolor(red : LibC::Float, green : LibC::Float, blue : LibC::Float, alpha : LibC::Float)
    fun getlightsources = gr3_getlightsources(max_num_lights : LibC::Int, positions : LibC::Float*, colors : LibC::Float*) : LibC::Int
    fun setlightsources = gr3_setlightsources(num_lights : LibC::Int, positions : LibC::Float*, colors : LibC::Float*) : LibC::Int
    fun setlightparameters = gr3_setlightparameters(ambient : LibC::Float, diffuse : LibC::Float, specular : LibC::Float, specular_power : LibC::Float)
    fun getlightparameters = gr3_getlightparameters(ambient : LibC::Float*, diffuse : LibC::Float*, specular : LibC::Float*, specular_power : LibC::Float*)
    fun setdefaultlightparameters = gr3_setdefaultlightparameters

    # Primitive shapes
    fun drawconemesh = gr3_drawconemesh(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, lengths : LibC::Float*)
    fun drawcylindermesh = gr3_drawcylindermesh(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, lengths : LibC::Float*)
    fun drawspheremesh = gr3_drawspheremesh(n : LibC::Int, positions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*)
    fun drawcubemesh = gr3_drawcubemesh(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, ups : LibC::Float*, colors : LibC::Float*, scales : LibC::Float*)

    # Surface and heightmap rendering
    fun createheightmapmesh = gr3_createheightmapmesh(heightmap : LibC::Float*, num_columns : LibC::Int, num_rows : LibC::Int) : LibC::Int
    fun drawheightmap = gr3_drawheightmap(heightmap : LibC::Float*, num_columns : LibC::Int, num_rows : LibC::Int, positions : LibC::Float*, scales : LibC::Float*)
    fun createsurfacemesh = gr3_createsurfacemesh(mesh : LibC::Int*, nx : LibC::Int, ny : LibC::Int, px : LibC::Float*, py : LibC::Float*, pz : LibC::Float*, option : LibC::Int) : LibC::Int
    fun createsurface3dmesh = gr3_createsurface3dmesh(mesh : LibC::Int*, ncols : LibC::Int, nrows : LibC::Int, px : LibC::Float*, py : LibC::Float*, pz : LibC::Float*) : LibC::Int
    fun drawsurface = gr3_drawsurface(mesh : LibC::Int)
    fun surface = gr3_surface(nx : LibC::Int, ny : LibC::Int, px : LibC::Float*, py : LibC::Float*, pz : LibC::Float*, option : LibC::Int)
    fun setsurfaceoption = gr3_setsurfaceoption(option : LibC::Int)
    fun getsurfaceoption = gr3_getsurfaceoption : LibC::Int

    # Isosurface and volume rendering
    fun triangulate = gr3_triangulate(data : Gr3McDtype*, isolevel : Gr3McDtype, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double, triangles_p : TriangleT**) : LibC::UInt
    fun triangulateindexed = gr3_triangulateindexed(data : Gr3McDtype*, isolevel : Gr3McDtype, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double, num_vertices : LibC::UInt*, vertices : CoordT**, normals : CoordT**, num_indices : LibC::UInt*, indices : LibC::UInt**)
    fun createisosurfacemesh = gr3_createisosurfacemesh(mesh : LibC::Int*, data : Gr3McDtype*, isolevel : Gr3McDtype, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double) : LibC::Int
    fun isosurface = gr3_isosurface(nx : LibC::Int, ny : LibC::Int, nz : LibC::Int, data : LibC::Float*, isovalue : LibC::Float, color : LibC::Float*, strides : LibC::Int*)

    # Slice rendering
    fun createxslicemesh = gr3_createxslicemesh(mesh : LibC::Int*, data : Gr3McDtype*, ix : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun createyslicemesh = gr3_createyslicemesh(mesh : LibC::Int*, data : Gr3McDtype*, iy : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun createzslicemesh = gr3_createzslicemesh(mesh : LibC::Int*, data : Gr3McDtype*, iz : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun drawxslicemesh = gr3_drawxslicemesh(data : Gr3McDtype*, ix : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun drawyslicemesh = gr3_drawyslicemesh(data : Gr3McDtype*, iy : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun drawzslicemesh = gr3_drawzslicemesh(data : Gr3McDtype*, iz : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)

    # Advanced drawing functions
    fun drawtubemesh = gr3_drawtubemesh(n : LibC::Int, points : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, num_steps : LibC::Int, num_segments : LibC::Int) : LibC::Int
    fun createtubemesh = gr3_createtubemesh(mesh : LibC::Int*, n : LibC::Int, points : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, num_steps : LibC::Int, num_segments : LibC::Int) : LibC::Int
    fun drawspins = gr3_drawspins(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, colors : LibC::Float*, cone_radius : LibC::Float, cylinder_radius : LibC::Float, cone_height : LibC::Float, cylinder_height : LibC::Float)
    fun drawmolecule = gr3_drawmolecule(n : LibC::Int, positions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, bond_radius : LibC::Float, bond_color : LibC::Float[3], bond_delta : LibC::Float)
    fun drawtrianglesurface = gr3_drawtrianglesurface(n : LibC::Int, triangles : LibC::Float*)

    # Volume rendering
    fun volume = gr_volume(nx : LibC::Int, ny : LibC::Int, nz : LibC::Int, data : LibC::Double*, algorithm : LibC::Int, dmin_ptr : LibC::Double*, dmax_ptr : LibC::Double*)
    fun volume_2pass = gr_volume_2pass(nx : LibC::Int, ny : LibC::Int, nz : LibC::Int, data : LibC::Double*, algorithm : LibC::Int, dmin_ptr : LibC::Double*, dmax_ptr : LibC::Double*, context : Volume2PassT*) : Volume2PassT*

    # Selection and interaction
    fun setobjectid = gr3_setobjectid(id : LibC::Int)
    fun selectid = gr3_selectid(x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int, selection_id : LibC::Int*) : LibC::Int

    # Alpha blending and clipping
    fun getalphamode = gr3_getalphamode(mode : LibC::Int*) : LibC::Int
    fun setalphamode = gr3_setalphamode(mode : LibC::Int)
    fun setclipping = gr3_setclipping(xmin : LibC::Float, xmax : LibC::Float, ymin : LibC::Float, ymax : LibC::Float, zmin : LibC::Float, zmax : LibC::Float)
    fun getclipping = gr3_getclipping(xmin : LibC::Float*, xmax : LibC::Float*, ymin : LibC::Float*, ymax : LibC::Float*, zmin : LibC::Float*, zmax : LibC::Float*)
  end
end
