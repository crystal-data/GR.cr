# frozen_string_literal: true

require "../src/gr/grm"
GRM = GR::GRM#::LibGRM

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
  GRM.clear
  args = GRM.args_new
  GRM.args_push(args, "x", "nD", n, x)
  GRM.args_push(args, "y", "nD", n, y)
  GRM.args_push(args, "z", "nD", n, z)
  GRM.args_push(args, "kind", "s", type)
  GRM.args_push(args, "title", "s", type)
  GRM.plot(args)
  sleep 2
end