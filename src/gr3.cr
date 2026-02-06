require "./gr_common/config.cr"
require "./gr3/libgr3"
require "./gr_common/utils"

module GR3
  include GRCommon::Utils
  extend self

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

  def drawmesh(mesh, n, positions, directions, ups, colors, scales)
    LibGR3.drawmesh(mesh, n, positions, directions, ups, colors, scales)
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

  def drawsurface(mesh)
    LibGR3.drawsurface(mesh)
  end

  def triangulate(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y, 
                 stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
                 triangles_p)
    LibGR3.triangulate(data, isolevel, dim_x, dim_y, dim_z, stride_x, stride_y,
                     stride_z, step_x, step_y, step_z, offset_x, offset_y, offset_z,
                     triangles_p)
  end
end
