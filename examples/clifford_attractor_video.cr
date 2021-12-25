ENV["GKS_WSTYPE"] = "120"                 # mp4
ENV["GKS_VIDEO_OPTS"] = "1080x1080@60@x2" # <width>x<height>@<framerate>

require "../src/gr"

600.times do |e|
  printf("\r%d", e)

  n = 1_000_000 # Increasing the value gives a clearer image.
  x0 = 0.0
  y0 = 0.0

  a = 3 - (e / 100.0)
  b = -1.3
  c = -1.8
  d = -1.9
  dθ = 0.007

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
  GR.shadepoints(x, y, 5, 1080, 1080) # NOTE: use dims: xform: ?
  GR.updatews
end
