# frozen_string_literal: true

require "../src/gr/grm"
LibGRM = GR::GRM::LibGRM

n = 1000
x = [] of Float64
y = [] of Float64
z = [] of Float64
n.times do |i|
  x << i * 30.0 / n
  y << Math.cos(x[i]) * x[i]
  z << Math.sin(x[i]) * x[i]
end

plot_types = %w[line hexbin polar shade stem step contour contourf tricont
               trisurf surface wireframe plot3 scatter scatter3 quiver
               hist barplot polar_histogram pie]

plot_types.each do |type|
  LibGRM.grm_clear
  args = LibGRM.grm_args_new
  LibGRM.grm_args_push(args, "x", "nD", n, x)
  LibGRM.grm_args_push(args, "y", "nD", n, y)
  LibGRM.grm_args_push(args, "z", "nD", n, z)
  LibGRM.grm_args_push(args, "kind", "s", type)
  LibGRM.grm_args_push(args, "title", "s", type)
  LibGRM.grm_plot(args)
  sleep 2
end
