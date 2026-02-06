require "./gr_common/config.cr"
require "./gr/libgr"
require "./gr_common/utils"

module GR
  include GRCommon::Utils
  extend self

  def initgr
    LibGR.initgr
  end

  def opengks
    LibGR.opengks
  end

  def closegks
    LibGR.closegks
  end

  def updatews
    LibGR.updatews
  end

  def clearws
    LibGR.clearws
  end

  def inqdspsize
    mwidth = Pointer(Float64).malloc
    mheight = Pointer(Float64).malloc
    width = Pointer(Int32).malloc
    height = Pointer(Int32).malloc
    LibGR.inqdspsize(mwidth, mheight, width, height)
    {mwidth.value, mheight.value, width.value, height.value}
  end

  def openws(i0, c, i1)
    LibGR.openws(i0, to_cchar(c), i1)
  end

  def closews(i0)
    LibGR.closews(i0)
  end

  def polyline(x, y)
    n = ensure_same_length(x, y)
    LibGR.polyline(n, float64(x), float64(y))
  end

  def polymarker(x, y)
    n = ensure_same_length(x, y)
    LibGR.polymarker(n, float64(x), float64(y))
  end

  def fillarea(x, y)
    n = ensure_same_length(x, y)
    LibGR.fillarea(n, float64(x), float64(y))
  end

  def cellarray(xmin, xmax, ymin, ymax, dimx, dimy, color)
    LibGR.cellarray(xmin, xmax, ymin, ymax, dimx, dimy, 1, 1, dimx, dimy, int32_color(color))
  end

  def nonuniformcellarray(x, y, dimx, dimy, color)
    if x.size < dimx || x.size > dimx + 1 || y.size < dimy || y.size > dimy + 1
      raise ArgumentError.new("size mismatch")
    end

    dx = (dimx == x.size ? -dimx : dimx)
    dy = (dimy == y.size ? -dimy : dimy)
    LibGR.nonuniformcellarray(float64(x), float64(y), dx, dy, 1, 1, dimx, dimy, int32_color(color))
  end

  def polarcellarray(x_org, y_org, phimin, phimax, rmin, rmax, dimphi, dimr, color)
    LibGR.polarcellarray(x_org, y_org, phimin, phimax, rmin, rmax, dimphi, dimr, 1, 1, dimphi, dimr, int32_color(color))
  end

  def nonuniformpolarcellarray(phi, r, dimphi, dimr, color)
    if phi.size < dimphi || phi.size > dimphi + 1 || r.size < dimr || r.size > dimr + 1
      raise ArgumentError.new("size mismatch")
    end

    dphi = (dimphi == phi.size ? -dimphi : dimphi)
    dr = (dimr == r.size ? -dimr : dimr)
    LibGR.nonuniformpolarcellarray(0, 0, float64(phi), float64(r), dphi, dr, 1, 1, dimphi, dimr, int32_color(color))
  end

  def text(x, x1, c)
    LibGR.text(x, x1, to_cchar(c))
  end

  def textx(x, y, c, opts)
    LibGR.textx(x, y, to_cchar(c), opts)
  end

  def inqtext(x, y, c)
    tbx = Pointer(Float64).malloc(4)
    tby = Pointer(Float64).malloc(4)
    LibGR.inqtext(x, y, to_cchar(c), tbx, tby)
    {Array(Float64).new(4) { |i| tbx[i] }, Array(Float64).new(4) { |i| tby[i] }}
  end

  def inqtextx(x, y, c, opts)
    tbx = Pointer(Float64).malloc(4)
    tby = Pointer(Float64).malloc(4)
    LibGR.inqtextx(x, y, to_cchar(c), opts, tbx, tby)
    {Array(Float64).new(4) { |i| tbx[i] }, Array(Float64).new(4) { |i| tby[i] }}
  end

  def mathtex(x, x1, c)
    LibGR.mathtex(x, x1, to_cchar(c))
  end

  def textext(x, x1, c)
    LibGR.textext(x, x1, to_cchar(c))
  end

  def inqtextext(x, y, c)
    tbx = Pointer(Float64).malloc(4)
    tby = Pointer(Float64).malloc(4)
    LibGR.inqtextext(x, y, to_cchar(c), tbx, tby)
    {Array(Float64).new(4) { |i| tbx[i] }, Array(Float64).new(4) { |i| tby[i] }}
  end

  def surface(xa, xb, xc, i2)
    expected = xa.size * xb.size
    raise ArgumentError.new("size mismatch") unless xc.size == expected
    LibGR.surface(xa.size, xb.size, float64(xa), float64(xb), float64(xc), i2)
  end

  def contour(xa, xb, xc, xd, i4)
    expected = xa.size * xb.size
    raise ArgumentError.new("size mismatch") unless xd.size == expected
    LibGR.contour(xa.size, xb.size, xc.size, float64(xa), float64(xb),
      float64(xc), float64(xd), i4)
  end

  def contourf(xa, xb, xc, xd, i4)
    expected = xa.size * xb.size
    raise ArgumentError.new("size mismatch") unless xd.size == expected
    LibGR.contourf(xa.size, xb.size, xc.size, float64(xa), float64(xb),
      float64(xc), float64(xd), i4)
  end

  def polyline3d(xa, xb, xc)
    n = ensure_same_length(xa, xb, xc)
    LibGR.polyline3d(n, float64(xa), float64(xb), float64(xc))
  end

  def polymarker3d(xa, xb, xc)
    n = ensure_same_length(xa, xb, xc)
    LibGR.polymarker3d(n, float64(xa), float64(xb), float64(xc))
  end

  def axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
    LibGR.axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
  end

  def titles3d(c, c0, c1)
    LibGR.titles3d(to_cchar(c), to_cchar(c0), to_cchar(c1))
  end

  def verrorbars(xa, xb, xc, xd)
    n = ensure_same_length(xa, xb, xc, xd)
    LibGR.verrorbars(n, float64(xa), float64(xb), float64(xc), float64(xd))
  end

  def herrorbars(xa, xb, xc, xd)
    n = ensure_same_length(xa, xb, xc, xd)
    LibGR.herrorbars(n, float64(xa), float64(xb), float64(xc), float64(xd))
  end

  def hexbin(x, y, nbins)
    n = ensure_same_length(x, y)
    LibGR.hexbin(n, float64(x), float64(y), nbins)
  end

  def gdp(x, y, primid, datrec)
    n = ensure_same_length(x, y)
    LibGR.gdp(n, float64(x), float64(y), primid, datrec.size, int32(datrec))
  end

  def spline(x, y, i1, i2)
    n = ensure_same_length(x, y)
    LibGR.spline(n, float64(x), float64(y), i1, i2)
  end

  def gridit(xd, yd, zd, nx, ny)
    n = ensure_same_length(xd, yd, zd)
    x_ptr = Pointer(Float64).malloc(nx)
    y_ptr = Pointer(Float64).malloc(ny)
    z_ptr = Pointer(Float64).malloc(nx * ny)
    LibGR.gridit(n, float64(xd), float64(yd), float64(zd), nx, ny, x_ptr, y_ptr, z_ptr)
    x = Array(Float64).new(nx) { |i| x_ptr[i] }
    y = Array(Float64).new(ny) { |i| y_ptr[i] }
    z = Array(Float64).new(nx * ny) { |i| z_ptr[i] }
    {x, y, z}
  end

  def path(x, y, codes)
    n = ensure_same_length(x, y)
    LibGR.path(n, float64(x), float64(y), to_cchar(codes))
  end

  def version
    String.new(LibGR.version)
  end
end
