require "../../src/gr"
require "../../src/gr/makino"

GR.setwindow(0, 1, 0, 1)
GR.setviewport(0.12, 0.9, 0.15, 0.85)
GR.box
GR.polyline(
  [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  [0.3, 0.5, 0.4, 0.2, 0.6, 0.7]
)
GR.setcharheight(0.05)
GR.mathtex(0.3, 0.2, "x^2+y^2")
GR.updatews
STDIN.gets if STDIN.tty?
