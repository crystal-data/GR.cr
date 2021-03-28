require "./grm/libgrm.cr"

module GR
  module GRM
    extend self
    # FIXME: Need a lot of improvements...
    {% for m_name in %w[grm_args_new grm_args_push grm_plot grm_clear] %}
      def {{m_name.id["grm_".size..-1]}}(*args)
        LibGRM.{{m_name.id}}(*args)
      end
    {% end %}
  end
end
