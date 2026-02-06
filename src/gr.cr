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

  def activatews(i0)
    LibGR.activatews(i0)
  end

  def deactivatews(i0)
    LibGR.deactivatews(i0)
  end

  def configurews
    LibGR.configurews
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

  def setlinetype(type)
    LibGR.setlinetype(type)
  end

  def inqlinetype
    type = Pointer(Int32).malloc
    LibGR.inqlinetype(type)
    type.value
  end

  def setlinewidth(width)
    LibGR.setlinewidth(width)
  end

  def inqlinewidth
    width = Pointer(Float64).malloc
    LibGR.inqlinewidth(width)
    width.value
  end

  def setlinecolorind(color)
    LibGR.setlinecolorind(color)
  end

  def inqlinecolorind
    color = Pointer(Int32).malloc
    LibGR.inqlinecolorind(color)
    color.value
  end

  def setmarkertype(type)
    LibGR.setmarkertype(type)
  end

  def inqmarkertype
    type = Pointer(Int32).malloc
    LibGR.inqmarkertype(type)
    type.value
  end

  def setmarkersize(size)
    LibGR.setmarkersize(size)
  end

  def inqmarkersize
    size = Pointer(Float64).malloc
    LibGR.inqmarkersize(size)
    size.value
  end

  def setmarkercolorind(color)
    LibGR.setmarkercolorind(color)
  end

  def inqmarkercolorind
    color = Pointer(Int32).malloc
    LibGR.inqmarkercolorind(color)
    color.value
  end

  def settextfontprec(font, precision)
    LibGR.settextfontprec(font, precision)
  end

  def setcharexpan(factor)
    LibGR.setcharexpan(factor)
  end

  def setcharspace(spacing)
    LibGR.setcharspace(spacing)
  end

  def settextcolorind(color)
    LibGR.settextcolorind(color)
  end

  def inqtextcolorind
    color = Pointer(Int32).malloc
    LibGR.inqtextcolorind(color)
    color.value
  end

  def setcharheight(height)
    LibGR.setcharheight(height)
  end

  def setwscharheight(chh, height)
    LibGR.setwscharheight(chh, height)
  end

  def inqcharheight
    height = Pointer(Float64).malloc
    LibGR.inqcharheight(height)
    height.value
  end

  def setcharup(ux, uy)
    LibGR.setcharup(ux, uy)
  end

  def settextpath(path)
    LibGR.settextpath(path)
  end

  def settextalign(horizontal, vertical)
    LibGR.settextalign(horizontal, vertical)
  end

  def setfillintstyle(style)
    LibGR.setfillintstyle(style)
  end

  def inqfillintstyle
    style = Pointer(Int32).malloc
    LibGR.inqfillintstyle(style)
    style.value
  end

  def setfillstyle(index)
    LibGR.setfillstyle(index)
  end

  def inqfillstyle
    index = Pointer(Int32).malloc
    LibGR.inqfillstyle(index)
    index.value
  end

  def setfillcolorind(color)
    LibGR.setfillcolorind(color)
  end

  def inqfillcolorind
    color = Pointer(Int32).malloc
    LibGR.inqfillcolorind(color)
    color.value
  end

  def setnominalsize(size)
    LibGR.setnominalsize(size)
  end

  def inqnominalsize
    size = Pointer(Float64).malloc
    LibGR.inqnominalsize(size)
    size.value
  end

  def setcolorrep(index, red, green, blue)
    LibGR.setcolorrep(index, red, green, blue)
  end

  def setwindow(xmin, xmax, ymin, ymax)
    LibGR.setwindow(xmin, xmax, ymin, ymax)
  end

  def inqwindow
    xmin = Pointer(Float64).malloc
    xmax = Pointer(Float64).malloc
    ymin = Pointer(Float64).malloc
    ymax = Pointer(Float64).malloc
    LibGR.inqwindow(xmin, xmax, ymin, ymax)
    {xmin.value, xmax.value, ymin.value, ymax.value}
  end

  def setviewport(xmin, xmax, ymin, ymax)
    LibGR.setviewport(xmin, xmax, ymin, ymax)
  end

  def inqviewport
    xmin = Pointer(Float64).malloc
    xmax = Pointer(Float64).malloc
    ymin = Pointer(Float64).malloc
    ymax = Pointer(Float64).malloc
    LibGR.inqviewport(xmin, xmax, ymin, ymax)
    {xmin.value, xmax.value, ymin.value, ymax.value}
  end

  def selntran(transform)
    LibGR.selntran(transform)
  end

  def setclip(indicator)
    LibGR.setclip(indicator)
  end

  def setwswindow(xmin, xmax, ymin, ymax)
    LibGR.setwswindow(xmin, xmax, ymin, ymax)
  end

  def setwsviewport(xmin, xmax, ymin, ymax)
    LibGR.setwsviewport(xmin, xmax, ymin, ymax)
  end

  def createseg(segment)
    LibGR.createseg(segment)
  end

  def copysegws(segment)
    LibGR.copysegws(segment)
  end

  def redrawsegws
    LibGR.redrawsegws
  end

  def setsegtran(segment, fx, fy, transx, transy, phi, scalex, scaley)
    LibGR.setsegtran(segment, fx, fy, transx, transy, phi, scalex, scaley)
  end

  def closeseg
    LibGR.closeseg
  end

  def samplelocator
    x = Pointer(Float64).malloc
    y = Pointer(Float64).malloc
    stat = Pointer(Int32).malloc
    LibGR.samplelocator(x, y, stat)
    {x.value, y.value, stat.value}
  end

  def emergencyclosegks
    LibGR.emergencyclosegks
  end

  def updategks
    LibGR.updategks
  end

  def setspace(zmin, zmax, rotation, tilt)
    LibGR.setspace(zmin, zmax, rotation, tilt)
  end

  def inqspace
    zmin = Pointer(Float64).malloc
    zmax = Pointer(Float64).malloc
    rotation = Pointer(Int32).malloc
    tilt = Pointer(Int32).malloc
    LibGR.inqspace(zmin, zmax, rotation, tilt)
    {zmin.value, zmax.value, rotation.value, tilt.value}
  end

  def setscale(options)
    LibGR.setscale(options)
  end

  def inqscale
    options = Pointer(Int32).malloc
    LibGR.inqscale(options)
    options.value
  end

  def setscientificformat(format_option)
    LibGR.setscientificformat(format_option)
  end

  def axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
    LibGR.axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
  end

  def grid(x_tick, y_tick, x_org, y_org, major_x, major_y)
    LibGR.grid(x_tick, y_tick, x_org, y_org, major_x, major_y)
  end

  def grid3d(x_tick, y_tick, z_tick, x_org, y_org, z_org, major_x, major_y, major_z)
    LibGR.grid3d(x_tick, y_tick, z_tick, x_org, y_org, z_org, major_x, major_y, major_z)
  end

  def settitles3d(x_title, y_title, z_title)
    LibGR.settitles3d(to_cchar(x_title), to_cchar(y_title), to_cchar(z_title))
  end

  def tricontour(x, y, z, levels)
    npoints = ensure_same_length(x, y, z)
    LibGR.tricontour(npoints, float64(x), float64(y), float64(z), levels.size, float64(levels))
  end

  def setcolormap(index)
    LibGR.setcolormap(index)
  end

  def inqcolormap
    index = Pointer(Int32).malloc
    LibGR.inqcolormap(index)
    index.value
  end

  def setcolormapfromrgb(r, g, b, x = nil)
    n = ensure_same_length(r, g, b)
    x_ptr = x.nil? ? Pointer(Float64).null : float64(x)
    LibGR.setcolormapfromrgb(n, float64(r), float64(g), float64(b), x_ptr)
  end

  def inqcolormapinds
    start_index = Pointer(Int32).malloc
    end_index = Pointer(Int32).malloc
    LibGR.inqcolormapinds(start_index, end_index)
    {start_index.value, end_index.value}
  end

  def colorbar
    LibGR.colorbar
  end

  def inqcolor(color)
    rgb = Pointer(Int32).malloc
    LibGR.inqcolor(color, rgb)
    rgb.value
  end

  def inqcolorfromrgb(red, green, blue)
    LibGR.inqcolorfromrgb(red, green, blue)
  end

  def hsvtorgb(h, s, v)
    r = Pointer(Float64).malloc
    g = Pointer(Float64).malloc
    b = Pointer(Float64).malloc
    LibGR.hsvtorgb(h, s, v, r, g, b)
    {r.value, g.value, b.value}
  end

  def tick(amin, amax)
    LibGR.tick(amin, amax)
  end

  def validaterange(amin, amax)
    LibGR.validaterange(amin, amax)
  end

  def adjustlimits(amin, amax)
    amin_ptr = Pointer(Float64).malloc
    amax_ptr = Pointer(Float64).malloc
    amin_ptr.value = amin
    amax_ptr.value = amax
    LibGR.adjustlimits(amin_ptr, amax_ptr)
    {amin_ptr.value, amax_ptr.value}
  end

  def adjustrange(amin, amax)
    amin_ptr = Pointer(Float64).malloc
    amax_ptr = Pointer(Float64).malloc
    amin_ptr.value = amin
    amax_ptr.value = amax
    LibGR.adjustrange(amin_ptr, amax_ptr)
    {amin_ptr.value, amax_ptr.value}
  end

  def beginprint(pathname)
    LibGR.beginprint(to_cchar(pathname))
  end

  def beginprintext(pathname, mode, fmt, orientation)
    LibGR.beginprintext(to_cchar(pathname), to_cchar(mode), to_cchar(fmt), to_cchar(orientation))
  end

  def endprint
    LibGR.endprint
  end

  def ndctowc(x, y)
    x_ptr = Pointer(Float64).malloc
    y_ptr = Pointer(Float64).malloc
    x_ptr.value = x
    y_ptr.value = y
    LibGR.ndctowc(x_ptr, y_ptr)
    {x_ptr.value, y_ptr.value}
  end

  def wctondc(x, y)
    x_ptr = Pointer(Float64).malloc
    y_ptr = Pointer(Float64).malloc
    x_ptr.value = x
    y_ptr.value = y
    LibGR.wctondc(x_ptr, y_ptr)
    {x_ptr.value, y_ptr.value}
  end

  def wc3towc(x, y, z)
    x_ptr = Pointer(Float64).malloc
    y_ptr = Pointer(Float64).malloc
    z_ptr = Pointer(Float64).malloc
    x_ptr.value = x
    y_ptr.value = y
    z_ptr.value = z
    LibGR.wc3towc(x_ptr, y_ptr, z_ptr)
    {x_ptr.value, y_ptr.value, z_ptr.value}
  end

  def drawrect(xmin, xmax, ymin, ymax)
    LibGR.drawrect(xmin, xmax, ymin, ymax)
  end

  def fillrect(xmin, xmax, ymin, ymax)
    LibGR.fillrect(xmin, xmax, ymin, ymax)
  end

  def drawarc(xmin, xmax, ymin, ymax, a1, a2)
    LibGR.drawarc(xmin, xmax, ymin, ymax, a1, a2)
  end

  def fillarc(xmin, xmax, ymin, ymax, a1, a2)
    LibGR.fillarc(xmin, xmax, ymin, ymax, a1, a2)
  end

  def drawpath(vertices, codes, fill)
    n = vertices.size
    ptr = Pointer(LibGR::VertexT).malloc(n)
    vertices.each_with_index do |(x, y), i|
      ptr[i] = LibGR::VertexT.new(x: x.to_f64, y: y.to_f64)
    end
    LibGR.drawpath(n, ptr, uint8_ptr(codes), fill)
  end

  def setarrowstyle(style)
    LibGR.setarrowstyle(style)
  end

  def setarrowsize(size)
    LibGR.setarrowsize(size)
  end

  def drawarrow(x1, y1, x2, y2)
    LibGR.drawarrow(x1, y1, x2, y2)
  end

  def readimage(path)
    width = Pointer(Int32).malloc
    height = Pointer(Int32).malloc
    data = Pointer(Pointer(Int32)).malloc
    LibGR.readimage(to_cchar(path), width, height, data)
    if width.value > 0 && height.value > 0 && !data.value.null?
      size = width.value * height.value
      pixels = Array(Int32).new(size) { |i| data.value[i] }
      {width.value, height.value, pixels}
    else
      {0, 0, [] of Int32}
    end
  end

  def drawimage(xmin, xmax, ymin, ymax, width, height, data, model = 0)
    LibGR.drawimage(xmin, xmax, ymin, ymax, width, height, int32(data), model)
  end

  def importgraphics(path)
    LibGR.importgraphics(to_cchar(path))
  end

  def setshadow(offsetx, offsety, blur)
    LibGR.setshadow(offsetx, offsety, blur)
  end

  def settransparency(alpha)
    LibGR.settransparency(alpha)
  end

  def inqtransparency
    alpha = Pointer(Float64).malloc
    LibGR.inqtransparency(alpha)
    alpha.value
  end

  def setcoordxform(mat)
    LibGR.setcoordxform(float64(mat))
  end

  def begingraphics(path)
    LibGR.begingraphics(to_cchar(path))
  end

  def endgraphics
    LibGR.endgraphics
  end

  def getgraphics
    ptr = LibGR.getgraphics
    ptr.null? ? "" : String.new(ptr)
  end

  def drawgraphics(data)
    LibGR.drawgraphics(to_cchar(data))
  end

  def startlistener
    LibGR.startlistener
  end

  def inqgrplotport
    LibGR.inqgrplotport
  end

  def setgrplotport(port)
    LibGR.setgrplotport(port)
  end

  def inqmathtex(x, y, c)
    tbx = Pointer(Float64).malloc(4)
    tby = Pointer(Float64).malloc(4)
    LibGR.inqmathtex(x, y, to_cchar(c), tbx, tby)
    {Array(Float64).new(4) { |i| tbx[i] }, Array(Float64).new(4) { |i| tby[i] }}
  end

  def mathtex3d(x, y, z, c, axis)
    LibGR.mathtex3d(x, y, z, to_cchar(c), axis)
  end

  def inqmathtex3d(x, y, z, c, axis)
    tbx = Pointer(Float64).malloc(4)
    tby = Pointer(Float64).malloc(4)
    tbz = Pointer(Float64).malloc(4)
    tby2 = Pointer(Float64).malloc(4)
    LibGR.inqmathtex3d(x, y, z, to_cchar(c), axis, tbx, tby, tbz, tby2)
    {
      Array(Float64).new(4) { |i| tbx[i] },
      Array(Float64).new(4) { |i| tby[i] },
      Array(Float64).new(4) { |i| tbz[i] },
      Array(Float64).new(4) { |i| tby2[i] },
    }
  end

  def beginselection(index, type)
    LibGR.beginselection(index, type)
  end

  def endselection
    LibGR.endselection
  end

  def moveselection(x, y)
    LibGR.moveselection(x, y)
  end

  def resizeselection(type, x, y)
    LibGR.resizeselection(type, x, y)
  end

  def inqbbox
    xmin = Pointer(Float64).malloc
    xmax = Pointer(Float64).malloc
    ymin = Pointer(Float64).malloc
    ymax = Pointer(Float64).malloc
    LibGR.inqbbox(xmin, xmax, ymin, ymax)
    {xmin.value, xmax.value, ymin.value, ymax.value}
  end

  def setbackground(red, green, blue, alpha)
    LibGR.setbackground(red, green, blue, alpha)
  end

  def clearbackground
    LibGR.clearbackground
  end

  def precision
    LibGR.precision
  end

  def text_maxsize
    LibGR.text_maxsize
  end

  def setregenflags(flags)
    LibGR.setregenflags(flags)
  end

  def inqregenflags
    LibGR.inqregenflags
  end

  def savestate
    LibGR.savestate
  end

  def restorestate
    LibGR.restorestate
  end

  def savecontext(context)
    LibGR.savecontext(context)
  end

  def selectcontext(context)
    LibGR.selectcontext(context)
  end

  def destroycontext(context)
    LibGR.destroycontext(context)
  end

  def unselectcontext
    LibGR.unselectcontext
  end

  def uselinespec(linespec)
    LibGR.uselinespec(to_cchar(linespec))
  end

  def delaunay(x, y)
    n = ensure_same_length(x, y)
    ntri = Pointer(Int32).malloc
    triangles = Pointer(Pointer(Int32)).malloc
    LibGR.delaunay(n, float64(x), float64(y), ntri, triangles)
    if ntri.value > 0 && !triangles.value.null?
      count = ntri.value * 3
      data = Array(Int32).new(count) { |i| triangles.value[i] }
      {ntri.value, data}
    else
      {0, [] of Int32}
    end
  end

  def reducepoints(x, y, n_out)
    n = ensure_same_length(x, y)
    x_out = Pointer(Float64).malloc(n_out)
    y_out = Pointer(Float64).malloc(n_out)
    LibGR.reducepoints(n, float64(x), float64(y), n_out, x_out, y_out)
    {
      Array(Float64).new(n_out) { |i| x_out[i] },
      Array(Float64).new(n_out) { |i| y_out[i] },
    }
  end

  def trisurface(x, y, z)
    n = ensure_same_length(x, y, z)
    LibGR.trisurface(n, float64(x), float64(y), float64(z))
  end

  def gradient(x, y, z, nx, ny)
    u = Pointer(Float64).malloc(nx * ny)
    v = Pointer(Float64).malloc(nx * ny)
    LibGR.gradient(nx, ny, float64(x), float64(y), float64(z), u, v)
    {
      Array(Float64).new(nx * ny) { |i| u[i] },
      Array(Float64).new(nx * ny) { |i| v[i] },
    }
  end

  def quiver(x, y, u, v, color)
    LibGR.quiver(x.size, y.size, float64(x), float64(y), float64(u), float64(v), color)
  end

  def interp2(x, y, z, xq, yq, method, extrapval)
    zq = Pointer(Float64).malloc(xq.size * yq.size)
    LibGR.interp2(x.size, y.size, float64(x), float64(y), float64(z), xq.size, yq.size,
      float64(xq), float64(yq), zq, method, extrapval)
    Array(Float64).new(xq.size * yq.size) { |i| zq[i] }
  end

  def shade(x, y, lines, flip, h, xform, bins, dims)
    LibGR.shade(x.size, float64(x), float64(y), lines, flip, float64(h), xform, bins, int32(dims))
  end

  def shadepoints(x, y, xform, w, h)
    n = ensure_same_length(x, y)
    LibGR.shadepoints(n, float64(x), float64(y), xform, w, h)
  end

  def shadelines(x, y, xform, w, h)
    n = ensure_same_length(x, y)
    LibGR.shadelines(n, float64(x), float64(y), xform, w, h)
  end

  def panzoom(x, y, zoom, angle)
    xmin = Pointer(Float64).malloc
    xmax = Pointer(Float64).malloc
    ymin = Pointer(Float64).malloc
    ymax = Pointer(Float64).malloc
    LibGR.panzoom(x, y, zoom, angle, xmin, xmax, ymin, ymax)
    {xmin.value, xmax.value, ymin.value, ymax.value}
  end

  def setresamplemethod(flag)
    LibGR.setresamplemethod(flag)
  end

  def inqresamplemethod
    flag = Pointer(UInt32).malloc
    LibGR.inqresamplemethod(flag)
    flag.value
  end

  def setborderwidth(width)
    LibGR.setborderwidth(width)
  end

  def inqborderwidth
    width = Pointer(Float64).malloc
    LibGR.inqborderwidth(width)
    width.value
  end

  def setbordercolorind(color)
    LibGR.setbordercolorind(color)
  end

  def inqbordercolorind
    color = Pointer(Int32).malloc
    LibGR.inqbordercolorind(color)
    color.value
  end

  def selectclipxform(transform)
    LibGR.selectclipxform(transform)
  end

  def inqclipxform
    transform = Pointer(Int32).malloc
    LibGR.inqclipxform(transform)
    transform.value
  end

  def inqclip
    indicator = Pointer(Int32).malloc
    rectangle = Pointer(Float64).malloc(4)
    LibGR.inqclip(indicator, rectangle)
    {indicator.value, Array(Float64).new(4) { |i| rectangle[i] }}
  end

  def setprojectiontype(type)
    LibGR.setprojectiontype(type)
  end

  def inqprojectiontype
    type = Pointer(Int32).malloc
    LibGR.inqprojectiontype(type)
    type.value
  end

  def setperspectiveprojection(near_plane, far_plane, fov)
    LibGR.setperspectiveprojection(near_plane, far_plane, fov)
  end

  def inqperspectiveprojection
    near_plane = Pointer(Float64).malloc
    far_plane = Pointer(Float64).malloc
    fov = Pointer(Float64).malloc
    LibGR.inqperspectiveprojection(near_plane, far_plane, fov)
    {near_plane.value, far_plane.value, fov.value}
  end

  def settransformationparameters(a0, a1, a2, a3, a4, a5, a6, a7, a8)
    LibGR.settransformationparameters(a0, a1, a2, a3, a4, a5, a6, a7, a8)
  end

  def inqtransformationparameters
    a0 = Pointer(Float64).malloc
    a1 = Pointer(Float64).malloc
    a2 = Pointer(Float64).malloc
    a3 = Pointer(Float64).malloc
    a4 = Pointer(Float64).malloc
    a5 = Pointer(Float64).malloc
    a6 = Pointer(Float64).malloc
    a7 = Pointer(Float64).malloc
    a8 = Pointer(Float64).malloc
    LibGR.inqtransformationparameters(a0, a1, a2, a3, a4, a5, a6, a7, a8)
    {a0.value, a1.value, a2.value, a3.value, a4.value, a5.value, a6.value, a7.value, a8.value}
  end

  def setorthographicprojection(left, right, bottom, top, near_plane, far_plane)
    LibGR.setorthographicprojection(left, right, bottom, top, near_plane, far_plane)
  end

  def inqorthographicprojection
    left = Pointer(Float64).malloc
    right = Pointer(Float64).malloc
    bottom = Pointer(Float64).malloc
    top = Pointer(Float64).malloc
    near_plane = Pointer(Float64).malloc
    far_plane = Pointer(Float64).malloc
    LibGR.inqorthographicprojection(left, right, bottom, top, near_plane, far_plane)
    {left.value, right.value, bottom.value, top.value, near_plane.value, far_plane.value}
  end

  def camerainteraction(rotate_x, rotate_y, rotate_z, zoom)
    LibGR.camerainteraction(rotate_x, rotate_y, rotate_z, zoom)
  end

  def setwindow3d(xmin, xmax, ymin, ymax, zmin, zmax)
    LibGR.setwindow3d(xmin, xmax, ymin, ymax, zmin, zmax)
  end

  def inqwindow3d
    xmin = Pointer(Float64).malloc
    xmax = Pointer(Float64).malloc
    ymin = Pointer(Float64).malloc
    ymax = Pointer(Float64).malloc
    zmin = Pointer(Float64).malloc
    zmax = Pointer(Float64).malloc
    LibGR.inqwindow3d(xmin, xmax, ymin, ymax, zmin, zmax)
    {xmin.value, xmax.value, ymin.value, ymax.value, zmin.value, zmax.value}
  end

  def setscalefactors3d(x_axis_scale, y_axis_scale, z_axis_scale)
    LibGR.setscalefactors3d(x_axis_scale, y_axis_scale, z_axis_scale)
  end

  def inqscalefactors3d
    x_axis_scale = Pointer(Float64).malloc
    y_axis_scale = Pointer(Float64).malloc
    z_axis_scale = Pointer(Float64).malloc
    LibGR.inqscalefactors3d(x_axis_scale, y_axis_scale, z_axis_scale)
    {x_axis_scale.value, y_axis_scale.value, z_axis_scale.value}
  end

  def setspace3d(phi, theta, fov, camera_distance)
    LibGR.setspace3d(phi, theta, fov, camera_distance)
  end

  def inqspace3d
    rotation = Pointer(Int32).malloc
    phi = Pointer(Float64).malloc
    theta = Pointer(Float64).malloc
    fov = Pointer(Float64).malloc
    camera_distance = Pointer(Float64).malloc
    LibGR.inqspace3d(rotation, phi, theta, fov, camera_distance)
    {rotation.value, phi.value, theta.value, fov.value, camera_distance.value}
  end

  def text3d(x, y, z, c, axis)
    LibGR.text3d(x, y, z, to_cchar(c), axis)
  end

  def inqtext3d(x, y, z, c, axis)
    tbx = Pointer(Float64).malloc(16)
    tby = Pointer(Float64).malloc(16)
    LibGR.inqtext3d(x, y, z, to_cchar(c), axis, tbx, tby)
    {Array(Float64).new(16) { |i| tbx[i] }, Array(Float64).new(16) { |i| tby[i] }}
  end

  def settextencoding(encoding)
    LibGR.settextencoding(encoding)
  end

  def inqtextencoding
    encoding = Pointer(Int32).malloc
    LibGR.inqtextencoding(encoding)
    encoding.value
  end

  def loadfont(filename)
    font_index = Pointer(Int32).malloc
    LibGR.loadfont(to_cchar(filename), font_index)
    font_index.value
  end

  def setthreadnumber(num)
    LibGR.setthreadnumber(num)
  end

  def inqvpsize
    width = Pointer(Int32).malloc
    height = Pointer(Int32).malloc
    device_pixel_ratio = Pointer(Float64).malloc
    LibGR.inqvpsize(width, height, device_pixel_ratio)
    {width.value, height.value, device_pixel_ratio.value}
  end

  def polygonmesh3d(x, y, z, faces, colors)
    npoints = ensure_same_length(x, y, z)
    LibGR.polygonmesh3d(npoints, float64(x), float64(y), float64(z), colors.size, int32(faces), int32(colors))
  end

  def setmathfont(font)
    LibGR.setmathfont(font)
  end

  def inqmathfont
    font = Pointer(Int32).malloc
    LibGR.inqmathfont(font)
    font.value
  end

  def setclipregion(region)
    LibGR.setclipregion(region)
  end

  def inqclipregion
    region = Pointer(Int32).malloc
    LibGR.inqclipregion(region)
    region.value
  end

  def setclipsector(start_angle, end_angle)
    LibGR.setclipsector(start_angle, end_angle)
  end

  def inqclipsector
    start_angle = Pointer(Float64).malloc
    end_angle = Pointer(Float64).malloc
    LibGR.inqclipsector(start_angle, end_angle)
    {start_angle.value, end_angle.value}
  end

  def settextoffset(xoff, yoff)
    LibGR.settextoffset(xoff, yoff)
  end

  def version
    String.new(LibGR.version)
  end
end
