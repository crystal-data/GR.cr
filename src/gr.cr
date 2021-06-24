require "./gr/libgr.cr"

module GR
  extend self

  class GRparms
    @@charheight = 0.027

    def self.charheight
      @@charheight
    end

    def self.charheight(x)
      @@charheight = x
    end

    @@winmax = [1.0, 1.0]
    @@winmin = [0.0, 0.0]

    def self.winmax
      @@winmax
    end

    def self.winmax(x)
      @@winmax = x
    end

    def self.winmin
      @@winmin
    end

    def self.winmin(x)
      @@winmin = x
    end
  end

  def axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
    LibGR.gr_axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
  end

  def box(x_tick = (GRparms.winmax[0] - GRparms.winmin[0]) * 0.25,
          y_tick = (GRparms.winmax[1] - GRparms.winmin[1]) * 0.25,
          x_org = GRparms.winmin[0], y_org = GRparms.winmin[1], major_x = 1, major_y = 1, tick_size = 0.01, xlog = false, ylog = false)
    scalearg = 0
    scalearg += 1 if xlog
    scalearg += 2 if ylog
    LibGR.gr_setscale(scalearg)
    LibGR.gr_setcharheight(GRparms.charheight.to_f)
    LibGR.gr_axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
    LibGR.gr_setcharheight(0.00001)
    LibGR.gr_axes(x_tick, y_tick, GRparms.winmax[0], GRparms.winmax[1], major_x, major_y,
      -tick_size)
    LibGR.gr_setcharheight(GRparms.charheight.to_f)
  end

  def to_carray(a)
    Pointer(Float64).malloc(a.size) { |i| a[i] }
  end

  def to_cchar(s)
    cp = Pointer(UInt8).malloc(s.size + 1)
    i = 0
    s.each_byte { |c| cp[i] = c; i += 1 }
    #    (s.size+1).times{|i|p cp[i]}
    cp[s.size] = 0
    cp
  end

  # Forwardable methods
  # [Automatic definitions in GR.rb] - [those containing char*]
  {% for name in %w[
    initgr
    opengks
    closegks
    closews
    activatews
    deactivatews
    configurews
    clearws
    updatews
    text
    setlinetype
    setlinewidth
    setlinecolorind
    setmarkertype
    setmarkersize
    setmarkercolorind
    settextfontprec
    settextcolorind
    settextpath
    settextalign
    setfillintstyle
    setfillstyle
    setfillcolorind
    setcolorrep
    setwindow
    setviewport
    selntran
    setclip
    setwswindow
    setwsviewport
    createseg
    copysegws
    redrawsegws
    setsegtran
    closeseg
    emergencyclosegks
    updategks
    setspace
    setscale
    axes
    axeslbl
    grid
    grid3d
    axes3d
    colorbar
    inqcolorfromrgb
    tick
    validaterange
    endprint
    drawrect
    fillrect
    drawarc
    fillarc
    setarrowstyle
    setarrowsize
    drawarrow
    setshadow
    settransparency
    endgraphics
    beginselection
    endselection
    moveselection
    resizeselection
    precision
    setregenflags
    inqregenflags
    savestate
    restorestate
    selectcontext
    destroycontext
    shade
    findboundary
    setresamplemethod
    setborderwidth
    setbordercolorind
    selectclipxform
    setprojectiontype
    setperspectiveprojection
    settransformationparameters
    setorthographicprojection
    camerainteraction
    setwindow3d
    setscalefactors3d
    setspace3d
    settextencoding] %}

    def {{name.id}}(*args)
      LibGR.gr_{{name.id}}(*args)
    end
  {% end %}


  def openws(i0, c, i1)
    LibGR.gr_openws(i0, to_cchar(c), i1)
  end

  def polyline(x, y)
    LibGR.gr_polyline([x.size, y.size].min, to_carray(x), to_carray(y))
  end

  def polymarker(x, y)
    LibGR.gr_polymarker([x.size, y.size].min, to_carray(x), to_carray(y))
  end

  def text(x, x1, c)
    LibGR.gr_text(x, x1, to_cchar(c))
  end

  def mathtex(x, x1, c)
    LibGR.gr_mathtex(x, x1, to_cchar(c))
  end

  def fillarea(x, y)
    LibGR.gr_fillarea([x.size, y.size].min, to_carray(x), to_carray(y))
  end

  def spline(x, y, i1, i2)
    LibGR.gr_spline([x.size, y.size].min, to_carray(x), to_carray(y), i1, i2)
  end

  def setcharheight(x)
    LibGR.gr_setcharheight(x)
    GRparms.charheight(x)
  end

  def setwindow(x, x1, x2, x3)
    LibGR.gr_setwindow(x, x1, x2, x3)
    GRparms.winmax [x1.to_f, x3.to_f]
    GRparms.winmin [x.to_f, x2.to_f]
  end

  def textext(x, x1, c)
    LibGR.gr_textext(x, x1, to_cchar(c))
  end

  def verrorbars(xa, xb, xc, xd)
    LibGR.gr_verrorbars([xa.size, xb.size, xc.size, xd.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc), to_carray(xd))
  end

  def herrorbars(xa, xb, xc, xd)
    LibGR.gr_herrorbars([xa.size, xb.size, xc.size, xd.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc), to_carray(xd))
  end

  def polyline3d(xa, xb, xc)
    LibGR.gr_polyline3d([xa.size, xb.size, xc.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc))
  end

  def polymarker3d(xa, xb, xc)
    LibGR.gr_polymarker3d([xa.size, xb.size, xc.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc))
  end

  def axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
    LibGR.gr_axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
  end

  def titles3d(c, c0, c1)
    LibGR.gr_titles3d(to_cchar(c), to_cchar(c0), to_cchar(c1))
  end

  def surface(xa, xb, xc, i2)
    LibGR.gr_surface(xa.size, xb.size, to_carray(xa), to_carray(xb), to_carray(xc), i2)
  end

  def contour(xa, xb, xc, xd, i4)
    LibGR.gr_contour(xa.size, xb.size, xc.size, to_carray(xa), to_carray(xb),
      to_carray(xc), to_carray(xd), i4)
  end

  def contourf(xa, xb, xc, xd, i4)
    LibGR.gr_contourf(xa.size, xb.size, xc.size, to_carray(xa), to_carray(xb),
      to_carray(xc), to_carray(xd), i4)
  end
end
