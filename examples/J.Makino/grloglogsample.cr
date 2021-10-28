# sample for log-log plot

require "../../src/gr"

include GR

setwindow(0.1, 1, 0.01, 1)                        # range should be in original values
setscale(3)                                       # 1: log x, 2: log y (and thus 3: both)
box(0.25, 0.1, 0.1, 0.01, xlog: true, ylog: true) # xlog and ylog controls axes
n = 21
dx = 1.0/(n - 1)
x = Array(Float64).new(n) { |i| (i + 1)*dx }
polymarker(x, Array(Float64).new(n) { |i| x[i]*x[i] })
setcharheight(0.05)
mathtex(0.5, 0.06, "x")
mathtex(0.06, 0.5, "y")
updatews

gets
