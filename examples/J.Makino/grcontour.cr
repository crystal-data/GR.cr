require "../../src/gr"
require "../../src/gr/makino"

n = 50
step = 1.0 / n
x = Array(Float64).new(n) { |i| i * step + step / 2 }
y = Array(Float64).new(n) { |i| i * step + step / 2 }
z = Array(Float64).new(n * n) do |index|
  i = index // n
  j = index % n
  Math.sin(x[i] * Math::PI * 2) * Math.sin(y[j] * Math::PI)
end
levels = Array(Float64).new(11) { |i| i * 0.2 - 1 }

GR.setwindow(0, 1, 0, 1)
GR.setviewport(0.1, 0.86, 0.12, 0.88)
GR.box
GR.contourf(x, y, levels, z, 3)
GR.setviewport(0.9, 0.92, 0.12, 0.88)
GR.colorbar
GR.updatews
STDIN.gets if STDIN.tty?
