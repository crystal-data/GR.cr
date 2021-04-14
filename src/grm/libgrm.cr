module GRM
  @[Link("GRM")]
  lib LibGRM
    type GRMArgs = Void
    fun grm_args_new : GRMArgs*
    fun grm_args_delete(GRMArgs*) : Void
    fun grm_args_push(GRMArgs*, UInt8*, UInt8*, ...) : Int32
    fun grm_args_push_buf(GRMArgs*, UInt8*, UInt8*, Void*, Int32) : Int32
    fun grm_args_contains(GRMArgs*, UInt8*) : Int32
    fun grm_args_clear(GRMArgs*) : Void
    fun grm_args_remove(GRMArgs*, UInt8*) : Void
    # fun grm_length(Float64, UInt8*) :
    # fun grm_dump(GRMArgs*, *) : Void
    # fun grm_dump_json(GRMArgs*, *) : Void
    fun grm_dump_json_str : UInt8*
    # fun grm_register(, ) : Int32
    # fun grm_unregister() : Int32
    fun grm_input(GRMArgs*) : Int32
    fun grm_get_box(Int32, Int32, Int32, Int32, Int32, Int32*, Int32*, Int32*, Int32*) : Int32
    # fun grm_get_tooltip(Int32, Int32) : *
    # fun grm_open(Int32, UInt8*, UInt32, , ) : Void*
    fun grm_recv(Void*, GRMArgs*) : GRMArgs*
    fun grm_send(Void*, UInt8*, ...) : Int32
    fun grm_send_buf(Void*, UInt8*, Void*, Int32) : Int32
    fun grm_send_ref(Void*, UInt8*, UInt8, Void*, Int32) : Int32
    fun grm_send_args(Void*, GRMArgs*) : Int32
    fun grm_close(Void*) : Void
    fun grm_finalize : Void
    fun grm_clear : Int32
    fun grm_max_plotid : UInt32
    fun grm_merge(GRMArgs*) : Int32
    fun grm_merge_extended(GRMArgs*, Int32, UInt8*) : Int32
    fun grm_merge_hold(GRMArgs*) : Int32
    fun grm_merge_named(GRMArgs*, UInt8*) : Int32
    fun grm_plot(GRMArgs*) : Int32
    fun grm_switch(UInt32) : Int32
  end
end
