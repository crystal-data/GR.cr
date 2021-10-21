require "../src/gr"

GR.setviewport(0.1, 0.8, 0.2, 0.9)
GR.setwindow(-0.5, 3.5, -0.5, 3.5)
GR.axes(1, 1, -0.5, -0.5, 1, 1, -0.01)
GR.setcolormap(1)

c = Array(Int32).new(25) do |i|
  (1000 + 255 * i / 24).to_i
end

GR.cellarray(-0.5, 3.5, -0.5, 3.5, 5, 5, c)
GR.setviewport(0.825, 0.85, 0.2, 0.9)
GR.colorbar
GR.updatews

gets
