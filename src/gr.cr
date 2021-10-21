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

  def box(x_tick = (GRparms.winmax[0] - GRparms.winmin[0]) * 0.25,
          y_tick = (GRparms.winmax[1] - GRparms.winmin[1]) * 0.25,
          x_org = GRparms.winmin[0], y_org = GRparms.winmin[1], major_x = 1, major_y = 1, tick_size = 0.01, xlog = false, ylog = false)
    scalearg = 0
    scalearg += 1 if xlog
    scalearg += 2 if ylog
    LibGR.setscale(scalearg)
    LibGR.setcharheight(GRparms.charheight.to_f)
    LibGR.axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
    LibGR.setcharheight(0.00001)
    LibGR.axes(x_tick, y_tick, GRparms.winmax[0], GRparms.winmax[1], major_x, major_y,
      -tick_size)
    LibGR.setcharheight(GRparms.charheight.to_f)
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
  # curl -sl https://raw.githubusercontent.com/sciapp/gr/v0.57.2/lib/gr/gr.h | grep -v '^#' | grep DLLEXPORT | grep -v '*' | grep -v '\[' | cut -f2 -d_ | sed 's/(.*//g'
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
                   setlinetype
                   setlinewidth
                   setlinecolorind
                   setmarkertype
                   setmarkersize
                   setmarkercolorind
                   settextfontprec
                   setcharexpan
                   setcharspace
                   settextcolorind
                   setcharheight
                   setcharup
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
                   setcolormap
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
                   settextencoding
                 ] %}
    def {{name.id}}(*args)
      LibGR.{{name.id}}(*args)
    end
  {% end %}

  def openws(i0, c, i1)
    LibGR.openws(i0, to_cchar(c), i1)
  end

  def polyline(x, y)
    LibGR.polyline([x.size, y.size].min, to_carray(x), to_carray(y))
  end

  def polymarker(x, y)
    LibGR.polymarker([x.size, y.size].min, to_carray(x), to_carray(y))
  end

  def text(x, x1, c)
    LibGR.text(x, x1, to_cchar(c))
  end

  def mathtex(x, x1, c)
    LibGR.mathtex(x, x1, to_cchar(c))
  end

  def fillarea(x, y)
    LibGR.fillarea([x.size, y.size].min, to_carray(x), to_carray(y))
  end

  def spline(x, y, i1, i2)
    LibGR.spline([x.size, y.size].min, to_carray(x), to_carray(y), i1, i2)
  end

  def setcharheight(x)
    LibGR.setcharheight(x)
    GRparms.charheight(x)
  end

  def setwindow(x, x1, x2, x3)
    LibGR.setwindow(x, x1, x2, x3)
    GRparms.winmax [x1.to_f, x3.to_f]
    GRparms.winmin [x.to_f, x2.to_f]
  end

  def textext(x, x1, c)
    LibGR.textext(x, x1, to_cchar(c))
  end

  def verrorbars(xa, xb, xc, xd)
    LibGR.verrorbars([xa.size, xb.size, xc.size, xd.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc), to_carray(xd))
  end

  def herrorbars(xa, xb, xc, xd)
    LibGR.herrorbars([xa.size, xb.size, xc.size, xd.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc), to_carray(xd))
  end

  def polyline3d(xa, xb, xc)
    LibGR.polyline3d([xa.size, xb.size, xc.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc))
  end

  def polymarker3d(xa, xb, xc)
    LibGR.polymarker3d([xa.size, xb.size, xc.size].min,
      to_carray(xa), to_carray(xb), to_carray(xc))
  end

  def axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
    LibGR.axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
  end

  def titles3d(c, c0, c1)
    LibGR.titles3d(to_cchar(c), to_cchar(c0), to_cchar(c1))
  end

  def surface(xa, xb, xc, i2)
    LibGR.surface(xa.size, xb.size, to_carray(xa), to_carray(xb), to_carray(xc), i2)
  end

  def contour(xa, xb, xc, xd, i4)
    LibGR.contour(xa.size, xb.size, xc.size, to_carray(xa), to_carray(xb),
      to_carray(xc), to_carray(xd), i4)
  end

  def contourf(xa, xb, xc, xd, i4)
    LibGR.contourf(xa.size, xb.size, xc.size, to_carray(xa), to_carray(xb),
      to_carray(xc), to_carray(xd), i4)
  end

  def hexbin(x, y, nbins)
    n = x.size
    LibGR.hexbin(n, to_carray(x), to_carray(y), nbins)
  end

  def shadepoints(xa, xb, a, b, c)
    raise "size error" if xa.size != xb.size # fixme
    LibGR.shadepoints(xa.size, xa, xb, a, b, c) # should use dims and xform?
  end
end
