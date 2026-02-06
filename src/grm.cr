require "./gr_common/config.cr"
require "./gr_common/exceptions"
require "./grm/libgrm"
require "./grm/plot"
require "./grm/figure"

module GRM
  extend self

  ERROR_MUTEX = Mutex.new

  class Error < GRCommon::GRError
  end

  def check_error!(context : String? = nil)
    code = LibGRM.get_error_code.to_i32
    return if code == 0

    enum_value = LibGRM::ErrorT.from_value?(code)
    code_name = enum_value ? enum_value.to_s : code.to_s
    prefix = context ? "GRM error (#{context})" : "GRM error"
    raise Error.new("#{prefix}: #{code_name}")
  end

  def with_error_check(context : String? = nil, &)
    ERROR_MUTEX.synchronize do
      result = yield
      check_error!(context)
      result
    end
  end

  def args_new
    with_error_check("args_new") { LibGRM.args_new }
  end

  def args_push(*args)
    with_error_check("args_push") { LibGRM.args_push(*args) }
  end

  def clear
    with_error_check("clear") { LibGRM.clear }
  end

  def args_delete(*args)
    with_error_check("args_delete") { LibGRM.args_delete(*args) }
  end

  def render
    with_error_check("render") { LibGRM.render }
  end

  def export(*args)
    with_error_check("export") { LibGRM.export(*args) }
  end

  def dump_html(*args)
    with_error_check("dump_html") { LibGRM.dump_html(*args) }
  end

  def dump_json_str
    with_error_check("dump_json_str") { LibGRM.dump_json_str }
  end

  def switch(*args)
    with_error_check("switch") { LibGRM.switch(*args) }
  end

  def max_plot_id
    with_error_check("max_plot_id") { LibGRM.max_plot_id }
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
    alias Reference = Args | String | Array(String) | Array(Int32) | Array(Int64) | Array(Float64) | Array(LibC::Char*) | Array(Args)

    getter ptr : LibGRM::ArgsT
    getter? deleted : Bool

    def initialize
      @ptr = GRM.with_error_check("args_new") { LibGRM.args_new }
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
      GRM.with_error_check("args_delete") { LibGRM.args_delete(@ptr) }
      @references.clear
    end

    def finalize
      delete
    end

    def clear
      GRM.with_error_check("args_clear") { LibGRM.args_clear(@ptr) }
      @references.clear
    end

    def remove(key : String)
      GRM.with_error_check("args_remove") { LibGRM.args_remove(@ptr, key) }
    end

    def contains?(key : String) : Bool
      GRM.with_error_check("args_contains") { LibGRM.args_contains(@ptr, key) } == 1
    end

    def []=(key : String, value)
      push(key, value)
    end

    def push(key : String, value : String)
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "s", value) }
      keep(value)
    end

    def push(key : String, value : Int32)
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "i", value) }
    end

    def push(key : String, value : Int64)
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "i", value.to_i32) }
    end

    def push(key : String, value : Float64)
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "d", value) }
    end

    def push(key : String, value : Args)
      if value.deleted?
        raise ArgumentError.new("Argument container is already consumed or deleted")
      end
      value.mark_deleted!
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "a", value.ptr) }
      keep(value)
    end

    def push(key : String, values : Array(String))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      ptrs = values.map { |v| v.to_unsafe.as(LibC::Char*) }
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "nS", ptrs.size, ptrs.to_unsafe) }
      keep(values)
      keep(ptrs)
    end

    def push(key : String, values : Array(Int32))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      data = values.map(&.to_i32)
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "nI", data.size, data.to_unsafe) }
      keep(data)
    end

    def push(key : String, values : Array(Int64))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      data = values.map(&.to_i32)
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "nI", data.size, data.to_unsafe) }
      keep(data)
    end

    def push(key : String, values : Array(Float64))
      raise ArgumentError.new("Array value for key '#{key}' cannot be empty") if values.empty?
      data = values.map(&.to_f64)
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "nD", data.size, data.to_unsafe) }
      keep(data)
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
      GRM.with_error_check("args_push") { LibGRM.args_push(@ptr, key, "nA", ptrs.size, ptrs.to_unsafe) }
      keep(values)
      keep(ptrs)
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

    private def keep(value : Reference)
      @references << value
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
    with_error_check("merge") { LibGRM.merge(args.ptr) }
  end

  def merge_hold(args : Args)
    with_error_check("merge_hold") { LibGRM.merge_hold(args.ptr) }
  end

  def merge_named(args : Args, identificator : String)
    with_error_check("merge_named") { LibGRM.merge_named(args.ptr, identificator) }
  end

  def merge_extended(args : Args, hold : Int32 = 0)
    with_error_check("merge_extended") { LibGRM.merge_extended(args.ptr, hold, Pointer(LibC::Char).null) }
  end

  def merge_extended(args : Args, hold : Int32, identificator : String)
    with_error_check("merge_extended") { LibGRM.merge_extended(args.ptr, hold, identificator) }
  end

  def plot(args : Args)
    with_error_check("plot") { LibGRM.plot(args.ptr) }
  end

  def plot(args : LibGRM::ArgsT)
    with_error_check("plot") { LibGRM.plot(args) }
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
