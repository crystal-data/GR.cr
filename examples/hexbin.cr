require "../src/gr"

n, mean, sd, tau = 1000, 0, 1, (2 * Math::PI)
x = Array.new(n) { mean + sd * Math.sqrt(-2 * Math.log(rand)) * Math.cos(tau * rand) }
y = Array.new(n) { mean + sd * Math.sqrt(-2 * Math.log(rand)) * Math.cos(tau * rand) }

GR.clearws
GR.setviewport(0.1, 0.8, 0.2, 0.9)
GR.setwindow(-4, 4, -4, 4)
GR.setcolormap 21
GR.hexbin(x, y, 40)
GR.setviewport(0.825, 0.85, 0.2, 0.9)
GR.colorbar
GR.updatews
gets
