module GR
  module GRM
    @[Link("GRM")]
    lib LibGRM
      fun grm_args_new() : Pointer(Int32)
      fun grm_args_push(grm_args_t: Int32*, key: UInt8*, value_foramt: UInt8*, ...)
      fun grm_plot(grm_args_t: Int32*)
      fun grm_clear() : Pointer(Int32)
    end
  end
end