require "./gr_common/config.cr"
require "./gr_common/exceptions"
require "./grm/libgrm"
require "./grm/plot"
require "./grm/figure"

module GRM
  extend self

  def args_new
    LibGRM.args_new
  end

  def args_push(*args)
    LibGRM.args_push(*args)
  end

  def clear
    LibGRM.clear
  end

  def args_delete(*args)
    LibGRM.args_delete(*args)
  end

  def render
    LibGRM.render
  end

  def export(*args)
    LibGRM.export(*args)
  end

  def dump_html(*args)
    LibGRM.dump_html(*args)
  end

  def dump_json_str
    LibGRM.dump_json_str
  end

  def switch(*args)
    LibGRM.switch(*args)
  end

  def max_plot_id
    LibGRM.max_plot_id
  end

  def self.with_args(&block : LibGRM::ArgsT -> Void)
    args = args_new
    begin
      yield(args)
    ensure
      args_delete(args)
    end
  end

  class Args
    getter ptr
    getter? deleted

    def initialize
      @ptr = LibGRM.args_new
      @deleted = false
      @references = [] of Reference
    end

    def initialize(**args)
      initialize
      args.each { |key, value| push(key.to_s, value) }
    end

    def initialize(args : Hash(String, _))
      initialize
      args.each { |key, value| push(key, value) }
    end

    def initialize(args : Hash(Symbol, _))
      initialize
      args.each { |key, value| push(key.to_s, value) }
    end

    def delete
      return if @deleted
      @deleted = true
      LibGRM.args_delete(@ptr)
    end

    def finalize
      delete
    end

    def clear
      LibGRM.args_clear(@ptr)
      @references.clear
    end

    def remove(key : String)
      LibGRM.args_remove(@ptr, key)
    end

    def contains?(key : String) : Bool
      LibGRM.args_contains(@ptr, key) == 1
    end

    def []=(key : String, value)
      push(key, value)
    end

    def push(key : String, value : String)
      LibGRM.args_push(@ptr, key, "s", value)
      @references << value
    end

    def push(key : String, value : Int32)
      LibGRM.args_push(@ptr, key, "i", value)
    end

    def push(key : String, value : Int64)
      LibGRM.args_push(@ptr, key, "i", value.to_i32)
    end

    def push(key : String, value : Float64)
      LibGRM.args_push(@ptr, key, "d", value)
    end

    def push(key : String, value : Args)
      if value.deleted?
        raise ArgumentError.new("Argument container is already consumed or deleted")
      end
      value.mark_deleted!
      LibGRM.args_push(@ptr, key, "a", value.ptr)
    end

    def push(key : String, values : Array(String))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      ptrs = values.map { |v| v.to_unsafe.as(LibC::Char*) }
      LibGRM.args_push(@ptr, key, "nS", ptrs.size, ptrs.to_unsafe)
      @references << values
      @references << ptrs
    end

    def push(key : String, values : Array(Int32))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      data = values.map(&.to_i32)
      LibGRM.args_push(@ptr, key, "nI", data.size, data.to_unsafe)
      @references << data
    end

    def push(key : String, values : Array(Int64))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      data = values.map(&.to_i32)
      LibGRM.args_push(@ptr, key, "nI", data.size, data.to_unsafe)
      @references << data
    end

    def push(key : String, values : Array(Float64))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      data = values.map(&.to_f64)
      LibGRM.args_push(@ptr, key, "nD", data.size, data.to_unsafe)
      @references << data
    end

    def push(key : String, values : Array(Args))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      values.each do |value|
        if value.deleted?
          raise ArgumentError.new("Argument container is already consumed or deleted")
        end
      end
      values.each(&.mark_deleted!)
      ptrs = values.map(&.ptr)
      LibGRM.args_push(@ptr, key, "nA", ptrs.size, ptrs.to_unsafe)
      @references << values
      @references << ptrs
    end

    def push(key : String, values : Array(Array(Int32)))
      dims, flat = flatten_matrix_int(values, key)
      push(key, flat)
      push("#{key}_dims", dims)
    end

    def push(key : String, values : Array(Array(Float64)))
      dims, flat = flatten_matrix_float(values, key)
      push(key, flat)
      push("#{key}_dims", dims)
    end

    private def mark_deleted!
      @deleted = true
    end

    private def flatten_matrix_int(values : Array(Array(Int32)), key : String)
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      rows = values.size
      cols = values.first.size
      unless values.all? { |row| row.size == cols }
        raise ArgumentError.new("All rows in 2D array for key '#{key}' must have the same length")
      end
      flat = values.flat_map { |row| row.map(&.to_i32) }
      dims = [cols.to_i32, rows.to_i32]
      {dims, flat}
    end

    private def flatten_matrix_float(values : Array(Array(Float64)), key : String)
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      rows = values.size
      cols = values.first.size
      unless values.all? { |row| row.size == cols }
        raise ArgumentError.new("All rows in 2D array for key '#{key}' must have the same length")
      end
      flat = values.flat_map { |row| row.map(&.to_f64) }
      dims = [cols.to_i32, rows.to_i32]
      {dims, flat}
    end
  end

  def merge(args : Args)
    LibGRM.merge(args.ptr)
  end

  def merge_hold(args : Args)
    LibGRM.merge_hold(args.ptr)
  end

  def merge_named(args : Args, identificator : String)
    LibGRM.merge_named(args.ptr, identificator)
  end

  def merge_extended(args : Args, hold : Int32 = 0)
    LibGRM.merge_extended(args.ptr, hold, Pointer(LibC::Char).null)
  end

  def merge_extended(args : Args, hold : Int32, identificator : String)
    LibGRM.merge_extended(args.ptr, hold, identificator)
  end

  def plot(args : Args)
    LibGRM.plot(args.ptr)
  end

  def plot(x : Array(Number), y : Array(Number), z : Array(Number)? = nil,
           kind : String = "line", title : String? = nil,
           xlabel : String? = nil, ylabel : String? = nil, zlabel : String? = nil,
           color : String? = nil)
    if x.size != y.size
      raise GRCommon::DimensionMismatchError.new(
        "X and Y arrays must have equal length: x=#{x.size}, y=#{y.size}"
      )
    end

    if z && z.size != x.size
      raise GRCommon::DimensionMismatchError.new(
        "X and Z arrays must have equal length: x=#{x.size}, z=#{z.size}"
      )
    end

    if x.empty? || y.empty?
      raise GRCommon::InvalidDataError.new(
        "X and Y arrays cannot be empty"
      )
    end

    args = Args.new
    args.push("x", x.map(&.to_f64))
    args.push("y", y.map(&.to_f64))
    args.push("z", z.map(&.to_f64)) if z
    args.push("kind", kind)
    args.push("title", title) if title
    args.push("xlabel", xlabel) if xlabel
    args.push("ylabel", ylabel) if ylabel
    args.push("zlabel", zlabel) if zlabel
    args.push("color", color) if color
    plot(args)
  end

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

  def surface(x : Array(Number), y : Array(Number), z : Array(Array(Number)),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil,
              zlabel : String? = nil)
    plot = Plot.new
      .data2d(x, y, z)
      .surface(z.size, z.first.size)
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.zlabel(zlabel) if zlabel
    plot.show
  end

  def contour(x : Array(Number), y : Array(Number), z : Array(Array(Number)),
              title : String? = nil,
              xlabel : String? = nil,
              ylabel : String? = nil)
    plot = Plot.new
      .data2d(x, y, z)
      .contour(z.size, z.first.size)
    plot.title(title) if title
    plot.xlabel(xlabel) if xlabel
    plot.ylabel(ylabel) if ylabel
    plot.show
  end

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
