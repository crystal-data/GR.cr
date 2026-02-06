require "./libgrm"
require "./plot"

module GRM
  # Figure class for multiple plots
  class Figure
    @plots = [] of Plot
    @plot_id : Int32
    @title : String?
    @xlabel : String?
    @ylabel : String?
    @created : Bool = false
    @dirty : Bool = true

    @@next_plot_id : Int32 = 1

    getter plot_id : Int32 # For debugging and inspection

    def initialize
      @plots = [] of Plot
      # Use a deterministic small positive integer for plot_id
      # Start from 1 and increment for each new figure
      @plot_id = @@next_plot_id
      @@next_plot_id += 1
    end

    # External plot_id specification constructor
    def initialize(plot_id : Int32)
      @plots = [] of Plot
      @plot_id = plot_id
    end

    def add_plot(&block : Plot -> Plot)
      plot = Plot.new
      configured_plot = yield(plot)
      @plots << configured_plot
      @dirty = true # Mark as dirty when plots are added
      self
    end

    def add_plot(plot : Plot)
      @plots << plot
      @dirty = true # Mark as dirty when plots are added
      self
    end

    def show
      return self if @plots.empty?
      return self if @created && !@dirty # Nothing to do - skip work

      # Handle re-rendering: clear existing figure if already created
      if @created
        GRM.with_error_check("switch") { LibGRM.switch(@plot_id) }
        GRM.with_error_check("clear") { LibGRM.clear }
      end

      last_index = @plots.size - 1

      # Create clean temporary args for each series
      # Try alternative approach: merge each series individually instead of using merge_hold
      @plots.each_with_index do |plot, i|
        # Use Plot's build_series_args method to get clean args
        temp_args = plot.build_series_args

        # Add plot_id to the clean args
        GRM.with_error_check("args_push") { LibGRM.args_push(temp_args, "plot_id", "i", @plot_id) }

        # Include figure-level properties in the last series (no additional fig_args merge)
        if i == last_index
          GRM.with_error_check("args_push") { LibGRM.args_push(temp_args, "title", "s", @title.as(String)) } if @title
          GRM.with_error_check("args_push") { LibGRM.args_push(temp_args, "xlabel", "s", @xlabel.as(String)) } if @xlabel
          GRM.with_error_check("args_push") { LibGRM.args_push(temp_args, "ylabel", "s", @ylabel.as(String)) } if @ylabel
        end

        # Try merging each series individually instead of using merge_hold
        GRM.with_error_check("merge") { LibGRM.merge(temp_args) }

        GRM.with_error_check("args_delete") { LibGRM.args_delete(temp_args) }
      end

      @created = true
      @dirty = false
      self
    end

    def save(path : String)
      return self if @plots.empty?

      # Only render if dirty or not created yet
      show if !@created || @dirty

      # At this point, @created is true (figure exists in GRM)
      GRM.with_error_check("switch") { LibGRM.switch(@plot_id) } # Safe to switch to existing figure
      GRM.with_error_check("export") { LibGRM.export(path) }
      self
    end

    # Figure-level label setting methods
    def title(text : String)
      @title = text
      @dirty = true # Mark as dirty when properties change
      self
    end

    def xlabel(text : String)
      @xlabel = text
      @dirty = true # Mark as dirty when properties change
      self
    end

    def ylabel(text : String)
      @ylabel = text
      @dirty = true # Mark as dirty when properties change
      self
    end

    # Convenience methods
    def to_html(id : String? = nil) : String
      return "" if @plots.empty?

      # Only render if dirty or not created yet
      show if !@created || @dirty

      # At this point, @created is true (figure exists in GRM)
      GRM.with_error_check("switch") { LibGRM.switch(@plot_id) } # Safe to switch to existing figure
      html_ptr = id ? GRM.with_error_check("dump_html") { LibGRM.dump_html(id) } : GRM.with_error_check("dump_html") { LibGRM.dump_html(nil) }
      String.new(html_ptr)
    end

    def to_json : String
      return "{}" if @plots.empty?

      # Only render if dirty or not created yet
      show if !@created || @dirty

      # At this point, @created is true (figure exists in GRM)
      GRM.with_error_check("switch") { LibGRM.switch(@plot_id) } # Safe to switch to existing figure
      json_ptr = GRM.with_error_check("dump_json_str") { LibGRM.dump_json_str }
      String.new(json_ptr)
    end

    def clear
      # Clear the figure if it was created
      if @created
        GRM.with_error_check("switch") { LibGRM.switch(@plot_id) }
        GRM.with_error_check("clear") { LibGRM.clear }
      end

      @plots.clear
      @created = false
      @dirty = true
      self
    end
  end
end
