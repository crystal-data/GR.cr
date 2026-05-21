require "../../src/gr"
require "../../src/gr/makino"

n = 21
x = Array(Float64).new(n) { |i| (i + 1) / n }
y = x.map { |value| value * value }

GR.setwindow(0.1, 1, 0.01, 1)
GR.setviewport(0.12, 0.9, 0.15, 0.85)
GR.setscale(3)
GR.box(0.25, 0.1, 0.1, 0.01, xlog: true, ylog: true)
GR.polymarker(x, y)
GR.setcharheight(0.05)
GR.mathtex(0.5, 0.06, "x")
GR.mathtex(0.06, 0.5, "y")
GR.updatews
STDIN.gets if STDIN.tty?
