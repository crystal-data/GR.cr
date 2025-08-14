require "./libgrm"

module GRM
  # Crystal-style Plot class for method chaining
  class Plot
    @args : LibGRM::ArgsT
    @kind : String?
    @title : String?
    @xlabel : String?
    @ylabel : String?
    @zlabel : String?
    @color : String?
    @x_data : Array(Float64)?
    @y_data : Array(Float64)?
    @z_data : Array(Float64)?
    @nbins : Int32?
    @m : Int32? # For 2D data dimensions (rows)
    @n : Int32? # For 2D data dimensions (columns)

    getter args : LibGRM::ArgsT
    getter kind : String?
    getter color : String?

    def initialize
      @args = LibGRM.args_new
    end

    # Method to build clean args without polluting internal state
    def build_series_args : LibGRM::ArgsT
      temp_args = LibGRM.args_new

      # Add data
      if @x_data
        LibGRM.args_push(temp_args, "x", "nD", @x_data.not_nil!.size, @x_data.not_nil!)
      end
      if @y_data && !@y_data.not_nil!.empty?
        LibGRM.args_push(temp_args, "y", "nD", @y_data.not_nil!.size, @y_data.not_nil!)
      end
      if @z_data
        LibGRM.args_push(temp_args, "z", "nD", @z_data.not_nil!.size, @z_data.not_nil!)

        # Add dimension information for 2D plots (surface/contour)
        if @kind == "surface" || @kind == "contour"
          # Ensure m and n are set for 2D kinds to prevent crashes
          raise ArgumentError.new("2D kinds (#{@kind}) require m and n to be set") unless @m && @n
          LibGRM.args_push(temp_args, "m", "i", @m.as(Int32))
          LibGRM.args_push(temp_args, "n", "i", @n.as(Int32))
        end
      end

      # Strict check: 2D kinds require z data
      if (@kind == "surface" || @kind == "contour") && !@z_data
        raise ArgumentError.new("2D kinds (#{@kind}) require z data to be set")
      end

      # Add series-specific properties (NOT figure-level properties)
      # Use "line" as default kind if not specified
      kind_to_use = @kind || "line"
      LibGRM.args_push(temp_args, "kind", "s", kind_to_use)
      LibGRM.args_push(temp_args, "color", "s", @color.as(String)) if @color
      LibGRM.args_push(temp_args, "nbins", "i", @nbins.as(Int32)) if @nbins

      temp_args
    end

    # Data setting methods (chainable) - for 1D series
    def data(x : Array(Number), y : Array(Number), z : Array(Number)? = nil)
      # Allow empty y array for histograms
      unless y.empty?
        # 1D series assumption (2D should use data2d)
        raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size
      end

      if z && (x.size != z.size)
        raise ArgumentError.new("x, y, and z arrays must have the same size")
      end

      @x_data = x.map(&.to_f64)
      @y_data = y.map(&.to_f64)
      @z_data = z ? z.map(&.to_f64) : nil

      # Also update the legacy args for backward compatibility
      LibGRM.args_push(@args, "x", "nD", @x_data.not_nil!.size, @x_data.not_nil!)
      unless y.empty?
        LibGRM.args_push(@args, "y", "nD", @y_data.not_nil!.size, @y_data.not_nil!)
      end

      if @z_data
        LibGRM.args_push(@args, "z", "nD", @z_data.not_nil!.size, @z_data.not_nil!)
      end

      self
    end

    # 2D data helper for surface/contour (z: m x n matrix)
    def data2d(x : Array(Number), y : Array(Number), z : Array(Array(Number)))
      raise ArgumentError.new("z must be non-empty") if z.empty?
      m = z.size
      n = z.first.size
      raise ArgumentError.new("all rows of z must have the same length") unless z.all? { |row| row.size == n }

      @x_data = x.map(&.to_f64)         # grid axes (length m or n depending on GRM mode)
      @y_data = y.map(&.to_f64)         # grid axes (length n or m depending on GRM mode)
      @z_data = z.flatten.map(&.to_f64) # flattened m*n data
      @m = m
      @n = n

      # Validate dimension consistency to prevent crashes
      raise ArgumentError.new("x length must equal m (#{@x_data.not_nil!.size} != #{m})") unless @x_data.not_nil!.size == m
      raise ArgumentError.new("y length must equal n (#{@y_data.not_nil!.size} != #{n})") unless @y_data.not_nil!.size == n

      # Legacy args for standalone usage
      LibGRM.args_push(@args, "x", "nD", @x_data.not_nil!.size, @x_data.not_nil!)
      LibGRM.args_push(@args, "y", "nD", @y_data.not_nil!.size, @y_data.not_nil!)
      LibGRM.args_push(@args, "z", "nD", @z_data.not_nil!.size, @z_data.not_nil!)
      LibGRM.args_push(@args, "m", "i", m)
      LibGRM.args_push(@args, "n", "i", n)

      self
    end

    # Convenience method for point arrays
    def data(points : Array({Number, Number}))
      x = points.map(&.[0])
      y = points.map(&.[1])
      data(x, y)
    end

    # Plot type methods (chainable)
    def line
      @kind = "line"
      self
    end

    def scatter
      @kind = "scatter"
      self
    end

    def bar
      @kind = "bar"
      self
    end

    def histogram(bins : Int32 = 50)
      @kind = "hist"
      @nbins = bins
      LibGRM.args_push(@args, "nbins", "i", bins)
      self
    end

    def stem
      @kind = "stem"
      self
    end

    def step
      @kind = "step"
      self
    end

    def scatter3d
      @kind = "scatter3"
      self
    end

    def surface(m : Int32? = nil, n : Int32? = nil)
      @kind = "surface"
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

    def hexbin
      @kind = "hexbin"
      self
    end

    def polar
      @kind = "polar"
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

    # Style method for multiple properties
    def style(color : String? = nil,
              line_width : Float32? = nil,
              marker : String? = nil)
      @color = color if color
      # Additional style properties can be added here
      self
    end

    # Apply only series-specific settings (for Figure usage)
    private def apply_series_settings_only(args : LibGRM::ArgsT)
      LibGRM.args_push(args, "kind", "s", @kind.as(String)) if @kind
      LibGRM.args_push(args, "color", "s", @color.as(String)) if @color
      LibGRM.args_push(args, "nbins", "i", @nbins.as(Int32)) if @nbins
    end

    # Apply figure-level labels (for standalone Plot usage only)
    private def apply_standalone_labels(args : LibGRM::ArgsT)
      LibGRM.args_push(args, "title", "s", @title.as(String)) if @title
      LibGRM.args_push(args, "xlabel", "s", @xlabel.as(String)) if @xlabel
      LibGRM.args_push(args, "ylabel", "s", @ylabel.as(String)) if @ylabel
      LibGRM.args_push(args, "zlabel", "s", @zlabel.as(String)) if @zlabel
    end

    # Method to apply all settings for standalone Plot usage
    def apply_settings
      apply_series_settings_only(@args)
      apply_standalone_labels(@args)
    end

    # Rendering and output methods
    # WARNING: This method calls LibGRM.clear which affects the global GRM state.
    # Do not use this method when working with Figure instances, as it may clear
    # other plots. This method is intended for standalone Plot usage only.
    def show
      # Build a clean args that includes data + series props
      temp_args = build_series_args
      # Add standalone (figure-level) labels
      apply_standalone_labels(temp_args)

      LibGRM.clear # WARNING: Clears global GRM state
      LibGRM.plot(temp_args)

      LibGRM.args_delete(temp_args)
      self
    end

    def render
      LibGRM.render
      self
    end

    def save(path : String)
      temp_args = build_series_args
      apply_standalone_labels(temp_args)

      LibGRM.plot(temp_args)
      LibGRM.export(path)

      LibGRM.args_delete(temp_args)
      self
    end

    def to_html(plot_id : String? = nil) : String
      show
      html_ptr = if plot_id
                   LibGRM.dump_html(plot_id)
                 else
                   LibGRM.dump_html(nil)
                 end
      String.new(html_ptr)
    end

    def to_json : String
      json_ptr = LibGRM.dump_json_str
      String.new(json_ptr)
    end

    # Cleanup
    def finalize
      LibGRM.args_delete(@args)
    end
  end
end
