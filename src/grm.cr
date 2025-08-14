require "./gr_common/config.cr"
require "./grm/libgrm"

module GRM
  extend self

  # Low-level API forwarding
  {% for name in %w[
                   args_new
                   args_push
                   plot
                   clear
                   args_delete
                   render
                   export
                   dump_html
                   dump_json_str
                   merge
                   merge_hold
                   merge_named
                   switch
                   max_plot_id
                 ] %}
    def {{name.id}}(*args)
      LibGRM.{{name.id}}(*args)
    end
  {% end %}

  # Crystal-style Plot class for method chaining
  class Plot
    @args : LibGRM::ArgsT
    @kind : String?
    @title : String?
    @xlabel : String?
    @ylabel : String?
    @zlabel : String?
    @color : String?

    def initialize
      @args = LibGRM.args_new
    end

    # Data setting methods (chainable)
    def data(x : Array(Number), y : Array(Number), z : Array(Number)? = nil)
      # Allow empty y array for histograms
      unless y.empty?
        raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size
      end

      if z && (x.size != z.size)
        raise ArgumentError.new("x, y, and z arrays must have the same size")
      end

      x_data = x.map(&.to_f64)
      y_data = y.map(&.to_f64)

      LibGRM.args_push(@args, "x", "nD", x_data.size, x_data)
      unless y.empty?
        LibGRM.args_push(@args, "y", "nD", y_data.size, y_data)
      end

      if z
        z_data = z.map(&.to_f64)
        LibGRM.args_push(@args, "z", "nD", z_data.size, z_data)
      end

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

    def surface
      @kind = "surface"
      self
    end

    def contour
      @kind = "contour"
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

    # Method to apply all settings (accessible from Figure class)
    def apply_settings
      LibGRM.args_push(@args, "kind", "s", @kind.as(String)) if @kind
      LibGRM.args_push(@args, "title", "s", @title.as(String)) if @title
      LibGRM.args_push(@args, "xlabel", "s", @xlabel.as(String)) if @xlabel
      LibGRM.args_push(@args, "ylabel", "s", @ylabel.as(String)) if @ylabel
      LibGRM.args_push(@args, "zlabel", "s", @zlabel.as(String)) if @zlabel
      LibGRM.args_push(@args, "color", "s", @color.as(String)) if @color
    end

    # Rendering and output methods
    def show
      apply_settings
      LibGRM.clear
      LibGRM.plot(@args)
      self
    end

    def render
      LibGRM.render
      self
    end

    def save(path : String)
      apply_settings
      LibGRM.plot(@args)
      LibGRM.export(path)
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

  # Figure class for multiple plots
  class Figure
    @plots = [] of Plot

    def initialize
      @plots = [] of Plot
    end

    def add_plot(&block : Plot -> Plot)
      plot = Plot.new
      configured_plot = yield(plot)
      @plots << configured_plot
      self
    end

    def add_plot(plot : Plot)
      @plots << plot
      self
    end

    def show
      # For multiple plots, we need to merge them
      if @plots.size > 1
        # First plot
        first_plot = @plots[0]
        first_plot.show

        # Merge additional plots
        @plots[1..-1].each do |plot|
          plot.apply_settings
          LibGRM.merge_hold(plot.@args)
        end
      elsif @plots.size == 1
        @plots[0].show
      end
      self
    end

    def save(path : String)
      show
      LibGRM.export(path)
      self
    end

    def clear
      @plots.clear
      LibGRM.clear
      self
    end
  end

  # Factory methods
  def self.plot
    Plot.new
  end

  def self.figure
    Figure.new
  end

  # Block-style plotting
  def self.plot(&block : Plot -> Plot)
    plot = Plot.new
    yield(plot)
  end

  def self.figure(&block : Figure -> Figure)
    figure = Figure.new
    yield(figure)
  end

  # High-level plotting API

  # Unified plot function (like the original low-level API)
  def plot(x : Array(Number), y : Array(Number), z : Array(Number)? = nil,
           kind : String = "line", title : String? = nil,
           xlabel : String? = nil, ylabel : String? = nil, zlabel : String? = nil,
           color : String? = nil)
    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)

    if z
      z_data = z.map(&.to_f64)
      args_push(args, "z", "nD", z_data.size, z_data)
    end

    args_push(args, "kind", "s", kind)
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "zlabel", "s", zlabel) if zlabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a line plot (using Plot class internally)
  def line(x : Array(Number), y : Array(Number),
           title : String? = nil,
           xlabel : String? = nil,
           ylabel : String? = nil,
           color : String? = nil)
    plot = Plot.new
      .data(x, y)
      .line
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.color(color) if color
    plot.show
  end

  # Create a scatter plot (using Plot class internally)
  def scatter(x : Array(Number), y : Array(Number),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil,
              color : String? = nil)
    plot = Plot.new
      .data(x, y)
      .scatter
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.color(color) if color
    plot.show
  end

  # Create a bar plot (using Plot class internally)
  def bar(x : Array(Number), y : Array(Number),
          title : String? = nil,
          xlabel : String? = nil,
          ylabel : String? = nil,
          color : String? = nil)
    plot = Plot.new
      .data(x, y)
      .bar
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.color(color) if color
    plot.show
  end

  # Create a histogram (using Plot class internally)
  def histogram(data : Array(Number),
                bins : Int32 = 50,
                title : String? = nil,
                xlabel : String? = nil,
                ylabel : String? = nil,
                color : String? = nil)
    plot = Plot.new
      .data(data, [] of Float64)
      .histogram(bins)
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.color(color) if color
    plot.show
  end

  # Create a stem plot (using Plot class internally)
  def stem(x : Array(Number), y : Array(Number),
           title : String? = nil,
           xlabel : String? = nil,
           ylabel : String? = nil,
           color : String? = nil)
    plot = Plot.new
      .data(x, y)
      .stem
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.color(color) if color
    plot.show
  end

  # Create a step plot (using Plot class internally)
  def step(x : Array(Number), y : Array(Number),
           title : String? = nil,
           xlabel : String? = nil,
           ylabel : String? = nil,
           color : String? = nil)
    plot = Plot.new
      .data(x, y)
      .step
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.color(color) if color
    plot.show
  end

  # Create a 3D scatter plot (using Plot class internally)
  def scatter3d(x : Array(Number), y : Array(Number), z : Array(Number),
                title : String? = nil,
                xlabel : String? = nil,
                ylabel : String? = nil,
                zlabel : String? = nil,
                color : String? = nil)
    plot = Plot.new
      .data(x, y, z)
      .scatter3d
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.zlabel(zlabel) if zlabel
    plot.color(color) if color
    plot.show
  end

  # Create a 3D surface plot (using Plot class internally)
  def surface(x : Array(Number), y : Array(Number), z : Array(Array(Number)),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil,
              zlabel : String? = nil)
    # Convert 2D array to 1D for surface plot
    z_flat = z.flatten
    plot = Plot.new
      .data(x, y, z_flat)
      .surface
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.zlabel(zlabel) if zlabel
    plot.show
  end

  # Create a contour plot (using Plot class internally)
  def contour(x : Array(Number), y : Array(Number), z : Array(Array(Number)),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil)
    # Convert 2D array to 1D for contour plot
    z_flat = z.flatten
    plot = Plot.new
      .data(x, y, z_flat)
      .contour
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.show
  end

  # Create a hexbin plot (using Plot class internally)
  def hexbin(x : Array(Number), y : Array(Number),
             title : String? = nil,
             xlabel : String? = nil,
             ylabel : String? = nil)
    plot = Plot.new
      .data(x, y)
      .hexbin
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.show
  end

  # Create a polar plot (using Plot class internally)
  def polar(theta : Array(Number), r : Array(Number),
            title : String? = nil,
            color : String? = nil)
    plot = Plot.new
      .data(theta, r)
      .polar
    plot.title(title) if title
    plot.color(color) if color
    plot.show
  end
end
