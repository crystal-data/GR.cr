require "../src/gr"

n = 100_000_000
x0 = 0.0; y0 = 0.0
a = -1.3; b = -1.3; c = -1.8; d = -1.9; dθ = 0.007

x = [x0]
y = [y0]
θ = 0.007

n.times do |i|
  x << (Math.sin(a * y[i]) + c * Math.cos(a * x[i])) * Math.cos(θ)
  y << (Math.sin(b * x[i]) + d * Math.cos(b * y[i])) * Math.cos(θ)
  θ += dθ
end

GR.setviewport(0, 1, 0, 1)
GR.setwindow(-3, 3, -3, 3)
GR.setcolormap(8)
GR.shadepoints(x, y, 5, 480, 480) # NOTE: use dims: xform: ?
GR.updatews

gets
