require "../../src/gr"

n = 50
step = 1.0 / n
x = Array(Float64).new(n) { |i| i * step + step / 2 }
y = Array(Float64).new(n) { |i| i * step + step / 2 }
z = Array(Float64).new(n * n) do |index|
  i = index // n
  j = index % n
  (Math.sin(x[i] * Math::PI * 2) * Math.sin(y[j] * Math::PI) + 1) / 2
end
levels = Array(Float64).new(11) { |i| i * 0.1 }

# Set GKS_WSTYPE=mp4, gif, or mov to write an animation file.
ENV["GKS_DOUBLE_BUF"] ||= "true"

GR.setwindow(0, 1, 0, 1)
GR.setviewport(0.1, 0.9, 0.1, 0.9)

90.times do |angle|
  GR.clearws
  GR.setspace(0, 1, 30, angle)
  GR.axes3d(0.2, 0.2, 0.2, 0.0, 0.0, 0.0, 1, 1, 1, 0.01)
  GR.surface(x, y, z, 4)
  GR.contour(x, y, levels, z, 3)
  GR.updatews
  sleep 50.milliseconds
end
