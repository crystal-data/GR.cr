require "../src/gr"

GR.clearws
GR.setviewport(0.1, 0.8, 0.2, 0.9)
GR.setwindow(-2.5, 3.5, -2.5, 3.5)
GR.axes(1, 1, -0.5, -0.5, 1, 1, -0.01)

c = Array(Int32).new(21) do |i|
  (1000 + 255 * i / 20).to_i
end

GR.setcolormap(44)
GR.polarcellarray(0, 0, 0, 360, 0.2, 2, 3, 7, c)
GR.setviewport(0.825, 0.85, 0.2, 0.9)
GR.colorbar
GR.updatews

gets
