require "./gr_common/config.cr"
require "./grm/libgrm"

module GRM
  extend self
  # Forwardable methods
  {% for name in %w[
                   args_new
                   args_push
                   plot
                   clear
                 ] %}
    def {{name.id}}(*args)
      LibGRM.{{name.id}}(*args)
    end
  {% end %}
end
