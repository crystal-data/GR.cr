module GR
  module GR
    @[Link("GR")]
    lib LibGR
      fun gr_initgr
      fun gr_opengks
      fun gr_closegks
      fun gr_openws(i0 : Int32, c : UInt8*, i1 : Int32)
      fun gr_closews(i : Int32)
      fun gr_activatews(i : Int32)
      fun gr_deactivatews(i : Int32)
      fun gr_configurews
      fun gr_clearws
      fun gr_updatews
      fun gr_polyline(n : Int32, x : Float64*, x : Float64*) : Int32
      fun gr_axes(x_tick : Float64, y_tick : Float64, x_org : Float64, y_org : Float64,
                  major_x : Int32, major_y : Int32, tick_size : Float64) : Int32
      fun gr_polymarker(i : Int32, xa : Float64*, xb : Float64*)
      fun gr_text(x : Float64, x : Float64, c : UInt8*)
      fun gr_mathtex(x : Float64, x : Float64, c : UInt8*)
      fun gr_fillarea(i : Int32, xa : Float64*, xb : Float64*)
      fun gr_cellarray(x0 : Float64, x1 : Float64, y0 : Float64, y1 : Float64,
                       i0 : Int32, i1 : Int32, i2 : Int32, i3 : Int32, i4 : Int32, i5 : Int32, ia : Int32*)
      fun gr_spline(i : Int32, xa : Float64*, xb : Float64*, i1 : Int32, i2 : Int32)
      fun gr_setlinetype(i : Int32)
      fun gr_setlinewidth(x : Float64)
      fun gr_setlinecolorind(i : Int32)
      fun gr_setmarkertype(i : Int32)
      fun gr_setmarkersize(x : Float64)
      fun gr_setmarkercolorind(i : Int32)
      fun gr_settextfontprec(i : Int32, i1 : Int32)
      fun gr_setcharexpan(x : Float64)
      fun gr_setcharspace(x : Float64)
      fun gr_settextcolorind(i : Int32)
      fun gr_setcharheight(x : Float64)
      fun gr_setcharup(x : Float64, x : Float64)
      fun gr_settextpath(i : Int32)
      fun gr_settextalign(i : Int32, i1 : Int32)
      fun gr_setfillintstyle(i : Int32)
      fun gr_setfillstyle(i : Int32)
      fun gr_setfillcolorind(i : Int32)
      fun gr_setwindow(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64)
      fun gr_setviewport(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64)
      fun gr_selntran(i : Int32)
      fun gr_setclip(i : Int32)
      fun gr_setwswindow(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64)
      fun gr_setwsviewport(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64)
      fun gr_createseg(i : Int32)
      fun gr_copysegws(i : Int32)
      fun gr_redrawsegws
      fun gr_setspace(x : Float64, x1 : Float64, i : Int32, i1 : Int32)
      fun gr_setscale(i : Int32)
      fun gr_textext(x : Float64, x : Float64, c : UInt8*) : Int32
      fun gr_grid(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64,
                  i : Int32, i1 : Int32)
      fun gr_verrorbars(i : Int32, xa : Float64*, xb : Float64*, xc : Float64*, xd : Float64*)
      fun gr_herrorbars(i : Int32, xa : Float64*, xb : Float64*, xc : Float64*, xd : Float64*)
      fun gr_polyline3d(i : Int32, xa : Float64*, xb : Float64*, xc : Float64*)
      fun gr_polymarker3d(i : Int32, xa : Float64*, xb : Float64*, xc : Float64*)
      fun gr_axes3d(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64,
                    x4 : Float64, x5 : Float64, i : Int32, i1 : Int32, i2 : Int32,
                    x6 : Float64)
      fun gr_titles3d(c : UInt8*, c0 : UInt8*, c1 : UInt8*)
      fun gr_surface(i : Int32, i1 : Int32, xa : Float64*, xb : Float64*, xc : Float64*,
                     i2 : Int32)
      fun gr_contour(i : Int32, i1 : Int32, i2 : Int32, xa : Float64*, xb : Float64*,
                     xc : Float64*, xd : Float64*, i4 : Int32)
      fun gr_contourf(i : Int32, i1 : Int32, i2 : Int32, xa : Float64*, xb : Float64*,
                      xc : Float64*, xd : Float64*, i4 : Int32)
      fun gr_tricontour(i : Int32, xa : Float64*, xb : Float64*, xc : Float64*,
                        i1 : Int32, xd : Float64*)
      fun gr_hexbin(i : Int32, xa : Float64*, xb : Float64*, i1 : Int32)
      fun gr_setcolormap(i : Int32)
      fun gr_inqcolormap(ia : Int32*)
      fun gr_setcolormapfromrgb(i : Int32, xa : Float64*, xb : Float64*, xc : Float64*,
                                xd : Float64*)
      fun gr_colorbar
      fun gr_inqcolor(i : Int32, ia : Int32*)
      fun gr_inqcolorfromrgb(x : Float64, x1 : Float64, x2 : Float64)
      fun gr_hsvtorgb(x : Float64, x1 : Float64, x2 : Float64, xa : Float64*,
                      xb : Float64*, xc : Float64*)
      fun gr_tick(x : Float64, x1 : Float64)
      fun gr_validaterange(x : Float64, x1 : Float64)
      fun gr_adjustlimits(xa : Float64*, xb : Float64*)
      fun gr_adjustrange(xa : Float64*, xb : Float64*)
      fun gr_beginprint(c : UInt8*)
      fun gr_beginprintext(c : UInt8*, c1 : UInt8*, c2 : UInt8*, c3 : UInt8*)
      fun gr_endprint
      fun gr_ndctowc(xa : Float64*, xb : Float64*)
      fun gr_wctondc(xa : Float64*, xb : Float64*)
      fun gr_wc3towc(xa : Float64*, xb : Float64*, xc : Float64*)

      fun gr_drawrect(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64)
      fun gr_fillrect(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64)
      fun gr_drawarc(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64, x4 : Float64, x5 : Float64)
      fun gr_fillarc(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64, x4 : Float64, x5 : Float64)
      fun gr_setarrowstyle(i : Int32)
      fun gr_setarrowsize(x : Float64)
      fun gr_drawarrow(x : Float64, x1 : Float64, x2 : Float64, x3 : Float64)

      fun gr_shadepoints(i1 : Int32, x1 : Float64*, x2 : Float64*, i2 : Int32, i3 : Int32, i4 : Int32)
    end
  end
end
