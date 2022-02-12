require "./gr/libgr"
require "./gr_common/utils"

module GR
  include GRCommon::Utils
  extend self

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
    LibGR.polyline([x.size, y.size].min, float64(x), float64(y))
  end

  def polymarker(x, y)
    LibGR.polymarker([x.size, y.size].min, float64(x), float64(y))
  end

  def text(x, x1, c)
    LibGR.text(x, x1, to_cchar(c))
  end

  def cellarray(xmin, xmax, ymin, ymax, dimx, dimy, color)
    LibGR.cellarray(xmin, xmax, ymin, ymax, dimx, dimy, 1, 1, dimx, dimy, color)
  end

  def polarcellarray(x_org, y_org, phimin, phimax, rmin, rmax, dimphi, dimr, color)
    LibGR.polarcellarray(x_org, y_org, phimin, phimax, rmin, rmax, dimphi, dimr, 1, 1, dimphi, dimr, color)
  end

  def mathtex(x, x1, c)
    LibGR.mathtex(x, x1, to_cchar(c))
  end

  def fillarea(x, y)
    LibGR.fillarea([x.size, y.size].min, float64(x), float64(y))
  end

  def spline(x, y, i1, i2)
    LibGR.spline([x.size, y.size].min, float64(x), float64(y), i1, i2)
  end

  def textext(x, x1, c)
    LibGR.textext(x, x1, to_cchar(c))
  end

  def verrorbars(xa, xb, xc, xd)
    LibGR.verrorbars([xa.size, xb.size, xc.size, xd.size].min,
      float64(xa), float64(xb), float64(xc), float64(xd))
  end

  def herrorbars(xa, xb, xc, xd)
    LibGR.herrorbars([xa.size, xb.size, xc.size, xd.size].min,
      float64(xa), float64(xb), float64(xc), float64(xd))
  end

  def polyline3d(xa, xb, xc)
    LibGR.polyline3d([xa.size, xb.size, xc.size].min,
      float64(xa), float64(xb), float64(xc))
  end

  def polymarker3d(xa, xb, xc)
    LibGR.polymarker3d([xa.size, xb.size, xc.size].min,
      float64(xa), float64(xb), float64(xc))
  end

  def axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
    LibGR.axes3d(x, x1, x2, x3, x4, x5, i, i1, i2, x6)
  end

  def titles3d(c, c0, c1)
    LibGR.titles3d(to_cchar(c), to_cchar(c0), to_cchar(c1))
  end

  def surface(xa, xb, xc, i2)
    LibGR.surface(xa.size, xb.size, float64(xa), float64(xb), float64(xc), i2)
  end

  def contour(xa, xb, xc, xd, i4)
    LibGR.contour(xa.size, xb.size, xc.size, float64(xa), float64(xb),
      float64(xc), float64(xd), i4)
  end

  def contourf(xa, xb, xc, xd, i4)
    LibGR.contourf(xa.size, xb.size, xc.size, float64(xa), float64(xb),
      float64(xc), float64(xd), i4)
  end

  def hexbin(x, y, nbins)
    n = x.size
    LibGR.hexbin(n, float64(x), float64(y), nbins)
  end

  def shadepoints(xa, xb, a, b, c)
    raise "size error" if xa.size != xb.size    # fixme
    LibGR.shadepoints(xa.size, xa, xb, a, b, c) # should use dims and xform?
  end

  def path(x, y, codes)
    raise "size error" if x.size != y.size    # fixme
    LibGR.path(x.size, x, y, codes)
  end

  def version
    String.new(LibGR.version)
  end
end
