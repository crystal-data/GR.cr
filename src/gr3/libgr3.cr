module GR3
  @[Link("GR3")]
  lib LibGR3
    fun init = gr3_init(attrib_list : LibC::Int*) : LibC::Int
    fun free = gr3_free(pointer : Void*)
    fun terminate = gr3_terminate
    fun geterror = gr3_geterror(clear : LibC::Int, line : LibC::Int*, file : LibC::Char**) : LibC::Int
    fun getrenderpathstring = gr3_getrenderpathstring : LibC::Char*
    fun geterrorstring = gr3_geterrorstring(error : LibC::Int) : LibC::Char*
    fun setlogcallback = gr3_setlogcallback(log_func : (LibC::Char* -> Void))
    fun clear = gr3_clear : LibC::Int
    fun usecurrentframebuffer = gr3_usecurrentframebuffer
    fun useframebuffer = gr3_useframebuffer(framebuffer : LibC::UInt)
    fun setquality = gr3_setquality(quality : LibC::Int) : LibC::Int
    fun getimage = gr3_getimage(width : LibC::Int, height : LibC::Int, use_alpha : LibC::Int, pixels : LibC::Char*) : LibC::Int
    fun export = gr3_export(filename : LibC::Char*, width : LibC::Int, height : LibC::Int) : LibC::Int
    fun drawimage = gr3_drawimage(xmin : LibC::Float, xmax : LibC::Float, ymin : LibC::Float, ymax : LibC::Float, width : LibC::Int, height : LibC::Int, drawable_type : LibC::Int) : LibC::Int
    fun createmesh_nocopy = gr3_createmesh_nocopy(mesh : LibC::Int*, n : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*) : LibC::Int
    fun createmesh = gr3_createmesh(mesh : LibC::Int*, n : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*) : LibC::Int
    fun createindexedmesh_nocopy = gr3_createindexedmesh_nocopy(mesh : LibC::Int*, number_of_vertices : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*, number_of_indices : LibC::Int, indices : LibC::Int*) : LibC::Int
    fun createindexedmesh = gr3_createindexedmesh(mesh : LibC::Int*, number_of_vertices : LibC::Int, vertices : LibC::Float*, normals : LibC::Float*, colors : LibC::Float*, number_of_indices : LibC::Int, indices : LibC::Int*) : LibC::Int
    fun drawmesh = gr3_drawmesh(mesh : LibC::Int, n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, ups : LibC::Float*, colors : LibC::Float*, scales : LibC::Float*)
    fun deletemesh = gr3_deletemesh(mesh : LibC::Int)
    fun cameralookat = gr3_cameralookat(camera_x : LibC::Float, camera_y : LibC::Float, camera_z : LibC::Float, center_x : LibC::Float, center_y : LibC::Float, center_z : LibC::Float, up_x : LibC::Float, up_y : LibC::Float, up_z : LibC::Float)
    fun setcameraprojectionparameters = gr3_setcameraprojectionparameters(vertical_field_of_view : LibC::Float, z_near : LibC::Float, z_far : LibC::Float) : LibC::Int
    fun getcameraprojectionparameters = gr3_getcameraprojectionparameters(vfov : LibC::Float*, znear : LibC::Float*, zfar : LibC::Float*) : LibC::Int
    fun setlightdirection = gr3_setlightdirection(x : LibC::Float, y : LibC::Float, z : LibC::Float)
    fun setbackgroundcolor = gr3_setbackgroundcolor(red : LibC::Float, green : LibC::Float, blue : LibC::Float, alpha : LibC::Float)
    fun createheightmapmesh = gr3_createheightmapmesh(heightmap : LibC::Float*, num_columns : LibC::Int, num_rows : LibC::Int) : LibC::Int
    fun drawheightmap = gr3_drawheightmap(heightmap : LibC::Float*, num_columns : LibC::Int, num_rows : LibC::Int, positions : LibC::Float*, scales : LibC::Float*)
    fun drawconemesh = gr3_drawconemesh(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, lengths : LibC::Float*)
    fun drawcylindermesh = gr3_drawcylindermesh(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, lengths : LibC::Float*)
    fun drawspheremesh = gr3_drawspheremesh(n : LibC::Int, positions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*)
    fun drawcubemesh = gr3_drawcubemesh(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, ups : LibC::Float*, colors : LibC::Float*, scales : LibC::Float*)
    fun setobjectid = gr3_setobjectid(id : LibC::Int)
    fun selectid = gr3_selectid(x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int, selection_id : LibC::Int*) : LibC::Int
    fun getviewmatrix = gr3_getviewmatrix(m : LibC::Float*)
    fun setviewmatrix = gr3_setviewmatrix(m : LibC::Float*)
    fun getprojectiontype = gr3_getprojectiontype : LibC::Int
    fun setprojectiontype = gr3_setprojectiontype(type : LibC::Int)
    fun triangulate = gr3_triangulate(data : LibC::UShort*, isolevel : LibC::UShort, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double, triangles_p : TriangleT**) : LibC::UInt

    struct TriangleT
      vertex : CoordT[3]
      normal : CoordT[3]
    end

    struct CoordT
      x : LibC::Float
      y : LibC::Float
      z : LibC::Float
    end

    fun triangulateindexed = gr3_triangulateindexed(data : LibC::UShort*, isolevel : LibC::UShort, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double, num_vertices : LibC::UInt*, vertices : CoordT**, normals : CoordT**, num_indices : LibC::UInt*, indices : LibC::UInt**)
    fun createisosurfacemesh = gr3_createisosurfacemesh(mesh : LibC::Int*, data : LibC::UShort*, isolevel : LibC::UShort, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double) : LibC::Int
    fun createsurfacemesh = gr3_createsurfacemesh(mesh : LibC::Int*, nx : LibC::Int, ny : LibC::Int, px : LibC::Float*, py : LibC::Float*, pz : LibC::Float*, option : LibC::Int) : LibC::Int
    fun drawmesh_grlike = gr3_drawmesh_grlike(mesh : LibC::Int, n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, ups : LibC::Float*, colors : LibC::Float*, scales : LibC::Float*)
    fun drawsurface = gr3_drawsurface(mesh : LibC::Int)
    fun surface = gr3_surface(nx : LibC::Int, ny : LibC::Int, px : LibC::Float*, py : LibC::Float*, pz : LibC::Float*, option : LibC::Int)
    fun drawtubemesh = gr3_drawtubemesh(n : LibC::Int, points : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, num_steps : LibC::Int, num_segments : LibC::Int) : LibC::Int
    fun createtubemesh = gr3_createtubemesh(mesh : LibC::Int*, n : LibC::Int, points : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, num_steps : LibC::Int, num_segments : LibC::Int) : LibC::Int
    fun drawspins = gr3_drawspins(n : LibC::Int, positions : LibC::Float*, directions : LibC::Float*, colors : LibC::Float*, cone_radius : LibC::Float, cylinder_radius : LibC::Float, cone_height : LibC::Float, cylinder_height : LibC::Float)
    fun drawmolecule = gr3_drawmolecule(n : LibC::Int, positions : LibC::Float*, colors : LibC::Float*, radii : LibC::Float*, bond_radius : LibC::Float, bond_color : LibC::Float[3], bond_delta : LibC::Float)
    fun createxslicemesh = gr3_createxslicemesh(mesh : LibC::Int*, data : LibC::UShort*, ix : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun createyslicemesh = gr3_createyslicemesh(mesh : LibC::Int*, data : LibC::UShort*, iy : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun createzslicemesh = gr3_createzslicemesh(mesh : LibC::Int*, data : LibC::UShort*, iz : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun drawxslicemesh = gr3_drawxslicemesh(data : LibC::UShort*, ix : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun drawyslicemesh = gr3_drawyslicemesh(data : LibC::UShort*, iy : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun drawzslicemesh = gr3_drawzslicemesh(data : LibC::UShort*, iz : LibC::UInt, dim_x : LibC::UInt, dim_y : LibC::UInt, dim_z : LibC::UInt, stride_x : LibC::UInt, stride_y : LibC::UInt, stride_z : LibC::UInt, step_x : LibC::Double, step_y : LibC::Double, step_z : LibC::Double, offset_x : LibC::Double, offset_y : LibC::Double, offset_z : LibC::Double)
    fun drawtrianglesurface = gr3_drawtrianglesurface(n : LibC::Int, triangles : LibC::Float*)
    fun setorthographicprojection = gr3_setorthographicprojection(left : LibC::Float, right : LibC::Float, bottom : LibC::Float, top : LibC::Float, znear : LibC::Float, zfar : LibC::Float)
  end
end
