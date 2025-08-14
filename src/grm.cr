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
                 ] %}
    def {{name.id}}(*args)
      LibGRM.{{name.id}}(*args)
    end
  {% end %}

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

  # Create a line plot
  def line(x : Array(Number), y : Array(Number),
           title : String? = nil,
           xlabel : String? = nil,
           ylabel : String? = nil,
           color : String? = nil)
    raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size

    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "kind", "s", "line")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a scatter plot
  def scatter(x : Array(Number), y : Array(Number),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil,
              color : String? = nil)
    raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size

    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "kind", "s", "scatter")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a bar plot
  def bar(x : Array(Number), y : Array(Number),
          title : String? = nil,
          xlabel : String? = nil,
          ylabel : String? = nil,
          color : String? = nil)
    raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size

    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "kind", "s", "bar")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a histogram
  def histogram(data : Array(Number),
                bins : Int32 = 50,
                title : String? = nil,
                xlabel : String? = nil,
                ylabel : String? = nil,
                color : String? = nil)
    args = args_new
    data_f64 = data.map(&.to_f64)

    args_push(args, "x", "nD", data_f64.size, data_f64)
    args_push(args, "kind", "s", "hist")
    args_push(args, "nbins", "i", bins)
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a stem plot
  def stem(x : Array(Number), y : Array(Number),
           title : String? = nil,
           xlabel : String? = nil,
           ylabel : String? = nil,
           color : String? = nil)
    raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size

    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "kind", "s", "stem")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a step plot
  def step(x : Array(Number), y : Array(Number),
           title : String? = nil,
           xlabel : String? = nil,
           ylabel : String? = nil,
           color : String? = nil)
    raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size

    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "kind", "s", "step")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a 3D scatter plot
  def scatter3d(x : Array(Number), y : Array(Number), z : Array(Number),
                title : String? = nil,
                xlabel : String? = nil,
                ylabel : String? = nil,
                zlabel : String? = nil,
                color : String? = nil)
    raise ArgumentError.new("x, y, and z arrays must have the same size") if x.size != y.size || y.size != z.size

    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)
    z_data = z.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "z", "nD", z_data.size, z_data)
    args_push(args, "kind", "s", "scatter3")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "zlabel", "s", zlabel) if zlabel
    args_push(args, "color", "s", color) if color

    plot(args)
  end

  # Create a 3D surface plot
  def surface(x : Array(Number), y : Array(Number), z : Array(Array(Number)),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil,
              zlabel : String? = nil)
    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)
    z_flat = z.flatten.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "z", "nD", z_flat.size, z_flat)
    args_push(args, "kind", "s", "surface")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel
    args_push(args, "zlabel", "s", zlabel) if zlabel

    plot(args)
  end

  # Create a contour plot
  def contour(x : Array(Number), y : Array(Number), z : Array(Array(Number)),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil)
    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)
    z_flat = z.flatten.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "z", "nD", z_flat.size, z_flat)
    args_push(args, "kind", "s", "contour")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel

    plot(args)
  end

  # Create a hexbin plot
  def hexbin(x : Array(Number), y : Array(Number),
             title : String? = nil,
             xlabel : String? = nil,
             ylabel : String? = nil)
    raise ArgumentError.new("x and y arrays must have the same size") if x.size != y.size

    args = args_new
    x_data = x.map(&.to_f64)
    y_data = y.map(&.to_f64)

    args_push(args, "x", "nD", x_data.size, x_data)
    args_push(args, "y", "nD", y_data.size, y_data)
    args_push(args, "kind", "s", "hexbin")
    args_push(args, "title", "s", title) if title
    args_push(args, "xlabel", "s", xlabel) if xlabel
    args_push(args, "ylabel", "s", ylabel) if ylabel

    plot(args)
  end

  # Create a polar plot
  def polar(theta : Array(Number), r : Array(Number),
            title : String? = nil,
            color : String? = nil)
    raise ArgumentError.new("theta and r arrays must have the same size") if theta.size != r.size

    args = args_new
    theta_data = theta.map(&.to_f64)
    r_data = r.map(&.to_f64)

    args_push(args, "x", "nD", theta_data.size, theta_data)
    args_push(args, "y", "nD", r_data.size, r_data)
    args_push(args, "kind", "s", "polar")
    args_push(args, "title", "s", title) if title
    args_push(args, "color", "s", color) if color

    plot(args)
  end
end
