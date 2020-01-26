#
# grlib.cr
# Copyright 2020- Jun Makino
#
#@[Link("GR")]
@[Link(ldflags: "-L `echo $GRDIR`/lib -lGR -Wl,-rpath,`echo $GRDIR`/lib")]
lib LibGR
  fun gr_polyline(n: Int32, x: Float64*, x: Float64*) : Int32
  fun gr_axes(x_tick: Float64, y_tick: Float64, x_org: Float64, y_org: Float64,
        major_x: Int32, major_y: Int32, tick_size: Float64) : Int32

  fun gr_polymarker(i: Int32, xa: Float64*, xb: Float64*)
  fun gr_text(x: Float64, x: Float64, c: UInt8*)
  fun gr_mathtex(x: Float64, x: Float64, c: UInt8*)
  fun gr_fillarea(i: Int32, xa: Float64*, xb: Float64*)
  fun gr_cellarray(x0: Float64, x1: Float64, y0: Float64, y1: Float64, i0: Int32, i1: Int32, i2: Int32, i3: Int32, i4: Int32, i5: Int32, ia: Int32 *)

  fun gr_spline(i: Int32, xa: Float64*, xb: Float64*, i1: Int32, i2: Int32)
  fun gr_setlinetype(i: Int32)
  fun gr_setlinewidth(x: Float64)
  fun gr_setlinecolorind(i: Int32)
  fun gr_setmarkertype(i: Int32)
  fun gr_setmarkersize(x: Float64)
  fun gr_setmarkercolorind(i: Int32)
  fun gr_settextfontprec(i: Int32, i1: Int32)
  fun gr_setcharexpan(x: Float64)
  fun gr_setcharspace(x: Float64)
  fun gr_settextcolorind(i: Int32)
  fun gr_setcharheight(x: Float64)
  fun gr_setcharup(x: Float64, x: Float64)
  fun gr_settextpath(i: Int32)
  fun gr_settextalign(i: Int32, i1: Int32)
  fun gr_setfillintstyle(i: Int32)
  fun gr_setfillstyle(i: Int32)
  fun gr_setfillcolorind(i: Int32)
  fun gr_setwindow(x: Float64, x1: Float64, x2: Float64, x3: Float64)
  fun gr_setviewport(x: Float64, x1: Float64, x2: Float64, x3: Float64)
  fun gr_selntran(i: Int32)
  fun gr_setclip(i: Int32)
  fun gr_setwswindow(x: Float64, x1: Float64, x2: Float64, x3: Float64)
  fun gr_setwsviewport(x: Float64, x1: Float64, x2: Float64, x3: Float64)
  fun gr_createseg(i: Int32)
  fun gr_copysegws(i: Int32)
  fun gr_redrawsegws
  fun gr_setspace(x: Float64, x1: Float64, i: Int32, i1: Int32)
  fun gr_setscale(i: Int32)
  fun gr_textext(x: Float64, x: Float64, c: UInt8*) : Int32
  fun gr_grid(x: Float64, x1: Float64, x2: Float64, x3: Float64,
              i: Int32, i1: Int32)
  fun gr_verrorbars(i: Int32, xa: Float64*, xb: Float64*, xc: Float64*, xd: Float64*)
  fun gr_herrorbars(i: Int32, xa: Float64*, xb: Float64*, xc: Float64*, xd: Float64*)
  fun gr_polyline3d(i: Int32, xa: Float64*, xb: Float64*, xc: Float64*)
  fun gr_polymarker3d(i: Int32, xa: Float64*, xb: Float64*, xc: Float64*)
  fun gr_axes3d(x: Float64, x1: Float64, x2: Float64, x3: Float64,
                x4: Float64, x5: Float64, i: Int32, i1: Int32, i2: Int32,
                x6: Float64)
  fun gr_titles3d(c: UInt8*, c0: UInt8*, c1: UInt8*)
  fun gr_surface(i: Int32, i1: Int32, xa: Float64*, xb: Float64*, xc: Float64*,
                                          i2: Int32)
  fun gr_drawrect(x: Float64, x1: Float64, x2: Float64, x3: Float64)
  fun gr_fillrect(x: Float64, x1: Float64, x2: Float64, x3: Float64)
  fun gr_drawarc(x: Float64, x1: Float64, x2: Float64, x3: Float64, x4: Float64, x5: Float64)
  fun gr_fillarc(x: Float64, x1: Float64, x2: Float64, x3: Float64, x4: Float64, x5: Float64)
  fun gr_setarrowstyle(i: Int32)
  fun gr_setarrowsize(x: Float64)
  fun gr_drawarrow(x: Float64, x1: Float64, x2: Float64, x3: Float64)

end

module GR
  extend self
  class GRparms
    @@charheight=0.027
    def self.charheight()  @@charheight  end
    def self.charheight(x) @@charheight=x end
    @@winmax=[1.0,1.0]
    @@winmin=[0.0,0.0]
    def self.winmax()  @@winmax end
    def self.winmax(x) @@winmax=x end
    def self.winmin()  @@winmin end
    def self.winmin(x) @@winmin=x end
  end
  def axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
    LibGR.gr_axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
  end
  def box(x_tick=(GRparms.winmax[0]-GRparms.winmin[0])*0.25,
          y_tick=(GRparms.winmax[1]-GRparms.winmin[1])*0.25,
          x_org=GRparms.winmin[0], y_org=GRparms.winmin[0], major_x=2, major_y=2, tick_size=0.01)
    LibGR.gr_axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
    LibGR.gr_setcharheight(0.00001)
    LibGR.gr_axes(x_tick, y_tick, GRparms.winmax[0], GRparms.winmax[1], major_x, major_y,
                  -tick_size)
    LibGR.gr_setcharheight(GRparms.charheight.to_f)
  end
  def to_carray(a)
    Pointer(Float64).malloc(a.size){|i|a[i]}
  end
  def to_cchar(s)
    cp=Pointer(UInt8).malloc(s.size+1)
    i=0
    s.each_byte{|c| cp[i]=c; i+=1}
    #    (s.size+1).times{|i|p cp[i]}
    cp[s.size]=0
    cp
  end
  def polyline(x,y)
    LibGR.gr_polyline([x.size,y.size].min, to_carray(x), to_carray(y))
  end

  def polymarker(i, xa, xb)
    LibGR.gr_polymarker(i, xa, xb)
  end
  def text(x, x1, c)
    LibGR.gr_text(x, x1, to_cchar(c))
  end
  def mathtex(x, x1, c)
    LibGR.gr_mathtex(x, x1, to_cchar(c))
  end
  def fillarea(i, xa, xb)
    LibGR.gr_fillarea(i, xa, xb)
  end
  def spline(i, xa, xb, i1, i2)
    LibGR.gr_spline(i, xa, xb, i1, i2)
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
    GRparms.winmax  [x1.to_f, x3.to_f]
    GRparms.winmin  [x.to_f, x2.to_f]
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
  def verrorbars(i, xa, xb, xc, xd)
    LibGR.gr_verrorbars(i, xa, xb, xc, xd)
  end
  def herrorbars(i, xa, xb, xc, xd)
    LibGR.gr_herrorbars(i, xa, xb, xc, xd)
  end
  def polyline3d(i, xa, xb, xc)
    LibGR.gr_polyline3d(i, xa, xb, xc)
  end
  def polymarker3d(i, xa, xb, xc)
    LibGR.gr_polymarker3d(i, xa, xb, xc)
  end
  def axes3d(x, x1, x2, x3, x4, x5, i, i1, i2,  x6)
    LibGR.gr_axes3d(x, x1, x2, x3, x4, x5, i, i1, i2,  x6)
  end
  def titles3d(c, c0, c1)
    LibGR.gr_titles3d(c, c0, c1)
  end
  def surface(i, i1, xa, xb, xc, i2)
    LibGR.gr_surface(i, i1, xa, xb, xc, i2)
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
