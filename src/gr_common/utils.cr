module GRCommon
  module Utils
    private def float64(a)
      Pointer(Float64).malloc(a.size) { |i| a[i].to_f64 }
    end

    private def int32(a)
      Pointer(Int32).malloc(a.size) { |i| a[i].to_i32 }
    end

    private def int32_color(color)
      if color.responds_to?(:flatten)
        int32(color.flatten)
      else
        int32(color)
      end
    end

    private def uint8_ptr(codes)
      slice = codes.is_a?(String) ? codes.to_slice : codes
      Pointer(UInt8).malloc(slice.size) { |i| slice[i] }
    end

    # Converts a String to a C string (null-terminated UInt8 pointer)
    def to_cchar(s)
      cp = Pointer(UInt8).malloc(s.size + 1)
      i = 0
      s.each_byte { |c| cp[i] = c; i += 1 }
      cp[s.size] = 0
      cp
    end

    # :nodoc:
    # Validate that all arrays have the same length.
    def ensure_same_length(*arrays)
      return 0 if arrays.empty?

      size = arrays.first.size
      arrays.each do |array|
        raise ArgumentError.new("size mismatch") unless array.size == size
      end
      size
    end
  end
end
