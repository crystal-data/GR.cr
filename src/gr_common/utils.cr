module GRCommon
  module Utils
    def float64(a)
      Pointer(Float64).malloc(a.size) { |i| a[i] }
    end

    def to_cchar(s)
      cp = Pointer(UInt8).malloc(s.size + 1)
      i = 0
      s.each_byte { |c| cp[i] = c; i += 1 }
      #    (s.size+1).times{|i|p cp[i]}
      cp[s.size] = 0
      cp
    end

    def inquiry_double(&block)
      ptr = Pointer(Float64).malloc
      yield(ptr)
      ptr.value
    end

    def inquiry_int(&block)
      ptr = Pointer(Int32).malloc
      yield(ptr)
      ptr.value
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
