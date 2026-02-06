module GRM
  {% if env("GRDIR") %}
    @[Link(ldflags: "-L `echo $GRDIR/lib` -lGRM -Wl,-rpath,`echo $GRDIR/lib`")]
  {% else %}
    @[Link("grm")]
  {% end %}
  lib LibGRM
    # Type definitions
    type ArgsT = Void*
    type ArgsPtrT = ArgsT

    struct ArgT
      key : LibC::Char*
      value_ptr : Void*
      value_format : LibC::Char*
      priv : Void*
    end

    struct ArgsIteratorT
      next : (ArgsIteratorT* -> ArgT*)
      arg : ArgT*
      priv : Void*
    end

    struct ArgsValueIteratorT
      next : (ArgsValueIteratorT* -> Void*)
      value_ptr : Void*
      format : LibC::Char
      is_array : LibC::Int
      array_length : LibC::SizeT
      priv : Void*
    end

    # File type for compatibility - treated as opaque pointer
    type File = Void*

    # Layout types
    type GridT = Void*
    type ElementT = Void*

    # Event system types
    enum EventTypeT
      GrmEventNewPlot        = 0
      GrmEventUpdatePlot     = 1
      GrmEventSize           = 2
      GrmEventMergeEnd       = 3
      GrmEventRequest        = 4
      GrmEventIntegralUpdate = 5
      X_GrmEventTypeCount    = 6
    end

    union EventT
      new_plot_event : NewPlotEventT
      size_event : SizeEventT
      update_plot_event : UpdatePlotEventT
      merge_end_event : MergeEndEventT
      request_event : RequestEventT
      integral_update_event : IntegralUpdateEventT
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

    struct RequestEventT
      type : EventTypeT
      request_string : LibC::Char*
    end

    struct IntegralUpdateEventT
      type : EventTypeT
      int_lim_low : LibC::Double
      int_lim_high : LibC::Double
    end

    type EventCallbackT = (EventT* -> Void)

    struct TooltipInfoT
      x : LibC::Double
      y : LibC::Double
      x_px : LibC::Int
      y_px : LibC::Int
      x_label : LibC::Char*
      y_label : LibC::Char*
      label : LibC::Char*
    end

    struct AccumulatedTooltipInfoT
      n : LibC::Int
      x : LibC::Double
      y : LibC::Double*
      x_px : LibC::Int
      y_px : LibC::Int
      x_label : LibC::Char*
      y_labels : LibC::Char**
    end

    enum ErrorT
      GrmErrorNone                                =  0
      GrmErrorUnspecified                         =  1
      GrmErrorInternal                            =  2
      GrmErrorMalloc                              =  3
      GrmErrorUnsupportedOperation                =  4
      GrmErrorUnsupportedDatatype                 =  5
      GrmErrorInvalidArgument                     =  6
      GrmErrorArgsInvalidKey                      =  7
      GrmErrorArgsIncreasingNonArrayValue         =  8
      GrmErrorArgsIncreasingMultiDimensionalArray =  9
      GrmErrorParseNull                           = 10
      GrmErrorParseBool                           = 11
      GrmErrorParseInt                            = 12
      GrmErrorParseDouble                         = 13
      GrmErrorParseString                         = 14
      GrmErrorParseArray                          = 15
      GrmErrorParseObject                         = 16
      GrmErrorParseUnknownDatatype                = 17
      GrmErrorParseInvalidDelimiter               = 18
      GrmErrorParseIncompleteString               = 19
      GrmErrorParseMissingObjectContainer         = 20
      GrmErrorParseXmlNoSchemaFile                = 21
      GrmErrorParseXmlInvalidSchema               = 22
      GrmErrorParseXmlFailedSchemaValidation      = 23
      GrmErrorParseXmlParsing                     = 24
      GrmErrorNetworkWinsockInit                  = 25
      GrmErrorNetworkSocketCreation               = 26
      GrmErrorNetworkSocketBind                   = 27
      GrmErrorNetworkSocketListen                 = 28
      GrmErrorNetworkConnectionAccept             = 29
      GrmErrorNetworkHostnameResolution           = 30
      GrmErrorNetworkConnect                      = 31
      GrmErrorNetworkRecv                         = 32
      GrmErrorNetworkRecvUnsupported              = 33
      GrmErrorNetworkRecvConnectionShutdown       = 34
      GrmErrorNetworkSend                         = 35
      GrmErrorNetworkSendUnsupported              = 36
      GrmErrorNetworkSocketClose                  = 37
      GrmErrorNetworkWinsockCleanup               = 38
      GrmErrorCustomRecv                          = 39
      GrmErrorCustomSend                          = 40
      GrmErrorPlotColormap                        = 41
      GrmErrorPlotNormalization                   = 42
      GrmErrorPlotUnknownKey                      = 43
      GrmErrorPlotUnknownAlgorithm                = 44
      GrmErrorPlotMissingAlgorithm                = 45
      GrmErrorPlotUnknownKind                     = 46
      GrmErrorPlotMissingData                     = 47
      GrmErrorPlotComponentLengthMismatch         = 48
      GrmErrorPlotMissingDimensions               = 49
      GrmErrorPlotMissingLabels                   = 50
      GrmErrorPlotInvalidId                       = 51
      GrmErrorPlotOutOfRange                      = 52
      GrmErrorPlotIncompatibleArguments           = 53
      GrmErrorPlotInvalidRequest                  = 54
      GrmErrorBase64BlockTooShort                 = 55
      GrmErrorBase64InvalidCharacter              = 56
      GrmErrorLayoutInvalidIndex                  = 57
      GrmErrorLayoutContradictingAttributes       = 58
      GrmErrorLayoutInvalidArgumentRange          = 59
      GrmErrorLayoutComponentLengthMismatch       = 60
      GrmErrorTmpDirCreation                      = 61
      GrmErrorNotImplemented                      = 62
    end

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/args.h
    fun arg_value_iter = grm_arg_value_iter(arg : ArgT*) : ArgsValueIteratorT*
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

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/base64.h
    fun base64_decode = grm_base64_decode(dst : LibC::Char*, src : LibC::Char*, dst_len : LibC::SizeT*, was_successful : LibC::Int*) : LibC::Char*
    fun base64_encode = grm_base64_encode(dst : LibC::Char*, src : LibC::Char*, src_len : LibC::SizeT, was_successful : LibC::Int*) : LibC::Char*

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/util.h
    fun get_stdout = grm_get_stdout : File*

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

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/layout.h
    fun grid_new = grm_grid_new(nrows : LibC::Int, ncols : LibC::Int, a_grid : GridT*) : ErrorT
    fun grid_print = grm_grid_print(grid : GridT)
    fun grid_set_element = grm_grid_set_element(row : LibC::Int, col : LibC::Int, a_element : ElementT, a_grid : GridT) : ErrorT
    fun grid_set_element_args = grm_grid_set_element_args(row : LibC::Int, col : LibC::Int, subplot_args : ArgsT, a_grid : GridT) : ErrorT
    fun grid_set_element_slice = grm_grid_set_element_slice(row_start : LibC::Int, row_stop : LibC::Int, col_start : LibC::Int, col_stop : LibC::Int, a_element : ElementT, a_grid : GridT) : ErrorT
    fun grid_set_element_args_slice = grm_grid_set_element_args_slice(row_start : LibC::Int, row_stop : LibC::Int, col_start : LibC::Int, col_stop : LibC::Int, subplot_args : ArgsT, a_grid : GridT) : ErrorT
    fun grid_get_element = grm_grid_get_element(row : LibC::Int, col : LibC::Int, a_grid : GridT, a_element : ElementT*) : ErrorT
    fun grid_ensure_cell_is_grid = grm_grid_ensure_cell_is_grid(row : LibC::Int, col : LibC::Int, a_grid : GridT) : ErrorT
    fun grid_ensure_cells_are_grid = grm_grid_ensure_cells_are_grid(row_start : LibC::Int, row_stop : LibC::Int, col_start : LibC::Int, col_stop : LibC::Int, a_grid : GridT) : ErrorT
    fun grid_finalize = grm_grid_finalize(a_grid : GridT)
    fun grid_delete = grm_grid_delete(grid : GridT)
    fun trim = grm_trim(a_grid : GridT)

    fun element_new = grm_element_new(a_element : ElementT*) : ErrorT
    fun element_set_abs_height = grm_element_set_abs_height(a_element : ElementT, height : LibC::Double) : ErrorT
    fun element_set_relative_height = grm_element_set_relative_height(a_element : ElementT, height : LibC::Double) : ErrorT
    fun element_set_abs_width = grm_element_set_abs_width(a_element : ElementT, width : LibC::Double) : ErrorT
    fun element_set_relative_width = grm_element_set_relative_width(a_element : ElementT, width : LibC::Double) : ErrorT
    fun element_set_aspect_ratio = grm_element_set_aspect_ratio(a_element : ElementT, ar : LibC::Double) : ErrorT
    fun element_set_fit_parents_height = grm_element_set_fit_parents_height(a_element : ElementT, fit_parents_height : LibC::Int)
    fun element_set_fit_parents_width = grm_element_set_fit_parents_width(a_element : ElementT, fit_parents_width : LibC::Int)
    fun element_get_subplot = grm_element_get_subplot(a_element : ElementT, subplot : LibC::Double**)

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
    fun export = grm_export(file_path : LibC::Char*, export_xml : LibC::Int) : LibC::Int
    fun switch = grm_switch(id : LibC::UInt) : LibC::Int
    fun load_graphics_tree = grm_load_graphics_tree(file : File*) : LibC::Int
    fun validate = grm_validate : LibC::Int
    fun get_error_code = grm_get_error_code : LibC::Int

    # https://github.com/sciapp/gr/blob/master/lib/grm/include/grm/import.h
    fun interactive_plot_from_file = grm_interactive_plot_from_file(args : ArgsT, argc : LibC::Int, argv : LibC::Char**) : LibC::Int
    fun plot_from_file = grm_plot_from_file(argc : LibC::Int, argv : LibC::Char**) : LibC::Int
  end
end
