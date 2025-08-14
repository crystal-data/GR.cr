module GRM
  {% if env("GRDIR") %}
    @[Link(ldflags: "-L `echo $GRDIR/lib` -lGRM -Wl,-rpath,`echo $GRDIR/lib`")]
  {% else %}
    @[Link("grm")]
  {% end %}
  lib LibGRM
    # Type definitions
    type ArgsT = Void*
    type ArgsIteratorT = Void*
    type ArgsValueIteratorT = Void*
    type ArgsPtrT = Void*
    type EventCallbackT = Void*

    # File type for compatibility - treated as opaque pointer
    type File = Void*

    # Event system types
    enum EventTypeT
      GrmEventNewPlot     = 0
      GrmEventUpdatePlot  = 1
      GrmEventSize        = 2
      GrmEventMergeEnd    = 3
      X_GrmEventTypeCount = 4
    end

    union EventT
      new_plot_event : NewPlotEventT
      size_event : SizeEventT
      update_plot_event : UpdatePlotEventT
      merge_end_event : MergeEndEventT
    end

    struct NewPlotEventT
      type : EventTypeT
      plot_id : LibC::Int
    end

    struct SizeEventT
      type : EventTypeT
      plot_id : LibC::Int
      width : LibC::Int
      height : LibC::Int
    end

    struct UpdatePlotEventT
      type : EventTypeT
      plot_id : LibC::Int
    end

    struct MergeEndEventT
      type : EventTypeT
      identificator : LibC::Char*
    end

    struct TooltipInfoT
      x : LibC::Double
      y : LibC::Double
      x_px : LibC::Int
      y_px : LibC::Int
      xlabel : LibC::Char*
      ylabel : LibC::Char*
      label : LibC::Char*
    end

    # Additional tooltip type for accumulated tooltips
    type AccumulatedTooltipInfoT = Void*

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/args.h
    fun arg_value_iter = grm_arg_value_iter(arg : ArgsT) : ArgsValueIteratorT*
    fun args_new = grm_args_new : ArgsT
    fun args_delete = grm_args_delete(args : ArgsT)
    fun args_push = grm_args_push(args : ArgsT, key : LibC::Char*, value_format : LibC::Char*, ...) : LibC::Int
    fun args_push_buf = grm_args_push_buf(args : ArgsT, key : LibC::Char*, value_format : LibC::Char*, buffer : Void*, apply_padding : LibC::Int) : LibC::Int
    fun args_contains = grm_args_contains(args : ArgsT, keyword : LibC::Char*) : LibC::Int
    fun args_first_value = grm_args_first_value(args : ArgsT, keyword : LibC::Char*, first_value_format : LibC::Char*, first_value : Void*, array_length : LibC::UInt*) : LibC::Int
    fun args_values = grm_args_values(args : ArgsT, keyword : LibC::Char*, expected_format : LibC::Char*, ...) : LibC::Int
    fun args_clear = grm_args_clear(args : ArgsT)
    fun args_remove = grm_args_remove(args : ArgsT, key : LibC::Char*)
    fun args_iter = grm_args_iter(args : ArgsT) : ArgsIteratorT*
    fun length = grm_length(value : LibC::Double, unit : LibC::Char*) : ArgsPtrT

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/dump.h
    fun dump = grm_dump(args : ArgsT, f : File*)
    fun dump_json = grm_dump_json(args : ArgsT, f : File*)
    fun dump_json_str = grm_dump_json_str : LibC::Char*
    fun dump_html = grm_dump_html(plot_id : LibC::Char*) : LibC::Char*
    fun dump_html_args = grm_dump_html_args(plot_id : LibC::Char*, args : ArgsT) : LibC::Char*
    fun dump_bson = grm_dump_bson(args : ArgsT, f : File*)

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/event.h
    fun register = grm_register(type : EventTypeT, callback : EventCallbackT) : LibC::Int
    fun unregister = grm_unregister(type : EventTypeT) : LibC::Int

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/interaction.h
    fun input = grm_input(input_args : ArgsT) : LibC::Int
    fun get_box = grm_get_box(x1 : LibC::Int, y1 : LibC::Int, x2 : LibC::Int, y2 : LibC::Int, keep_aspect_ratio : LibC::Int, x : LibC::Int*, y : LibC::Int*, w : LibC::Int*, h : LibC::Int*) : LibC::Int
    fun is3d = grm_is3d(x : LibC::Int, y : LibC::Int) : LibC::Int
    fun get_tooltip = grm_get_tooltip(mouse_x : LibC::Int, mouse_y : LibC::Int) : TooltipInfoT*
    fun get_tooltips_x = grm_get_tooltips_x(mouse_x : LibC::Int, mouse_y : LibC::Int, array_length : LibC::UInt*) : TooltipInfoT**
    fun get_accumulated_tooltip_x = grm_get_accumulated_tooltip_x(mouse_x : LibC::Int, mouse_y : LibC::Int) : AccumulatedTooltipInfoT*
    fun get_hover_mode = grm_get_hover_mode(mouse_x : LibC::Int, mouse_y : LibC::Int, disable_movable_xform : LibC::Int) : LibC::Int

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/net.h
    fun open = grm_open(is_receiver : LibC::Int, name : LibC::Char*, id : LibC::UInt, custom_recv : (LibC::Char*, LibC::UInt -> LibC::Char*), custom_send : (LibC::Char*, LibC::UInt, LibC::Char* -> LibC::Int)) : Void*
    fun recv = grm_recv(p : Void*, args : ArgsT) : ArgsT
    fun send = grm_send(p : Void*, data_desc : LibC::Char*, ...) : LibC::Int
    fun send_buf = grm_send_buf(p : Void*, data_desc : LibC::Char*, buffer : Void*, apply_padding : LibC::Int) : LibC::Int
    fun send_ref = grm_send_ref(p : Void*, key : LibC::Char*, format : LibC::Char, ref : Void*, len : LibC::Int) : LibC::Int
    fun send_args = grm_send_args(p : Void*, args : ArgsT) : LibC::Int
    fun close = grm_close(p : Void*)

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/plot.h
    fun finalize = grm_finalize
    fun clear = grm_clear : LibC::Int
    fun dump_graphics_tree = grm_dump_graphics_tree(f : File*)
    fun dump_graphics_tree_str = grm_dump_graphics_tree_str : LibC::Char*
    fun max_plot_id = grm_max_plot_id : LibC::UInt
    fun merge = grm_merge(args : ArgsT) : LibC::Int
    fun merge_extended = grm_merge_extended(args : ArgsT, hold : LibC::Int, identificator : LibC::Char*) : LibC::Int
    fun merge_hold = grm_merge_hold(args : ArgsT) : LibC::Int
    fun merge_named = grm_merge_named(args : ArgsT, identificator : LibC::Char*) : LibC::Int
    fun plot = grm_plot(args : ArgsT) : LibC::Int
    fun render = grm_render : LibC::Int
    fun process_tree = grm_process_tree : LibC::Int
    fun export = grm_export(file_path : LibC::Char*) : LibC::Int
    fun switch = grm_switch(id : LibC::UInt) : LibC::Int
    fun load_graphics_tree = grm_load_graphics_tree(file : File*) : LibC::Int
    fun validate = grm_validate : LibC::Int

    # The following functions use C++ types that cannot be parsed by Crystal FFI
    # fun get_document_root = grm_get_document_root : Void* # std::shared_ptr<GRM::Element>
    # fun get_render = grm_get_render : Void* # std::shared_ptr<GRM::Render>
    # fun iterate_grid = grm_iterate_grid(grid : Void*, parent_dom_element : Void*, plot_id : LibC::Int) : LibC::Int
    # fun plot_helper = grm_plot_helper(grid_element : Void*, slice : Void*, parent_dom_element : Void*, plot_id : LibC::Int) : LibC::Int
    # fun get_subplot_from_ndc_point_using_dom = grm_get_subplot_from_ndc_point_using_dom(x : LibC::Double, y : LibC::Double) : Void*
    # fun get_subplot_from_ndc_points_using_dom = grm_get_subplot_from_ndc_points_using_dom(n : LibC::UInt, x : LibC::Double*, y : LibC::Double*) : Void*
    # fun set_attribute_on_all_subplots = grm_set_attribute_on_all_subplots(attribute : LibC::Char*, value : LibC::Int)
    # fun get_focus_and_factor_from_dom = grm_get_focus_and_factor_from_dom(x1 : LibC::Int, y1 : LibC::Int, x2 : LibC::Int, y2 : LibC::Int, keep_aspect_ratio : LibC::Int, factor_x : LibC::Double*, factor_y : LibC::Double*, focus_x : LibC::Double*, focus_y : LibC::Double*, subplot_element : Void*) : LibC::Int
    # fun get_context_data = grm_get_context_data : Void* # std::map<std::string, std::list<std::string>>
    # fun load_graphics_tree_schema = grm_load_graphics_tree_schema(with_private_attributes : Bool) : Void* # std::shared_ptr<GRM::Document>
  end
end
