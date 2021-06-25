@[Include(
  "grm/args.h",
  "grm/dump.h",
  "grm/event.h",
  "grm/interaction.h",
  "grm/net.h",
  "grm/plot.h",
  "grm/util.h",
  prefix: %w(grm_),
  import_docstrings: "brief",
)]
@[Link("GRM")]
lib LibGRM
end
