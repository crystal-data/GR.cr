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

  def initgr
    LibGR.gr_initgr
  end

  def opengks
    LibGR.gr_opengks
  end

  def closegks
    LibGR.gr_closegks
  end

  def openws(i0, c, i1)
    LibGR.gr_openws(i0, to_cchar(c), i1)
  end

  def closews(i)
    LibGR.gr_closews(i)
  end

  def activatews(i)
    LibGR.gr_activatews(i)
  end

  def deactivatews(i)
    LibGR.gr_deactivatews(i)
  end

  def configurews
    LibGR.gr_configurews
  end

  def clearws
    LibGR.gr_clearws
  end

  def updatews
    LibGR.gr_updatews
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

  def setlinetype(i)
    LibGR.gr_setlinetype(i)
  end

  def setlinewidth(x)
    LibGR.gr_setlinewidth(x)
  end

  def setlinecolorind(i)
    LibGR.gr_setlinecolorind(i)
  end

  def setmarkertype(i)
    LibGR.gr_setmarkertype(i)
  end

  def setmarkersize(x)
    LibGR.gr_setmarkersize(x)
  end

  def setmarkercolorind(i)
    LibGR.gr_setmarkercolorind(i)
  end

  def settextfontprec(i, i1)
    LibGR.gr_settextfontprec(i, i1)
  end

  def setcharexpan(x)
    LibGR.gr_setcharexpan(x)
  end

  def setcharspace(x)
    LibGR.gr_setcharspace(x)
  end

  def settextcolorind(i)
    LibGR.gr_settextcolorind(i)
  end

  def setcharheight(x)
    LibGR.gr_setcharheight(x)
    GRparms.charheight(x)
  end

  def setcharup(x, y)
    LibGR.gr_setcharup(x, y)
  end

  def settextpath(i)
    LibGR.gr_settextpath(i)
  end

  def settextalign(i, i1)
    LibGR.gr_settextalign(i, i1)
  end

  def setfillintstyle(i)
    LibGR.gr_setfillintstyle(i)
  end

  def setfillstyle(i)
    LibGR.gr_setfillstyle(i)
  end

  def setfillcolorind(i)
    LibGR.gr_setfillcolorind(i)
  end

  def setwindow(x, x1, x2, x3)
    LibGR.gr_setwindow(x, x1, x2, x3)
    GRparms.winmax [x1.to_f, x3.to_f]
    GRparms.winmin [x.to_f, x2.to_f]
  end

  def setviewport(x, x1, x2, x3)
    LibGR.gr_setviewport(x, x1, x2, x3)
  end

  def selntran(i)
    LibGR.gr_selntran(i)
  end

  def setclip(i)
    LibGR.gr_setclip(i)
  end

  def setwswindow(x, x1, x2, x3)
    LibGR.gr_setwswindow(x, x1, x2, x3)
  end

  def setwsviewport(x, x1, x2, x3)
    LibGR.gr_setwsviewport(x, x1, x2, x3)
  end

  def createseg(i)
    LibGR.gr_createseg(i)
  end

  def copysegws(i)
    LibGR.gr_copysegws(i)
  end

  def redrawsegws
    LibGR.gr_redrawsegws
  end

  def setspace(x, x1, i, i1)
    LibGR.gr_setspace(x, x1, i, i1)
  end

  def setscale(i)
    LibGR.gr_setscale(i)
  end

  def textext(x, x1, c)
    LibGR.gr_textext(x, x1, to_cchar(c))
  end

  def grid(x, x1, x2, x3, i, i1)
    LibGR.gr_grid(x, x1, x2, x3, i, i1)
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

  def tricontour(i, xa, xb, xc, i1, xd)
    LibGR.gr_tricontour(i, xa, xb, xc, i1, xd)
  end

  def hexbin(i, xa, xb, i1)
    LibGR.gr_hexbin(i, xa, xb, i1)
  end

  def setcolormap(i)
    LibGR.gr_setcolormap(i)
  end

  def inqcolormap(ia)
    LibGR.gr_inqcolormap(ia)
  end

  def setcolormapfromrgb(i, xa, xb, xc, xd)
    LibGR.gr_setcolormapfromrgb(i, xa, xb, xc, xd)
  end

  def colorbar
    LibGR.gr_colorbar
  end

  def inqcolor(i, ia)
    LibGR.gr_inqcolor(i, ia)
  end

  def inqcolorfromrgb(x, x1, x2)
    LibGR.gr_inqcolorfromrgb(x, x1, x2)
  end

  def hsvtorgb(x, x1, x2, xa, xb, xc)
    LibGR.gr_hsvtorgb(x, x1, x2, xa, xb, xc)
  end

  def tick(x, x1)
    LibGR.gr_tick(x, x1)
  end

  def validaterange(x, x1)
    LibGR.gr_validaterange(x, x1)
  end

  def adjustlimits(xa, xb)
    LibGR.gr_adjustlimits(xa, xb)
  end

  def adjustrange(xa, xb)
    LibGR.gr_adjustrange(xa, xb)
  end

  def beginprint(c)
    LibGR.gr_beginprint(c)
  end

  def beginprintext(c, c1, c2, c3)
    LibGR.gr_beginprintext(c, c1, c2, c3)
  end

  def endprint
    LibGR.gr_endprint
  end

  def ndctowc(xa, xb)
    LibGR.gr_ndctowc(xa, xb)
  end

  def wctondc(xa, xb)
    LibGR.gr_wctondc(xa, xb)
  end

  def wc3towc(xa, xb, xc)
    LibGR.gr_wc3towc(xa, xb, xc)
  end

  def drawrect(x, x1, x2, x3)
    LibGR.gr_drawrect(x, x1, x2, x3)
  end

  def fillrect(x, x1, x2, x3)
    LibGR.gr_fillrect(x, x1, x2, x3)
  end

  def drawarc(x, x1, x2, x3, x4, x5)
    LibGR.gr_drawarc(x, x1, x2, x3, x4, x5)
  end

  def fillarc(x, x1, x2, x3, x4, x5)
    LibGR.gr_fillarc(x, x1, x2, x3, x4, x5)
  end

  def setarrowstyle(i)
    LibGR.gr_setarrowstyle(i)
  end

  def setarrowsize(x)
    LibGR.gr_setarrowsize(x)
  end

  def drawarrow(x, x1, x2, x3)
    LibGR.gr_drawarrow(x, x1, x2, x3)
  end
end
