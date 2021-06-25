require "./grm/libgrm.cr"

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
      LibGRM.grm_{{name.id}}(*args)
    end
  {% end %}
end
