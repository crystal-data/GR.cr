# frozen_string_literal: true

# This is a ruby script to convert a C header json file to crystal code.
# Please use c2ffi https://github.com/rpav/c2ffi to generate json files
# from C headers before running this script.

class Object
  macro methods
    {{ @type.methods.map &.name.stringify }}
  end
end

require "json"

class Converter
  TYPE_TABLE = {
    ":int"            => "Int32",
    ":unsigned-int"   => "UInt32",
    ":float"          => "Float32",
    ":double"         => "Float64",
    ":unsigned-short" => "LibC::UShort",
    ":char"           => "UInt8",
    ":void"           => "Void",
    "grm_args_t"      => "GRMArgs",
  }

  def initialize(json_path)
    json_path = File.expand_path(json_path)
    @unknown = Array(Array(String)).new
    @error_flag = false
    json_text = File.read(json_path)
    metadata = JSON.parse(json_text)

    functions = filter_functions(metadata)
    convert_functions(functions)

    print_unknown_types_info
  end

  def crystal_type(str, fname)
    type = TYPE_TABLE[str]?
    if type.nil?
      @unknown << [fname.to_s, str.to_s]
      @error_flag = true
      type = ""
    end
    type
  end

  def filter_functions(metadata)
    metadata.as_a.select { |v| v["tag"] == "function" }.map { |v| v.as_h }
  end

  def convert_functions(functions)
    functions.each do |func_hash|
      puts function_to_string(func_hash)
    end
  end

  def function_to_string(fh)
    name = fh["name"]
    str = "fun #{name}("

    # parameter types
    fh["parameters"].as_a.each_with_index do |param, idx|
      # add ,
      unless idx == 0
        str += ", "
      end

      type_1 = param["type"]
      # not pointer
      unless type_1["tag"] == ":pointer"
        str += crystal_type(type_1["tag"], name)
        # pointer
      else
        type_2 = type_1["type"]
        # not pointer of pointer
        unless type_2["tag"] == ":pointer"
          str += crystal_type(type_2["tag"], name)
          str += "*"
          # pointer of pointer
        else
          str += crystal_type(type_2.dig("type", "tag"), name)
          str += "**"
        end
      end
    end

    str += ") : "

    # return types
    if fh.dig("return-type", "tag") == ":pointer"
      str += crystal_type(fh["return-type"]["type"]["tag"], name)
      str += '*'
    else
      str += crystal_type(fh["return-type"]["tag"], name)
    end

    # commment out if error
    if @error_flag
      @error_flag = false
      "# " + str
    else
      str
    end
  end

  def print_unknown_types_info
    puts
    puts "# Unknown types"
    puts "# #{@unknown.map { |i| i[1] }.uniq}"
    @unknown.each do |i|
      puts "# #{i.join(", ")}"
    end
  end
end

Converter.new(ARGV[0])
