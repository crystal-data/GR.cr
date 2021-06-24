require "../src/gr"
include Math

LibGR = GR::LibGR

x = Array.new(29) { |i| -2 + i * 0.5 }
y = Array.new(29) { |i| -7 + i * 0.5 }
z = [] of Float64

29.times do |i|
  29.times do |j|
    r1 = sqrt((x[j] - 5)**2 + y[i]**2)
    r2 = sqrt((x[j] + 5)**2 + y[i]**2)
    z << (exp(cos(r1)) + exp(cos(r2)) - 0.9) * 25
  end
end

LibGR.gr_setcharheight(24.0 / 500)
LibGR.gr_settextalign(2, 1)

LibGR.gr_setwindow(-2, 12, -7, 7)
LibGR.gr_setspace(-80, 200, 45, 70)

LibGR.gr_setcharheight(14.0 / 500)
LibGR.gr_axes3d(1, 0, 20, -2, -7, -80, 2, 0, 2, -0.01)
LibGR.gr_axes3d(0, 1,  0, 12, -7, -80, 0, 2, 0,  0.01)

LibGR.gr_surface(x.size, y.size, x, y, z, 3)
LibGR.gr_surface(x.size, y.size, x, y, z, 1)

LibGR.gr_updatews

c = gets
