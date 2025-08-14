require "./libgrm"
require "./plot"

module GRM
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
    # Use data2d for proper 2D data handling with dimensions
    plot = Plot.new
      .data2d(x, y, z)
      .surface(z.size, z.first.size) # m, n explicitly specified
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
    # Use data2d for proper 2D data handling with dimensions
    plot = Plot.new
      .data2d(x, y, z)
      .contour(z.size, z.first.size) # m, n explicitly specified
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
