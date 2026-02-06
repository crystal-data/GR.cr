module GR
  {% if env("GRDIR") %}
    @[Link(ldflags: "-L `echo $GRDIR/lib` -lGR -Wl,-rpath,`echo $GRDIR/lib`")]
  {% else %}
    @[Link("gr")]
  {% end %}
  lib LibGR
    # Structures
    struct VertexT
      x : LibC::Double
      y : LibC::Double
    end

    # Three-dimensional coordinate
    struct Point3dT
      x : LibC::Double
      y : LibC::Double
      z : LibC::Double
    end

    # Data point for gr_volume_nogrid
    struct DataPoint3dT
      pt : Point3dT       # Coordinates of data point
      data : LibC::Double # Intensity of data point
    end

    # Provides optional extra data for gr_volume_interp_gauss
    struct GuessT
      sqrt_det : LibC::Double # Square root of determinant of covariance matrix
      gauss_sig_1 : Point3dT
      gauss_sig_2 : Point3dT
      gauss_sig_3 : Point3dT # Σ^(-1/2) encoded as three column vectors
    end

    # Provides optional extra data for gr_volume_interp_tri_linear
    struct TriLinearT
      grid_x_re : LibC::Double # Reciprocal of interpolation kernel extent in x-direction
      grid_y_re : LibC::Double # Reciprocal of interpolation kernel extent in y-direction
      grid_z_re : LibC::Double # Reciprocal of interpolation kernel extent in z-direction
    end

    struct CpuBasedVolume2PassT
      dmin : LibC::Double
      dmax : LibC::Double
      action : LibC::Int
      priv : CpubasedvolumePassPrivT*
    end

    struct Hexbin2PassT
      nc : LibC::Int
      cntmax : LibC::Int
      action : LibC::Int
      priv : HexbinPassPrivT*
    end

    # Type aliases
    alias KernelF = Void* # Function pointer type
    alias RadiusF = Void* # Function pointer type
    alias Interp2MethodT = LibC::Int
    alias AxisT = Void*
    alias FormatReferenceT = Void*
    alias CpubasedvolumePassPrivT = Void*
    alias HexbinPassPrivT = Void*

    # Basic GKS functions
    fun initgr = gr_initgr
    fun debug = gr_debug : LibC::Int
    fun opengks = gr_opengks
    fun closegks = gr_closegks
    fun inqdspsize = gr_inqdspsize(mwidth : LibC::Double*, mheight : LibC::Double*, width : LibC::Int*, height : LibC::Int*)
    fun openws = gr_openws(workstation_id : LibC::Int, connection : LibC::Char*, workstation_type : LibC::Int)
    fun closews = gr_closews(workstation_id : LibC::Int)
    fun activatews = gr_activatews(workstation_id : LibC::Int)
    fun deactivatews = gr_deactivatews(workstation_id : LibC::Int)
    fun configurews = gr_configurews
    fun clearws = gr_clearws
    fun updatews = gr_updatews

    # Basic drawing functions
    fun polyline = gr_polyline(n : LibC::Int, x : LibC::Double*, y : LibC::Double*)
    fun polymarker = gr_polymarker(n : LibC::Int, x : LibC::Double*, y : LibC::Double*)
    fun text = gr_text(x : LibC::Double, y : LibC::Double, string : LibC::Char*)
    fun textx = gr_textx(x : LibC::Double, y : LibC::Double, string : LibC::Char*, opts : LibC::Int)
    fun inqtext = gr_inqtext(x : LibC::Double, y : LibC::Double, string : LibC::Char*, tbx : LibC::Double*, tby : LibC::Double*)
    fun inqtextx = gr_inqtextx(x : LibC::Double, y : LibC::Double, string : LibC::Char*, opts : LibC::Int, tbx : LibC::Double*, tby : LibC::Double*)
    fun fillarea = gr_fillarea(n : LibC::Int, x : LibC::Double*, y : LibC::Double*)
    fun cellarray = gr_cellarray(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double, dx : LibC::Int, dy : LibC::Int, scol : LibC::Int, srow : LibC::Int, ncol : LibC::Int, nrow : LibC::Int, color : LibC::Int*)
    fun nonuniformcellarray = gr_nonuniformcellarray(x : LibC::Double*, y : LibC::Double*, dx : LibC::Int, dy : LibC::Int, scol : LibC::Int, srow : LibC::Int, ncol : LibC::Int, nrow : LibC::Int, color : LibC::Int*)
    fun polarcellarray = gr_polarcellarray(xorg : LibC::Double, yorg : LibC::Double, phimin : LibC::Double, phimax : LibC::Double, rmin : LibC::Double, rmax : LibC::Double, dphi : LibC::Int, dr : LibC::Int, scol : LibC::Int, srow : LibC::Int, ncol : LibC::Int, nrow : LibC::Int, color : LibC::Int*)
    fun nonuniformpolarcellarray = gr_nonuniformpolarcellarray(xorg : LibC::Double, yorg : LibC::Double, phi : LibC::Double*, r : LibC::Double*, dphi : LibC::Int, dr : LibC::Int, scol : LibC::Int, srow : LibC::Int, ncol : LibC::Int, nrow : LibC::Int, color : LibC::Int*)
    fun gdp = gr_gdp(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, primid : LibC::Int, ldr : LibC::Int, datrec : LibC::Int*)
    fun spline = gr_spline(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, m : LibC::Int, method : LibC::Int)
    fun gridit = gr_gridit(nd : LibC::Int, xd : LibC::Double*, yd : LibC::Double*, zd : LibC::Double*, nx : LibC::Int, ny : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*)

    # Line attributes
    fun setlinetype = gr_setlinetype(type : LibC::Int)
    fun inqlinetype = gr_inqlinetype(type : LibC::Int*)
    fun setlinewidth = gr_setlinewidth(width : LibC::Double)
    fun inqlinewidth = gr_inqlinewidth(width : LibC::Double*)
    fun setlinecolorind = gr_setlinecolorind(color : LibC::Int)
    fun inqlinecolorind = gr_inqlinecolorind(color : LibC::Int*)

    # Marker attributes
    fun setmarkertype = gr_setmarkertype(type : LibC::Int)
    fun inqmarkertype = gr_inqmarkertype(type : LibC::Int*)
    fun setmarkersize = gr_setmarkersize(size : LibC::Double)
    fun inqmarkersize = gr_inqmarkersize(size : LibC::Double*)
    fun setmarkercolorind = gr_setmarkercolorind(color : LibC::Int)
    fun inqmarkercolorind = gr_inqmarkercolorind(color : LibC::Int*)

    # Text attributes
    fun settextfontprec = gr_settextfontprec(font : LibC::Int, precision : LibC::Int)
    fun setcharexpan = gr_setcharexpan(factor : LibC::Double)
    fun setcharspace = gr_setcharspace(spacing : LibC::Double)
    fun settextcolorind = gr_settextcolorind(color : LibC::Int)
    fun inqtextcolorind = gr_inqtextcolorind(color : LibC::Int*)
    fun setcharheight = gr_setcharheight(height : LibC::Double)
    fun setwscharheight = gr_setwscharheight(chh : LibC::Double, height : LibC::Double)
    fun inqcharheight = gr_inqcharheight(height : LibC::Double*)
    fun setcharup = gr_setcharup(ux : LibC::Double, uy : LibC::Double)
    fun settextpath = gr_settextpath(path : LibC::Int)
    fun settextalign = gr_settextalign(horizontal : LibC::Int, vertical : LibC::Int)

    # Fill area attributes
    fun setfillintstyle = gr_setfillintstyle(style : LibC::Int)
    fun inqfillintstyle = gr_inqfillintstyle(style : LibC::Int*)
    fun setfillstyle = gr_setfillstyle(index : LibC::Int)
    fun inqfillstyle = gr_inqfillstyle(index : LibC::Int*)
    fun setfillcolorind = gr_setfillcolorind(color : LibC::Int)
    fun inqfillcolorind = gr_inqfillcolorind(color : LibC::Int*)
    fun setnominalsize = gr_setnominalsize(size : LibC::Double)
    fun inqnominalsize = gr_inqnominalsize(size : LibC::Double*)

    # Color functions
    fun setcolorrep = gr_setcolorrep(index : LibC::Int, red : LibC::Double, green : LibC::Double, blue : LibC::Double)

    # Transformation functions
    fun setwindow = gr_setwindow(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double)
    fun inqwindow = gr_inqwindow(xmin : LibC::Double*, xmax : LibC::Double*, ymin : LibC::Double*, ymax : LibC::Double*)
    fun setviewport = gr_setviewport(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double)
    fun inqviewport = gr_inqviewport(xmin : LibC::Double*, xmax : LibC::Double*, ymin : LibC::Double*, ymax : LibC::Double*)
    fun selntran = gr_selntran(transform : LibC::Int)
    fun setclip = gr_setclip(indicator : LibC::Int)
    fun setwswindow = gr_setwswindow(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double)
    fun setwsviewport = gr_setwsviewport(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double)

    # Segment functions
    fun createseg = gr_createseg(segment : LibC::Int)
    fun copysegws = gr_copysegws(segment : LibC::Int)
    fun redrawsegws = gr_redrawsegws
    fun setsegtran = gr_setsegtran(segment : LibC::Int, fx : LibC::Double, fy : LibC::Double, transx : LibC::Double, transy : LibC::Double, phi : LibC::Double, scalex : LibC::Double, scaley : LibC::Double)
    fun closeseg = gr_closeseg
    fun samplelocator = gr_samplelocator(x : LibC::Double*, y : LibC::Double*, stat : LibC::Int*)
    fun emergencyclosegks = gr_emergencyclosegks
    fun updategks = gr_updategks

    # Coordinate system functions
    fun setspace = gr_setspace(zmin : LibC::Double, zmax : LibC::Double, rotation : LibC::Int, tilt : LibC::Int) : LibC::Int
    fun inqspace = gr_inqspace(zmin : LibC::Double*, zmax : LibC::Double*, rotation : LibC::Int*, tilt : LibC::Int*)
    fun setscale = gr_setscale(options : LibC::Int) : LibC::Int
    fun inqscale = gr_inqscale(options : LibC::Int*)
    fun textext = gr_textext(x : LibC::Double, y : LibC::Double, string : LibC::Char*) : LibC::Int
    fun inqtextext = gr_inqtextext(x : LibC::Double, y : LibC::Double, string : LibC::Char*, tbx : LibC::Double*, tby : LibC::Double*)
    fun setscientificformat = gr_setscientificformat(format_option : LibC::Int)

    # Axes and grid functions
    fun axes = gr_axes(x_tick : LibC::Double, y_tick : LibC::Double, x_org : LibC::Double, y_org : LibC::Double, major_x : LibC::Int, major_y : LibC::Int, tick_size : LibC::Double)
    fun axeslbl = gr_axeslbl(x_tick : LibC::Double, y_tick : LibC::Double, x_org : LibC::Double, y_org : LibC::Double, major_x : LibC::Int, major_y : LibC::Int, tick_size : LibC::Double, fpx : (LibC::Double, LibC::Double, LibC::Char*, LibC::Double -> Void), fpy : (LibC::Double, LibC::Double, LibC::Char*, LibC::Double -> Void))
    fun axis = gr_axis(which : LibC::Char, axis : AxisT*)
    fun drawaxis = gr_drawaxis(which : LibC::Char, axis : AxisT*)
    fun drawaxes = gr_drawaxes(x_axis : AxisT*, y_axis : AxisT*, options : LibC::Int)
    fun freeaxis = gr_freeaxis(axis : AxisT*)
    fun grid = gr_grid(x_tick : LibC::Double, y_tick : LibC::Double, x_org : LibC::Double, y_org : LibC::Double, major_x : LibC::Int, major_y : LibC::Int)
    fun grid3d = gr_grid3d(x_tick : LibC::Double, y_tick : LibC::Double, z_tick : LibC::Double, x_org : LibC::Double, y_org : LibC::Double, z_org : LibC::Double, major_x : LibC::Int, major_y : LibC::Int, major_z : LibC::Int)

    # Error bars
    fun verrorbars = gr_verrorbars(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, e1 : LibC::Double*, e2 : LibC::Double*)
    fun herrorbars = gr_herrorbars(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, e1 : LibC::Double*, e2 : LibC::Double*)

    # 3D functions
    fun polyline3d = gr_polyline3d(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*)
    fun polymarker3d = gr_polymarker3d(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*)
    fun axes3d = gr_axes3d(x_tick : LibC::Double, y_tick : LibC::Double, z_tick : LibC::Double, x_org : LibC::Double, y_org : LibC::Double, z_org : LibC::Double, major_x : LibC::Int, major_y : LibC::Int, major_z : LibC::Int, tick_size : LibC::Double)
    fun titles3d = gr_titles3d(x_title : LibC::Char*, y_title : LibC::Char*, z_title : LibC::Char*)
    fun settitles3d = gr_settitles3d(x_title : LibC::Char*, y_title : LibC::Char*, z_title : LibC::Char*)
    fun surface = gr_surface(nx : LibC::Int, ny : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*, option : LibC::Int)
    fun contour = gr_contour(nx : LibC::Int, ny : LibC::Int, nh : LibC::Int, x : LibC::Double*, y : LibC::Double*, h : LibC::Double*, z : LibC::Double*, major_h : LibC::Int)
    fun contourf = gr_contourf(nx : LibC::Int, ny : LibC::Int, nh : LibC::Int, x : LibC::Double*, y : LibC::Double*, h : LibC::Double*, z : LibC::Double*, major_h : LibC::Int)
    fun tricontour = gr_tricontour(npoints : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*, nlevels : LibC::Int, levels : LibC::Double*)
    fun hexbin = gr_hexbin(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, nbins : LibC::Int) : LibC::Int
    fun hexbin_2pass = gr_hexbin_2pass(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, nbins : LibC::Int, previous_state : Hexbin2PassT*) : Hexbin2PassT*

    # Color map functions
    fun setcolormap = gr_setcolormap(index : LibC::Int)
    fun inqcolormap = gr_inqcolormap(index : LibC::Int*)
    fun setcolormapfromrgb = gr_setcolormapfromrgb(n : LibC::Int, r : LibC::Double*, g : LibC::Double*, b : LibC::Double*, x : LibC::Double*)
    fun inqcolormapinds = gr_inqcolormapinds(start : LibC::Int*, end : LibC::Int*)
    fun colorbar = gr_colorbar
    fun inqcolor = gr_inqcolor(color : LibC::Int, rgb : LibC::Int*)
    fun inqcolorfromrgb = gr_inqcolorfromrgb(red : LibC::Double, green : LibC::Double, blue : LibC::Double) : LibC::Int
    fun hsvtorgb = gr_hsvtorgb(h : LibC::Double, s : LibC::Double, v : LibC::Double, r : LibC::Double*, g : LibC::Double*, b : LibC::Double*)

    # Utility functions
    fun tick = gr_tick(amin : LibC::Double, amax : LibC::Double) : LibC::Double
    fun validaterange = gr_validaterange(amin : LibC::Double, amax : LibC::Double) : LibC::Int
    fun adjustlimits = gr_adjustlimits(amin : LibC::Double*, amax : LibC::Double*)
    fun adjustrange = gr_adjustrange(amin : LibC::Double*, amax : LibC::Double*)

    # Print functions
    fun beginprint = gr_beginprint(pathname : LibC::Char*)
    fun beginprintext = gr_beginprintext(pathname : LibC::Char*, mode : LibC::Char*, fmt : LibC::Char*, orientation : LibC::Char*)
    fun endprint = gr_endprint

    # Coordinate transformation
    fun ndctowc = gr_ndctowc(x : LibC::Double*, y : LibC::Double*)
    fun wctondc = gr_wctondc(x : LibC::Double*, y : LibC::Double*)
    fun wc3towc = gr_wc3towc(x : LibC::Double*, y : LibC::Double*, z : LibC::Double*)

    # Drawing primitives
    fun drawrect = gr_drawrect(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double)
    fun fillrect = gr_fillrect(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double)
    fun drawarc = gr_drawarc(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double, a1 : LibC::Double, a2 : LibC::Double)
    fun fillarc = gr_fillarc(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double, a1 : LibC::Double, a2 : LibC::Double)
    fun drawpath = gr_drawpath(n : LibC::Int, vertices : VertexT*, codes : UInt8*, fill : LibC::Int)

    # Arrow functions
    fun setarrowstyle = gr_setarrowstyle(style : LibC::Int)
    fun setarrowsize = gr_setarrowsize(size : LibC::Double)
    fun drawarrow = gr_drawarrow(x1 : LibC::Double, y1 : LibC::Double, x2 : LibC::Double, y2 : LibC::Double)

    # Image functions
    fun readimage = gr_readimage(path : LibC::Char*, width : LibC::Int*, height : LibC::Int*, data : LibC::Int**) : LibC::Int
    fun drawimage = gr_drawimage(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double, width : LibC::Int, height : LibC::Int, data : LibC::Int*, model : LibC::Int)
    fun importgraphics = gr_importgraphics(path : LibC::Char*) : LibC::Int

    # Effects
    fun setshadow = gr_setshadow(offsetx : LibC::Double, offsety : LibC::Double, blur : LibC::Double)
    fun settransparency = gr_settransparency(alpha : LibC::Double)
    fun inqtransparency = gr_inqtransparency(alpha : LibC::Double*)
    fun setcoordxform = gr_setcoordxform(mat : LibC::Double*)

    # Graphics state
    fun begingraphics = gr_begingraphics(path : LibC::Char*)
    fun endgraphics = gr_endgraphics
    fun getgraphics = gr_getgraphics : LibC::Char*
    fun drawgraphics = gr_drawgraphics(string : LibC::Char*) : LibC::Int
    fun startlistener = gr_startlistener : LibC::Int
    fun inqgrplotport = gr_inqgrplotport : LibC::Int
    fun setgrplotport = gr_setgrplotport(port : LibC::Int) : LibC::Int

    # Math TeX
    fun mathtex = gr_mathtex(x : LibC::Double, y : LibC::Double, string : LibC::Char*)
    fun inqmathtex = gr_inqmathtex(x : LibC::Double, y : LibC::Double, string : LibC::Char*, tbx : LibC::Double*, tby : LibC::Double*)
    fun mathtex3d = gr_mathtex3d(x : LibC::Double, y : LibC::Double, z : LibC::Double, string : LibC::Char*, axis : LibC::Int)
    fun inqmathtex3d = gr_inqmathtex3d(x : LibC::Double, y : LibC::Double, z : LibC::Double, string : LibC::Char*, axis : LibC::Int, tbx : LibC::Double*, tby : LibC::Double*, tbz : LibC::Double*, tby2 : LibC::Double*)

    # Selection
    fun beginselection = gr_beginselection(index : LibC::Int, type : LibC::Int)
    fun endselection = gr_endselection
    fun setbboxcallback = gr_setbboxcallback(type : LibC::Int, bbox_cb : (LibC::Int, LibC::Double, LibC::Double, LibC::Double, LibC::Double -> Void), hit_cb : (LibC::UInt, LibC::UInt, LibC::UInt* -> Void))
    fun cancelbboxcallback = gr_cancelbboxcallback
    fun beginpartial = gr_beginpartial(type : LibC::Int, callback : (LibC::Int, LibC::UInt, LibC::UInt, LibC::UInt, LibC::UInt, LibC::UInt* -> Void))
    fun endpartial = gr_endpartial(type : LibC::Int)
    fun moveselection = gr_moveselection(x : LibC::Double, y : LibC::Double)
    fun resizeselection = gr_resizeselection(type : LibC::Int, x : LibC::Double, y : LibC::Double)
    fun inqbbox = gr_inqbbox(xmin : LibC::Double*, xmax : LibC::Double*, ymin : LibC::Double*, ymax : LibC::Double*)

    # Background
    fun setbackground = gr_setbackground(red : LibC::Double, green : LibC::Double, blue : LibC::Double, alpha : LibC::Double)
    fun clearbackground = gr_clearbackground

    # System information
    fun precision = gr_precision : LibC::Double
    fun text_maxsize = gr_text_maxsize : LibC::Int
    fun setregenflags = gr_setregenflags(flags : LibC::Int)
    fun inqregenflags = gr_inqregenflags : LibC::Int

    # Context management
    fun savestate = gr_savestate
    fun restorestate = gr_restorestate
    fun savecontext = gr_savecontext(context : LibC::Int)
    fun selectcontext = gr_selectcontext(context : LibC::Int)
    fun destroycontext = gr_destroycontext(context : LibC::Int)
    fun unselectcontext = gr_unselectcontext

    # Line specification
    fun uselinespec = gr_uselinespec(linespec : LibC::Char*) : LibC::Int

    # Advanced functions
    fun delaunay = gr_delaunay(npoints : LibC::Int, x : LibC::Double*, y : LibC::Double*, ntri : LibC::Int*, triangles : LibC::Int**)
    fun reducepoints = gr_reducepoints(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, n_out : LibC::Int, x_out : LibC::Double*, y_out : LibC::Double*)
    fun trisurface = gr_trisurface(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*)
    fun gradient = gr_gradient(nx : LibC::Int, ny : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*, u : LibC::Double*, v : LibC::Double*)
    fun quiver = gr_quiver(nx : LibC::Int, ny : LibC::Int, x : LibC::Double*, y : LibC::Double*, u : LibC::Double*, v : LibC::Double*, color : LibC::Int)
    fun interp2 = gr_interp2(nx : LibC::Int, ny : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*, nxq : LibC::Int, nyq : LibC::Int, xq : LibC::Double*, yq : LibC::Double*, zq : LibC::Double*, method : Interp2MethodT, extrapval : LibC::Double)

    # Version
    fun version = gr_version : LibC::Char*

    # Shading
    fun shade = gr_shade(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, lines : LibC::Int, flip : LibC::Int, h : LibC::Double*, xform : LibC::Int, bins : LibC::Int, dims : LibC::Int*)
    fun shadepoints = gr_shadepoints(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, xform : LibC::Int, w : LibC::Int, h : LibC::Int)
    fun shadelines = gr_shadelines(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, xform : LibC::Int, w : LibC::Int, h : LibC::Int)

    # Pan and zoom
    fun panzoom = gr_panzoom(x : LibC::Double, y : LibC::Double, zoom : LibC::Double, angle : LibC::Double, xmin : LibC::Double*, xmax : LibC::Double*, ymin : LibC::Double*, ymax : LibC::Double*)

    # Boundary finding
    fun findboundary = gr_findboundary(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, threshold : LibC::Double, callback : (LibC::Double, LibC::Double -> LibC::Double), orientation : LibC::Int, n_out : LibC::Int*) : LibC::Int

    # Resampling
    fun setresamplemethod = gr_setresamplemethod(flag : LibC::UInt)
    fun inqresamplemethod = gr_inqresamplemethod(flag : LibC::UInt*)

    # Path
    fun path = gr_path(n : LibC::Int, x : LibC::Double*, y : LibC::Double*, codes : LibC::Char*)

    # Border
    fun setborderwidth = gr_setborderwidth(width : LibC::Double)
    fun inqborderwidth = gr_inqborderwidth(width : LibC::Double*)
    fun setbordercolorind = gr_setbordercolorind(color : LibC::Int)
    fun inqbordercolorind = gr_inqbordercolorind(color : LibC::Int*)

    # Clipping
    fun selectclipxform = gr_selectclipxform(transform : LibC::Int)
    fun inqclipxform = gr_inqclipxform(transform : LibC::Int*)
    fun inqclip = gr_inqclip(indicator : LibC::Int*, rectangle : LibC::Double*)

    # 3D projection
    fun setprojectiontype = gr_setprojectiontype(type : LibC::Int)
    fun inqprojectiontype = gr_inqprojectiontype(type : LibC::Int*)
    fun setperspectiveprojection = gr_setperspectiveprojection(near_plane : LibC::Double, far_plane : LibC::Double, fov : LibC::Double)
    fun inqperspectiveprojection = gr_inqperspectiveprojection(near_plane : LibC::Double*, far_plane : LibC::Double*, fov : LibC::Double*)
    fun settransformationparameters = gr_settransformationparameters(phi : LibC::Double, theta : LibC::Double, psi : LibC::Double, tx : LibC::Double, ty : LibC::Double, tz : LibC::Double, sx : LibC::Double, sy : LibC::Double, sz : LibC::Double)
    fun inqtransformationparameters = gr_inqtransformationparameters(phi : LibC::Double*, theta : LibC::Double*, psi : LibC::Double*, tx : LibC::Double*, ty : LibC::Double*, tz : LibC::Double*, sx : LibC::Double*, sy : LibC::Double*, sz : LibC::Double*)
    fun setorthographicprojection = gr_setorthographicprojection(left : LibC::Double, right : LibC::Double, bottom : LibC::Double, top : LibC::Double, near_plane : LibC::Double, far_plane : LibC::Double)
    fun inqorthographicprojection = gr_inqorthographicprojection(left : LibC::Double*, right : LibC::Double*, bottom : LibC::Double*, top : LibC::Double*, near_plane : LibC::Double*, far_plane : LibC::Double*)
    fun camerainteraction = gr_camerainteraction(rotate_x : LibC::Double, rotate_y : LibC::Double, rotate_z : LibC::Double, zoom : LibC::Double)

    # 3D window and space
    fun setwindow3d = gr_setwindow3d(xmin : LibC::Double, xmax : LibC::Double, ymin : LibC::Double, ymax : LibC::Double, zmin : LibC::Double, zmax : LibC::Double)
    fun inqwindow3d = gr_inqwindow3d(xmin : LibC::Double*, xmax : LibC::Double*, ymin : LibC::Double*, ymax : LibC::Double*, zmin : LibC::Double*, zmax : LibC::Double*)
    fun setscalefactors3d = gr_setscalefactors3d(x_axis_scale : LibC::Double, y_axis_scale : LibC::Double, z_axis_scale : LibC::Double)
    fun inqscalefactors3d = gr_inqscalefactors3d(x_axis_scale : LibC::Double*, y_axis_scale : LibC::Double*, z_axis_scale : LibC::Double*)
    fun setspace3d = gr_setspace3d(phi : LibC::Double, theta : LibC::Double, fov : LibC::Double, camera_distance : LibC::Double)
    fun inqspace3d = gr_inqspace3d(rotation : LibC::Int*, phi : LibC::Double*, theta : LibC::Double*, fov : LibC::Double*, camera_distance : LibC::Double*)

    # 3D text
    fun text3d = gr_text3d(x : LibC::Double, y : LibC::Double, z : LibC::Double, string : LibC::Char*, axis : LibC::Int)
    fun inqtext3d = gr_inqtext3d(x : LibC::Double, y : LibC::Double, z : LibC::Double, string : LibC::Char*, axis : LibC::Int, tbx : LibC::Double*, tby : LibC::Double*)

    # Text encoding and fonts
    fun settextencoding = gr_settextencoding(encoding : LibC::Int)
    fun inqtextencoding = gr_inqtextencoding(encoding : LibC::Int*)
    fun loadfont = gr_loadfont(filename : LibC::Char*, font_index : LibC::Int*)
    fun setcallback = gr_setcallback(callback : (LibC::Char* -> LibC::Char*))

    # Threading and volume rendering
    fun setthreadnumber = gr_setthreadnumber(num : LibC::Int)
    fun setpicturesizeforvolume = gr_setpicturesizeforvolume(width : LibC::Int, height : LibC::Int)
    fun setvolumebordercalculation = gr_setvolumebordercalculation(flag : LibC::Int)
    fun setapproximativecalculation = gr_setapproximativecalculation(flag : LibC::Int)
    fun inqvolumeflags = gr_inqvolumeflags(width : LibC::Int*, height : LibC::Int*, border : LibC::Int*, approximation : LibC::Int*, thread_num : LibC::Int*)

    # Volume rendering
    fun cpubasedvolume = gr_cpubasedvolume(nx : LibC::Int, ny : LibC::Int, nz : LibC::Int, data : LibC::Double*, algorithm : LibC::Int, dmin : LibC::Double*, dmax : LibC::Double*, x : LibC::Double*, y : LibC::Double*)
    fun cpubasedvolume_2pass = gr_cpubasedvolume_2pass(nx : LibC::Int, ny : LibC::Int, nz : LibC::Int, data : LibC::Double*, algorithm : LibC::Int, dmin : LibC::Double*, dmax : LibC::Double*, x : LibC::Double*, y : LibC::Double*, previous_state : CpuBasedVolume2PassT*) : CpuBasedVolume2PassT*

    # Viewport size inquiry
    fun inqvpsize = gr_inqvpsize(width : LibC::Int*, height : LibC::Int*, device_pixel_ratio : LibC::Double*)

    # 3D polygon mesh
    fun polygonmesh3d = gr_polygonmesh3d(npoints : LibC::Int, x : LibC::Double*, y : LibC::Double*, z : LibC::Double*, nfaces : LibC::Int, faces : LibC::Int*, colors : LibC::Int*)

    # Volume rendering with custom kernels
    fun volume_nogrid = gr_volume_nogrid(n : LibC::ULong, points : DataPoint3dT*, extra_data : Void*, algorithm : LibC::Int, kernel : KernelF, dmin : LibC::Double*, dmax : LibC::Double*, max_threads : LibC::Double, radius : RadiusF)
    fun volume_interp_tri_linear_init = gr_volume_interp_tri_linear_init(x_extent : LibC::Double, y_extent : LibC::Double, z_extent : LibC::Double)
    fun volume_interp_gauss_init = gr_volume_interp_gauss_init(c : LibC::Double, sigma : LibC::Double*)
    fun volume_interp_tri_linear = gr_volume_interp_tri_linear(points : DataPoint3dT*, extra_data : Void*, grid_point : Point3dT*, extent : Point3dT*) : LibC::Double
    fun volume_interp_gauss = gr_volume_interp_gauss(points : DataPoint3dT*, extra_data : Void*, grid_point : Point3dT*, extent : Point3dT*) : LibC::Double

    # Math font
    fun setmathfont = gr_setmathfont(font : LibC::Int)
    fun inqmathfont = gr_inqmathfont(font : LibC::Int*)

    # Clipping region
    fun setclipregion = gr_setclipregion(region : LibC::Int)
    fun inqclipregion = gr_inqclipregion(region : LibC::Int*)
    fun setclipsector = gr_setclipsector(start_angle : LibC::Double, end_angle : LibC::Double)
    fun inqclipsector = gr_inqclipsector(start_angle : LibC::Double*, end_angle : LibC::Double*)

    # Text offset
    fun settextoffset = gr_settextoffset(xoff : LibC::Double, yoff : LibC::Double)

    # Format functions
    fun ftoa = gr_ftoa(string : LibC::Char*, value : LibC::Double, reference : FormatReferenceT*) : LibC::Char*
    fun getformat = gr_getformat(result : FormatReferenceT*, origin : LibC::Double, min : LibC::Double, max : LibC::Double, tick_width : LibC::Double, major : LibC::Int)
  end
end
