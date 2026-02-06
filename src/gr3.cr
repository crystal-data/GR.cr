require "./gr_common/config.cr"
require "./gr3/libgr3"
require "./gr_common/utils"

module GR3
  include GRCommon::Utils
  extend self
  IA_END_OF_LIST        = 0
  IA_FRAMEBUFFER_WIDTH  = 1
  IA_FRAMEBUFFER_HEIGHT = 2
  IA_NUM_THREADS        = 3

  ERROR_NONE                   =  0
  ERROR_INVALID_VALUE          =  1
  ERROR_INVALID_ATTRIBUTE      =  2
  ERROR_INIT_FAILED            =  3
  ERROR_OPENGL_ERR             =  4
  ERROR_OUT_OF_MEM             =  5
  ERROR_NOT_INITIALIZED        =  6
  ERROR_CAMERA_NOT_INITIALIZED =  7
  ERROR_UNKNOWN_FILE_EXTENSION =  8
  ERROR_CANNOT_OPEN_FILE       =  9
  ERROR_EXPORT                 = 10

  QUALITY_OPENGL_NO_SSAA  =  0
  QUALITY_OPENGL_2X_SSAA  =  2
  QUALITY_OPENGL_4X_SSAA  =  4
  QUALITY_OPENGL_8X_SSAA  =  8
  QUALITY_OPENGL_16X_SSAA = 16
  QUALITY_POVRAY_NO_SSAA  =  1
  QUALITY_POVRAY_2X_SSAA  =  3
  QUALITY_POVRAY_4X_SSAA  =  5
  QUALITY_POVRAY_8X_SSAA  =  9
  QUALITY_POVRAY_16X_SSAA = 17

  DRAWABLE_OPENGL = 1
  DRAWABLE_GKS    = 2

  SURFACE_DEFAULT     =  0
  SURFACE_NORMALS     =  1
  SURFACE_FLAT        =  2
  SURFACE_GRTRANSFORM =  4
  SURFACE_GRCOLOR     =  8
  SURFACE_GRZSHADED   = 16

  def init(attrib_list = nil)
    if attrib_list
      LibGR3.init(attrib_list)
    else
      LibGR3.init(nil)
    end
  end

  def terminate
    LibGR3.terminate
  end

  def free(pointer)
    LibGR3.free(pointer)
  end

  def geterror(clear, line, file)
    LibGR3.geterror(clear, line, file)
  end

  def geterrorstring(error)
    String.new(LibGR3.geterrorstring(error))
  end

  def getrenderpathstring
    String.new(LibGR3.getrenderpathstring)
  end

  def setlogcallback(log_func)
    LibGR3.setlogcallback(log_func)
  end

  def clear
    LibGR3.clear
  end

  def usecurrentframebuffer
    LibGR3.usecurrentframebuffer
  end

  def useframebuffer(framebuffer)
    LibGR3.useframebuffer(framebuffer)
  end

  def getimage(width, height, use_alpha, pixels)
    LibGR3.getimage(width, height, use_alpha, pixels)
  end

  def getimage(width, height, use_alpha = true)
    bpp = use_alpha ? 4 : 3
    pixels = Bytes.new(width * height * bpp)
    LibGR3.getimage(width, height, use_alpha ? 1 : 0, pixels.to_unsafe)
    pixels
  end

  def drawimage(xmin, xmax, ymin, ymax, width, height, drawable_type)
    LibGR3.drawimage(xmin, xmax, ymin, ymax, width, height, drawable_type)
  end

  def createmesh_nocopy(n, vertices, normals, colors)
    mesh_ptr = uninitialized Int32
    LibGR3.createmesh_nocopy(pointerof(mesh_ptr), n, vertices, normals, colors)
    mesh_ptr
  end

  def createmesh(n, vertices, normals, colors)
    mesh_ptr = uninitialized Int32
    LibGR3.createmesh(pointerof(mesh_ptr), n, vertices, normals, colors)
    mesh_ptr
  end

  def createindexedmesh(number_of_vertices, vertices, normals, colors,
                        number_of_indices, indices)
    mesh_ptr = uninitialized Int32
    LibGR3.createindexedmesh(pointerof(mesh_ptr), number_of_vertices, vertices,
      normals, colors, number_of_indices, indices)
    mesh_ptr
  end

  def createindexedmesh_nocopy(number_of_vertices, vertices, normals, colors,
                               number_of_indices, indices)
    mesh_ptr = uninitialized Int32
    LibGR3.createindexedmesh_nocopy(pointerof(mesh_ptr), number_of_vertices, vertices,
      normals, colors, number_of_indices, indices)
    mesh_ptr
  end

  def drawmesh(mesh, n, positions, directions, ups, colors, scales)
    LibGR3.drawmesh(mesh, n, positions, directions, ups, colors, scales)
  end

  def drawmesh_grlike(mesh, n, positions, directions, ups, colors, scales)
    LibGR3.drawmesh_grlike(mesh, n, positions, directions, ups, colors, scales)
  end

  def deletemesh(mesh)
    LibGR3.deletemesh(mesh)
  end

  def drawconemesh(n, positions, directions, colors, radii, lengths)
    LibGR3.drawconemesh(n, positions, directions, colors, radii, lengths)
  end

  def drawcylindermesh(n, positions, directions, colors, radii, lengths)
    LibGR3.drawcylindermesh(n, positions, directions, colors, radii, lengths)
  end

  def drawspheremesh(n, positions, colors, radii)
    LibGR3.drawspheremesh(n, positions, colors, radii)
  end

  def drawcubemesh(n, positions, directions, ups, colors, scales)
    LibGR3.drawcubemesh(n, positions, directions, ups, colors, scales)
  end

  def cameralookat(camera_x, camera_y, camera_z, center_x, center_y, center_z,
                   up_x, up_y, up_z)
    LibGR3.cameralookat(camera_x, camera_y, camera_z, center_x, center_y, center_z,
      up_x, up_y, up_z)
  end

  def setcameraprojectionparameters(vertical_field_of_view, znear, zfar)
    LibGR3.setcameraprojectionparameters(vertical_field_of_view, znear, zfar)
  end

  def getcameraprojectionparameters(vfov, znear, zfar)
    LibGR3.getcameraprojectionparameters(vfov, znear, zfar)
  end

  def setlightdirection(x, y, z)
    LibGR3.setlightdirection(x, y, z)
  end

  def setbackgroundcolor(red, green, blue, alpha)
    LibGR3.setbackgroundcolor(red, green, blue, alpha)
  end

  def getlightsources(max_num_lights, positions, colors)
    LibGR3.getlightsources(max_num_lights, positions, colors)
  end

  def setlightsources(num_lights, positions, colors)
    LibGR3.setlightsources(num_lights, positions, colors)
  end

  def setlightparameters(ambient, diffuse, specular, specular_power)
    LibGR3.setlightparameters(ambient, diffuse, specular, specular_power)
  end

  def getlightparameters(ambient, diffuse, specular, specular_power)
    LibGR3.getlightparameters(ambient, diffuse, specular, specular_power)
  end

  def setdefaultlightparameters
    LibGR3.setdefaultlightparameters
  end

  def setquality(quality)
    LibGR3.setquality(quality)
  end

  def export(filename, width, height)
    LibGR3.export(filename, width, height)
  end

  def setobjectid(id)
    LibGR3.setobjectid(id)
  end

  def selectid(x, y, width, height, selection_id)
    LibGR3.selectid(x, y, width, height, selection_id)
  end

  def getprojectiontype
    LibGR3.getprojectiontype
  end

  def setprojectiontype(type)
    LibGR3.setprojectiontype(type)
  end

  def setorthographicprojection(left, right, bottom, top, znear, zfar)
    LibGR3.setorthographicprojection(left, right, bottom, top, znear, zfar)
  end

  def getviewmatrix(m)
    LibGR3.getviewmatrix(m)
  end

  def setviewmatrix(m)
    LibGR3.setviewmatrix(m)
  end

  def createheightmapmesh(heightmap, num_columns, num_rows)
    LibGR3.createheightmapmesh(heightmap, num_columns, num_rows)
  end

  def drawheightmap(heightmap, num_columns, num_rows, positions, scales)
    LibGR3.drawheightmap(heightmap, num_columns, num_rows, positions, scales)
  end

  def createsurfacemesh(nx, ny, px, py, pz, option)
    mesh_ptr = uninitialized Int32
    LibGR3.createsurfacemesh(pointerof(mesh_ptr), nx, ny, px, py, pz, option)
    mesh_ptr
  end

  def createsurface3dmesh(ncols, nrows, px, py, pz)
    mesh_ptr = uninitialized Int32
    LibGR3.createsurface3dmesh(pointerof(mesh_ptr), ncols, nrows, px, py, pz)
    mesh_ptr
  end

  def drawsurface(mesh)
    LibGR3.drawsurface(mesh)
  end

  def surface(nx, ny, px, py, pz, option)
    LibGR3.surface(nx, ny, px, py, pz, option)
  end

  def setsurfaceoption(option)
    LibGR3.setsurfaceoption(option)
  end

  def getsurfaceoption
    LibGR3.getsurfaceoption
  end

  def triangulate(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
                  stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
                  triangles_p)
    LibGR3.triangulate(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
      stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
      triangles_p)
  end

  def triangulateindexed(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
                         stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
                         num_vertices, vertices, normals, num_indices, indices)
    LibGR3.triangulateindexed(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
      stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
      num_vertices, vertices, normals, num_indices, indices)
  end

  def createisosurfacemesh(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
                           stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    LibGR3.createisosurfacemesh(pointerof(mesh_ptr), data, isolevel, dim_x, dim_y, dim_z,
      stride_x, stride_y, stride_z, step_x, step_y, step_z,
      offset_x, offset_y, offset_z)
    mesh_ptr
  end

  def isosurface(nx, ny, nz, data, isovalue, color, strides)
    LibGR3.isosurface(nx, ny, nz, data, isovalue, color, strides)
  end

  def createxslicemesh(data, ix, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                       step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    LibGR3.createxslicemesh(pointerof(mesh_ptr), data, ix, dim_x, dim_y, dim_z, stride_x,
      stride_y, stride_z, step_x, step_y, step_z, offset_x, offset_y,
      offset_z)
    mesh_ptr
  end

  def createyslicemesh(data, iy, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                       step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    LibGR3.createyslicemesh(pointerof(mesh_ptr), data, iy, dim_x, dim_y, dim_z, stride_x,
      stride_y, stride_z, step_x, step_y, step_z, offset_x, offset_y,
      offset_z)
    mesh_ptr
  end

  def createzslicemesh(data, iz, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                       step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    LibGR3.createzslicemesh(pointerof(mesh_ptr), data, iz, dim_x, dim_y, dim_z, stride_x,
      stride_y, stride_z, step_x, step_y, step_z, offset_x, offset_y,
      offset_z)
    mesh_ptr
  end

  def drawxslicemesh(data, ix, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                     step_x, step_y, step_z, offset_x, offset_y, offset_z)
    LibGR3.drawxslicemesh(data, ix, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
      step_x, step_y, step_z, offset_x, offset_y, offset_z)
  end

  def drawyslicemesh(data, iy, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                     step_x, step_y, step_z, offset_x, offset_y, offset_z)
    LibGR3.drawyslicemesh(data, iy, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
      step_x, step_y, step_z, offset_x, offset_y, offset_z)
  end

  def drawzslicemesh(data, iz, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                     step_x, step_y, step_z, offset_x, offset_y, offset_z)
    LibGR3.drawzslicemesh(data, iz, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
      step_x, step_y, step_z, offset_x, offset_y, offset_z)
  end

  def drawtubemesh(n, points, colors, radii, num_steps, num_segments)
    LibGR3.drawtubemesh(n, points, colors, radii, num_steps, num_segments)
  end

  def createtubemesh(n, points, colors, radii, num_steps, num_segments)
    mesh_ptr = uninitialized Int32
    LibGR3.createtubemesh(pointerof(mesh_ptr), n, points, colors, radii, num_steps, num_segments)
    mesh_ptr
  end

  def drawspins(n, positions, directions, colors, cone_radius, cylinder_radius,
                cone_height, cylinder_height)
    LibGR3.drawspins(n, positions, directions, colors, cone_radius, cylinder_radius,
      cone_height, cylinder_height)
  end

  def drawmolecule(n, positions, colors, radii, bond_radius, bond_color, bond_delta)
    LibGR3.drawmolecule(n, positions, colors, radii, bond_radius, bond_color, bond_delta)
  end

  def drawtrianglesurface(n, triangles)
    LibGR3.drawtrianglesurface(n, triangles)
  end

  def volume(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr)
    LibGR3.volume(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr)
  end

  def volume_2pass(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr, context)
    LibGR3.volume_2pass(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr, context)
  end

  def getalphamode(mode)
    LibGR3.getalphamode(mode)
  end

  def setalphamode(mode)
    LibGR3.setalphamode(mode)
  end

  def setclipping(xmin, xmax, ymin, ymax, zmin, zmax)
    LibGR3.setclipping(xmin, xmax, ymin, ymax, zmin, zmax)
  end

  def getclipping(xmin, xmax, ymin, ymax, zmin, zmax)
    LibGR3.getclipping(xmin, xmax, ymin, ymax, zmin, zmax)
  end
end
