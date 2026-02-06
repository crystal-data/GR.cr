require "../src/grm"

n = 1000
x = [] of Float64
y = [] of Float64
z = [] of Float64
n.times do |i|
  x << i * 30.0 / n
  y << Math.cos(x[i]) * x[i]
  z << Math.sin(x[i]) * x[i]
end

plot_types = %w[line hexbin stairs shade stem scatter
  contour surface plot3 scatter3]

plot_types.each do |type|
  puts "Plotting: #{type}"
  GRM.clear
  args = GRM::Args.new
  args.push("x", x)
  args.push("y", y)
  args.push("z", z)
  args.push("kind", type)
  args.push("title", type)
  GRM.plot(args)
  sleep 2.seconds
end
