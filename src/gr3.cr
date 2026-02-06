require "./gr_common/config.cr"
require "./gr_common/exceptions"
require "./gr3/libgr3"
require "./gr_common/utils"

module GR3
  include GRCommon::Utils
  extend self

  ERROR_MUTEX = Mutex.new

  class Error < GRCommon::GRError
  end

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

  ERROR_MESSAGES = [
    "none",
    "invalid value",
    "invalid attribute",
    "init failed",
    "OpenGL error",
    "out of memory",
    "not initialized",
    "camera not initialized",
    "unknown file extension",
    "cannot open file",
    "export failed",
  ]

  def check_error!(clear = 1)
    line = uninitialized Int32
    file = Pointer(LibC::Char).null
    error_code = LibGR3.geterror(clear, pointerof(line), pointerof(file))
    return if error_code == 0

    file_name = file.null? ? "unknown" : String.new(file)
    message = error_message(error_code)
    raise Error.new("GR3 error (#{file_name}, l. #{line}): #{message}")
  end

  def with_error_check(&)
    ERROR_MUTEX.synchronize do
      result = yield
      check_error!
      result
    end
  end

  def init(attrib_list = nil)
    with_error_check do
      if attrib_list
        LibGR3.init(attrib_list)
      else
        LibGR3.init(nil)
      end
    end
  end

  def terminate
    with_error_check { LibGR3.terminate }
  end

  def free(pointer)
    with_error_check { LibGR3.free(pointer) }
  end

  def geterror(clear, line, file)
    LibGR3.geterror(clear, line, file)
  end

  def geterrorstring(error)
    String.new(LibGR3.geterrorstring(error))
  end

  def getrenderpathstring
    with_error_check { String.new(LibGR3.getrenderpathstring) }
  end

  def setlogcallback(log_func)
    with_error_check { LibGR3.setlogcallback(log_func) }
  end

  def clear
    with_error_check { LibGR3.clear }
  end

  def usecurrentframebuffer
    with_error_check { LibGR3.usecurrentframebuffer }
  end

  def useframebuffer(framebuffer)
    with_error_check { LibGR3.useframebuffer(framebuffer) }
  end

  def getimage(width, height, use_alpha, pixels)
    with_error_check { LibGR3.getimage(width, height, use_alpha, pixels) }
  end

  def getimage(width, height, use_alpha = true)
    bpp = use_alpha ? 4 : 3
    pixels = Bytes.new(width * height * bpp)
    with_error_check { LibGR3.getimage(width, height, use_alpha ? 1 : 0, pixels.to_unsafe) }
    pixels
  end

  def drawimage(xmin, xmax, ymin, ymax, width, height, drawable_type)
    with_error_check { LibGR3.drawimage(xmin, xmax, ymin, ymax, width, height, drawable_type) }
  end

  def createmesh_nocopy(n, vertices, normals, colors)
    mesh_ptr = uninitialized Int32
    with_error_check { LibGR3.createmesh_nocopy(pointerof(mesh_ptr), n, vertices, normals, colors) }
    mesh_ptr
  end

  def createmesh(n, vertices, normals, colors)
    mesh_ptr = uninitialized Int32
    with_error_check { LibGR3.createmesh(pointerof(mesh_ptr), n, vertices, normals, colors) }
    mesh_ptr
  end

  def createindexedmesh(number_of_vertices, vertices, normals, colors,
                        number_of_indices, indices)
    mesh_ptr = uninitialized Int32
    with_error_check do
      LibGR3.createindexedmesh(pointerof(mesh_ptr), number_of_vertices, vertices,
        normals, colors, number_of_indices, indices)
    end
    mesh_ptr
  end

  def createindexedmesh_nocopy(number_of_vertices, vertices, normals, colors,
                               number_of_indices, indices)
    mesh_ptr = uninitialized Int32
    with_error_check do
      LibGR3.createindexedmesh_nocopy(pointerof(mesh_ptr), number_of_vertices, vertices,
        normals, colors, number_of_indices, indices)
    end
    mesh_ptr
  end

  def drawmesh(mesh, n, positions, directions, ups, colors, scales)
    with_error_check { LibGR3.drawmesh(mesh, n, positions, directions, ups, colors, scales) }
  end

  def drawmesh_grlike(mesh, n, positions, directions, ups, colors, scales)
    with_error_check { LibGR3.drawmesh_grlike(mesh, n, positions, directions, ups, colors, scales) }
  end

  def deletemesh(mesh)
    with_error_check { LibGR3.deletemesh(mesh) }
  end

  def drawconemesh(n, positions, directions, colors, radii, lengths)
    with_error_check { LibGR3.drawconemesh(n, positions, directions, colors, radii, lengths) }
  end

  def drawcylindermesh(n, positions, directions, colors, radii, lengths)
    with_error_check { LibGR3.drawcylindermesh(n, positions, directions, colors, radii, lengths) }
  end

  def drawspheremesh(n, positions, colors, radii)
    with_error_check { LibGR3.drawspheremesh(n, positions, colors, radii) }
  end

  def drawcubemesh(n, positions, directions, ups, colors, scales)
    with_error_check { LibGR3.drawcubemesh(n, positions, directions, ups, colors, scales) }
  end

  def cameralookat(camera_x, camera_y, camera_z, center_x, center_y, center_z,
                   up_x, up_y, up_z)
    with_error_check do
      LibGR3.cameralookat(camera_x, camera_y, camera_z, center_x, center_y, center_z,
        up_x, up_y, up_z)
    end
  end

  def setcameraprojectionparameters(vertical_field_of_view, znear, zfar)
    with_error_check { LibGR3.setcameraprojectionparameters(vertical_field_of_view, znear, zfar) }
  end

  def getcameraprojectionparameters(vfov, znear, zfar)
    with_error_check { LibGR3.getcameraprojectionparameters(vfov, znear, zfar) }
  end

  def setlightdirection(x, y, z)
    with_error_check { LibGR3.setlightdirection(x, y, z) }
  end

  def setbackgroundcolor(red, green, blue, alpha)
    with_error_check { LibGR3.setbackgroundcolor(red, green, blue, alpha) }
  end

  def getlightsources(max_num_lights, positions, colors)
    with_error_check { LibGR3.getlightsources(max_num_lights, positions, colors) }
  end

  def setlightsources(num_lights, positions, colors)
    with_error_check { LibGR3.setlightsources(num_lights, positions, colors) }
  end

  def setlightparameters(ambient, diffuse, specular, specular_power)
    with_error_check { LibGR3.setlightparameters(ambient, diffuse, specular, specular_power) }
  end

  def getlightparameters(ambient, diffuse, specular, specular_power)
    with_error_check { LibGR3.getlightparameters(ambient, diffuse, specular, specular_power) }
  end

  def setdefaultlightparameters
    with_error_check { LibGR3.setdefaultlightparameters }
  end

  def setquality(quality)
    with_error_check { LibGR3.setquality(quality) }
  end

  def export(filename, width, height)
    with_error_check { LibGR3.export(filename, width, height) }
  end

  def save(filename, width, height)
    export(filename, width, height)
    ext = File.extname(filename).downcase
    case ext
    when ".png"
      File.read(filename).to_slice
    when ".html"
      "<iframe src=\"files/#{filename}\" width=#{width} height=#{height}></iframe>"
    else
      nil
    end
  end

  def setobjectid(id)
    with_error_check { LibGR3.setobjectid(id) }
  end

  def selectid(x, y, width, height, selection_id)
    with_error_check { LibGR3.selectid(x, y, width, height, selection_id) }
  end

  def getprojectiontype
    with_error_check { LibGR3.getprojectiontype }
  end

  def setprojectiontype(type)
    with_error_check { LibGR3.setprojectiontype(type) }
  end

  def setorthographicprojection(left, right, bottom, top, znear, zfar)
    with_error_check { LibGR3.setorthographicprojection(left, right, bottom, top, znear, zfar) }
  end

  def getviewmatrix(m)
    with_error_check { LibGR3.getviewmatrix(m) }
  end

  def setviewmatrix(m)
    with_error_check { LibGR3.setviewmatrix(m) }
  end

  def createheightmapmesh(heightmap, num_columns, num_rows)
    with_error_check { LibGR3.createheightmapmesh(heightmap, num_columns, num_rows) }
  end

  def drawheightmap(heightmap, num_columns, num_rows, positions, scales)
    with_error_check { LibGR3.drawheightmap(heightmap, num_columns, num_rows, positions, scales) }
  end

  def createsurfacemesh(nx, ny, px, py, pz, option)
    mesh_ptr = uninitialized Int32
    with_error_check { LibGR3.createsurfacemesh(pointerof(mesh_ptr), nx, ny, px, py, pz, option) }
    mesh_ptr
  end

  def createsurface3dmesh(ncols, nrows, px, py, pz)
    mesh_ptr = uninitialized Int32
    with_error_check { LibGR3.createsurface3dmesh(pointerof(mesh_ptr), ncols, nrows, px, py, pz) }
    mesh_ptr
  end

  def drawsurface(mesh)
    with_error_check { LibGR3.drawsurface(mesh) }
  end

  def surface(nx, ny, px, py, pz, option)
    with_error_check { LibGR3.surface(nx, ny, px, py, pz, option) }
  end

  def setsurfaceoption(option)
    with_error_check { LibGR3.setsurfaceoption(option) }
  end

  def getsurfaceoption
    with_error_check { LibGR3.getsurfaceoption }
  end

  def triangulate(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
                  stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
                  triangles_p)
    with_error_check do
      LibGR3.triangulate(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
        stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
        triangles_p)
    end
  end

  def triangulateindexed(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
                         stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
                         num_vertices, vertices, normals, num_indices, indices)
    with_error_check do
      LibGR3.triangulateindexed(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
        stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
        num_vertices, vertices, normals, num_indices, indices)
    end
  end

  def createisosurfacemesh(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
                           stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    with_error_check do
      LibGR3.createisosurfacemesh(pointerof(mesh_ptr), data, isolevel, dim_x, dim_y, dim_z,
        stride_x, stride_y, stride_z, step_x, step_y, step_z,
        offset_x, offset_y, offset_z)
    end
    mesh_ptr
  end

  def isosurface(nx, ny, nz, data, isovalue, color, strides)
    with_error_check { LibGR3.isosurface(nx, ny, nz, data, isovalue, color, strides) }
  end

  def createxslicemesh(data, ix, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                       step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    with_error_check do
      LibGR3.createxslicemesh(pointerof(mesh_ptr), data, ix, dim_x, dim_y, dim_z, stride_x,
        stride_y, stride_z, step_x, step_y, step_z, offset_x, offset_y,
        offset_z)
    end
    mesh_ptr
  end

  def createyslicemesh(data, iy, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                       step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    with_error_check do
      LibGR3.createyslicemesh(pointerof(mesh_ptr), data, iy, dim_x, dim_y, dim_z, stride_x,
        stride_y, stride_z, step_x, step_y, step_z, offset_x, offset_y,
        offset_z)
    end
    mesh_ptr
  end

  def createzslicemesh(data, iz, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                       step_x, step_y, step_z, offset_x, offset_y, offset_z)
    mesh_ptr = uninitialized Int32
    with_error_check do
      LibGR3.createzslicemesh(pointerof(mesh_ptr), data, iz, dim_x, dim_y, dim_z, stride_x,
        stride_y, stride_z, step_x, step_y, step_z, offset_x, offset_y,
        offset_z)
    end
    mesh_ptr
  end

  def drawxslicemesh(data, ix, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                     step_x, step_y, step_z, offset_x, offset_y, offset_z)
    with_error_check do
      LibGR3.drawxslicemesh(data, ix, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
        step_x, step_y, step_z, offset_x, offset_y, offset_z)
    end
  end

  def drawyslicemesh(data, iy, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                     step_x, step_y, step_z, offset_x, offset_y, offset_z)
    with_error_check do
      LibGR3.drawyslicemesh(data, iy, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
        step_x, step_y, step_z, offset_x, offset_y, offset_z)
    end
  end

  def drawzslicemesh(data, iz, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
                     step_x, step_y, step_z, offset_x, offset_y, offset_z)
    with_error_check do
      LibGR3.drawzslicemesh(data, iz, dim_x, dim_y, dim_z, stride_x, stride_y, stride_z,
        step_x, step_y, step_z, offset_x, offset_y, offset_z)
    end
  end

  def drawtubemesh(n, points, colors, radii, num_steps, num_segments)
    with_error_check { LibGR3.drawtubemesh(n, points, colors, radii, num_steps, num_segments) }
  end

  def createtubemesh(n, points, colors, radii, num_steps, num_segments)
    mesh_ptr = uninitialized Int32
    with_error_check { LibGR3.createtubemesh(pointerof(mesh_ptr), n, points, colors, radii, num_steps, num_segments) }
    mesh_ptr
  end

  def drawspins(n, positions, directions, colors, cone_radius, cylinder_radius,
                cone_height, cylinder_height)
    with_error_check do
      LibGR3.drawspins(n, positions, directions, colors, cone_radius, cylinder_radius,
        cone_height, cylinder_height)
    end
  end

  def drawmolecule(n, positions, colors, radii, bond_radius, bond_color, bond_delta)
    with_error_check { LibGR3.drawmolecule(n, positions, colors, radii, bond_radius, bond_color, bond_delta) }
  end

  def drawtrianglesurface(n, triangles)
    with_error_check { LibGR3.drawtrianglesurface(n, triangles) }
  end

  def volume(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr)
    with_error_check { LibGR3.volume(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr) }
  end

  def volume_2pass(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr, context)
    with_error_check { LibGR3.volume_2pass(nx, ny, nz, data, algorithm, dmin_ptr, dmax_ptr, context) }
  end

  def getalphamode(mode)
    with_error_check { LibGR3.getalphamode(mode) }
  end

  def setalphamode(mode)
    with_error_check { LibGR3.setalphamode(mode) }
  end

  def setclipping(xmin, xmax, ymin, ymax, zmin, zmax)
    with_error_check { LibGR3.setclipping(xmin, xmax, ymin, ymax, zmin, zmax) }
  end

  def getclipping(xmin, xmax, ymin, ymax, zmin, zmax)
    with_error_check { LibGR3.getclipping(xmin, xmax, ymin, ymax, zmin, zmax) }
  end

  private def error_message(error_code)
    begin
      ptr = LibGR3.geterrorstring(error_code)
      return String.new(ptr) unless ptr.null?
    rescue
    end

    if error_code >= 0 && error_code < ERROR_MESSAGES.size
      ERROR_MESSAGES[error_code]
    else
      "unknown error"
    end
  end
end
