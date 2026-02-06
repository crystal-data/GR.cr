require "./libgrm"

module GRM
  # Crystal-style Plot class for method chaining
  class Plot
    @kind : String?
    @title : String?
    @xlabel : String?
    @ylabel : String?
    @zlabel : String?
    @color : String?
    @x_data : Array(Float64)?
    @y_data : Array(Float64)?
    @z_data : Array(Float64)?
    @c_data : Array(Float64)?
    @c_dims : Array(Int32)?
    @z_dims : Array(Int32)?
    @nbins : Int32?
    @m : Int32? # For 2D data dimensions (rows)
    @n : Int32? # For 2D data dimensions (columns)
    @isovalue : Float64?
    @algorithm : String?

    getter kind : String?
    getter color : String?

    def initialize
    end

    # Build args for plotting (series only)
    def build_series_args : LibGRM::ArgsT
      args = GRM.with_error_check("args_new") { LibGRM.args_new }

      kind = @kind || "line"
      args_push(args, "kind", "s", kind)

      case kind
      when "line", "scatter", "barplot", "stairs", "stem", "hexbin"
        push_xy(args)
      when "plot3", "scatter3"
        push_xyz(args)
      when "hist", "polar_histogram"
        push_x(args)
      when "surface", "contour", "contourf"
        push_z_grid(args, include_dims: false)
      when "polar"
        push_xy(args)
      when "heatmap", "shade"
        push_z_grid(args, include_dims: true)
      when "imshow"
        push_c_grid(args, 2)
      when "isosurface"
        push_c_grid(args, 3)
        args_push(args, "isovalue", "d", @isovalue.not_nil!) if @isovalue
      when "volume"
        push_c_grid(args, 3)
        args_push(args, "algorithm", "s", @algorithm.not_nil!) if @algorithm
      else
        raise ArgumentError.new("unsupported kind: #{kind}")
      end

      args_push(args, "color", "s", @color.not_nil!) if @color
      args_push(args, "nbins", "i", @nbins.not_nil!) if @nbins

      args
    end

    # Build args for standalone plotting (series + labels)
    private def build_args : LibGRM::ArgsT
      args = build_series_args
      args_push(args, "title", "s", @title.not_nil!) if @title
      args_push(args, "xlabel", "s", @xlabel.not_nil!) if @xlabel
      args_push(args, "ylabel", "s", @ylabel.not_nil!) if @ylabel
      args_push(args, "zlabel", "s", @zlabel.not_nil!) if @zlabel
      args
    end

    # Data setting methods (chainable)
    def data(x : Array(Number))
      @x_data = x.map(&.to_f64)
      self
    end

    def data(x : Array(Number), y : Array(Number))
      raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size
      @x_data = x.map(&.to_f64)
      @y_data = y.map(&.to_f64)
      self
    end

    def data(x : Array(Number), y : Array(Number), z : Array(Number))
      raise ArgumentError.new("x, y, and z arrays must have the same size") if x.size != y.size || x.size != z.size
      @x_data = x.map(&.to_f64)
      @y_data = y.map(&.to_f64)
      @z_data = z.map(&.to_f64)
      self
    end

    # 2D data helper for surface/contourf/heatmap/shade (z: rows x cols)
    def data2d(x : Array(Number), y : Array(Number), z : Array(Array(Number)))
      raise ArgumentError.new("z must be non-empty") if z.empty?
      rows = z.size
      cols = z.first.size
      raise ArgumentError.new("all rows of z must have the same length") unless z.all? { |row| row.size == cols }
      raise ArgumentError.new("x length must equal columns (#{x.size} != #{cols})") unless x.size == cols
      raise ArgumentError.new("y length must equal rows (#{y.size} != #{rows})") unless y.size == rows

      @x_data = x.map(&.to_f64)
      @y_data = y.map(&.to_f64)
      @z_data = z.flatten.map(&.to_f64)
      @z_dims = [rows, cols]
      @m = rows
      @n = cols
      self
    end

    def data_z(z : Array(Array(Number)))
      raise ArgumentError.new("z must be non-empty") if z.empty?
      rows = z.size
      cols = z.first.size
      raise ArgumentError.new("all rows of z must have the same length") unless z.all? { |row| row.size == cols }

      @z_data = z.flatten.map(&.to_f64)
      @z_dims = [rows, cols]
      @m = rows
      @n = cols
      self
    end

    def data_image(c : Array(Array(Number)))
      raise ArgumentError.new("c must be non-empty") if c.empty?
      rows = c.size
      cols = c.first.size
      raise ArgumentError.new("all rows of c must have the same length") unless c.all? { |row| row.size == cols }

      @c_data = c.flatten.map(&.to_f64)
      @c_dims = [cols, rows]
      self
    end

    def data_volume(c : Array(Array(Array(Number))))
      raise ArgumentError.new("c must be non-empty") if c.empty?
      dim_x = c.size
      dim_y = c.first.size
      dim_z = c.first.first.size
      raise ArgumentError.new("all rows must have the same length") unless c.all? { |row| row.size == dim_y }
      raise ArgumentError.new("all columns must have the same length") unless c.all? { |row| row.all? { |col| col.size == dim_z } }

      flattened = [] of Float64
      c.each do |plane|
        plane.each do |row|
          row.each do |value|
            flattened << value.to_f64
          end
        end
      end

      @c_data = flattened
      @c_dims = [dim_x, dim_y, dim_z]
      self
    end

    # Plot type methods (chainable)
    def scatter
      @kind = "scatter"
      self
    end

    def barplot
      @kind = "barplot"
      self
    end

    def stairs
      @kind = "stairs"
      self
    end

    def stem
      @kind = "stem"
      self
    end

    def hexbin
      @kind = "hexbin"
      self
    end

    def histogram(bins : Int32 = 50)
      @kind = "hist"
      @nbins = bins
      self
    end

    def plot3
      @kind = "plot3"
      self
    end

    def scatter3
      @kind = "scatter3"
      self
    end

    def surface(m : Int32? = nil, n : Int32? = nil)
      @kind = "surface"
      @m = m if m
      @n = n if n
      self
    end

    def contourf(m : Int32? = nil, n : Int32? = nil)
      @kind = "contourf"
      @m = m if m
      @n = n if n
      self
    end

    def contour(m : Int32? = nil, n : Int32? = nil)
      @kind = "contour"
      @m = m if m
      @n = n if n
      self
    end

    def heatmap(m : Int32? = nil, n : Int32? = nil)
      @kind = "heatmap"
      @m = m if m
      @n = n if n
      self
    end

    def imshow
      @kind = "imshow"
      self
    end

    def isosurface
      @kind = "isosurface"
      self
    end

    def polarhistogram
      @kind = "polar_histogram"
      self
    end

    def polar
      @kind = "polar"
      self
    end

    def shade(m : Int32? = nil, n : Int32? = nil)
      @kind = "shade"
      @m = m if m
      @n = n if n
      self
    end

    def volume
      @kind = "volume"
      self
    end

    def isovalue(value : Number)
      @isovalue = value.to_f64
      self
    end

    def algorithm(value : String)
      @algorithm = value
      self
    end

    # Label methods (chainable)
    def title(text : String)
      @title = text
      self
    end

    def xlabel(text : String)
      @xlabel = text
      self
    end

    def ylabel(text : String)
      @ylabel = text
      self
    end

    def zlabel(text : String)
      @zlabel = text
      self
    end

    def color(color : String)
      @color = color
      self
    end

    # Rendering and output methods
    def show
      args = build_args
      GRM.with_error_check("clear") { LibGRM.clear }
      GRM.with_error_check("plot") { LibGRM.plot(args) }
      GRM.with_error_check("args_delete") { LibGRM.args_delete(args) }
      self
    end

    def render
      GRM.with_error_check("render") { LibGRM.render }
      self
    end

    def save(path : String)
      args = build_args
      GRM.with_error_check("plot") { LibGRM.plot(args) }
      GRM.with_error_check("export") { LibGRM.export(path) }
      GRM.with_error_check("args_delete") { LibGRM.args_delete(args) }
      self
    end

    def to_html(plot_id : String? = nil) : String
      show
      html_ptr = if plot_id
                   GRM.with_error_check("dump_html") { LibGRM.dump_html(plot_id) }
                 else
                   GRM.with_error_check("dump_html") { LibGRM.dump_html(nil) }
                 end
      String.new(html_ptr)
    end

    def to_json : String
      json_ptr = GRM.with_error_check("dump_json_str") { LibGRM.dump_json_str }
      String.new(json_ptr)
    end

    private def require_x!
      raise ArgumentError.new("x data is required") unless @x_data
    end

    private def require_xy!
      raise ArgumentError.new("x and y data are required") unless @x_data && @y_data
    end

    private def require_xyz!
      raise ArgumentError.new("x, y, and z data are required") unless @x_data && @y_data && @z_data
    end

    private def require_z_grid!
      raise ArgumentError.new("z grid data is required") unless @z_data && @z_dims
    end

    private def require_c_grid!(dims : Int32)
      raise ArgumentError.new("c grid data is required") unless @c_data && @c_dims
      raise ArgumentError.new("c_dims must have length #{dims}") unless @c_dims.not_nil!.size == dims
    end

    private def push_x(args)
      require_x!
      args_push(args, "x", "nD", @x_data.not_nil!.size, @x_data.not_nil!)
    end

    private def push_xy(args)
      require_xy!
      args_push(args, "x", "nD", @x_data.not_nil!.size, @x_data.not_nil!)
      args_push(args, "y", "nD", @y_data.not_nil!.size, @y_data.not_nil!)
    end

    private def push_xyz(args)
      require_xyz!
      args_push(args, "x", "nD", @x_data.not_nil!.size, @x_data.not_nil!)
      args_push(args, "y", "nD", @y_data.not_nil!.size, @y_data.not_nil!)
      args_push(args, "z", "nD", @z_data.not_nil!.size, @z_data.not_nil!)
    end

    private def push_z_grid(args, include_dims : Bool)
      require_z_grid!
      args_push(args, "z", "nD", @z_data.not_nil!.size, @z_data.not_nil!)
      if include_dims
        args_push(args, "z_dims", "ii", @z_dims.not_nil![0], @z_dims.not_nil![1])
      end
      if @x_data
        args_push(args, "x", "nD", @x_data.not_nil!.size, @x_data.not_nil!)
      end
      if @y_data
        args_push(args, "y", "nD", @y_data.not_nil!.size, @y_data.not_nil!)
      end
    end

    private def push_c_grid(args, dims : Int32)
      require_c_grid!(dims)
      args_push(args, "c", "nD", @c_data.not_nil!.size, @c_data.not_nil!)
      if dims == 2
        args_push(args, "c_dims", "ii", @c_dims.not_nil![0], @c_dims.not_nil![1])
      else
        args_push(args, "c_dims", "nI", 3, @c_dims.not_nil!)
      end
    end

    private def args_push(args, key, format, value : String)
      GRM.with_error_check("args_push") { LibGRM.args_push(args, key, format, value) }
    end

    private def args_push(args, key, format, size : Int, data : Array(Float64))
      GRM.with_error_check("args_push") { LibGRM.args_push(args, key, format, size, data) }
    end

    private def args_push(args, key, format, size : Int, data : Array(Int32))
      GRM.with_error_check("args_push") { LibGRM.args_push(args, key, format, size, data) }
    end

    private def args_push(args, key, format, value : Int32)
      GRM.with_error_check("args_push") { LibGRM.args_push(args, key, format, value) }
    end

    private def args_push(args, key, format, value1 : Int32, value2 : Int32)
      GRM.with_error_check("args_push") { LibGRM.args_push(args, key, format, value1, value2) }
    end

    private def args_push(args, key, format, value : Float64)
      GRM.with_error_check("args_push") { LibGRM.args_push(args, key, format, value) }
    end
  end
end
