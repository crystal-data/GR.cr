ENV["GKS_WSTYPE"] = "120"              # mp4
ENV["GKS_VIDEO_OPTS"] = "1080x1080@60" # <width>x<height>@<framerate>

require "../src/gr"
require "wait_group"

{% unless flag?(:preview_mt) && flag?(:execution_context) %}
  {% puts "WARNING: Use -Dpreview_mt -Dexecution_context for parallel frame generation." %}
{% end %}

N_POINTS = ENV["GR_VIDEO_POINTS"]?.try(&.to_i?) || 1_000_000 # Increasing the value gives a clearer image.
N_FRAMES = ENV["GR_VIDEO_FRAMES"]?.try(&.to_i?) || 600
DTHETA   = 0.007

def clifford_points(frame_index, n)
  x = Array(Float64).new(n)
  y = Array(Float64).new(n)
  px = 0.0
  py = 0.0
  theta = DTHETA
  a = 3 - (frame_index / 100.0)
  b = -1.3
  c = -1.8
  d = -1.9

  n.times do
    px, py = {
      (Math.sin(a * py) + c * Math.cos(a * px)) * Math.cos(theta),
      (Math.sin(b * px) + d * Math.cos(b * py)) * Math.cos(theta),
    }
    x << px
    y << py
    theta += DTHETA
  end

  {x, y}
end

record FrameData, index : Int32, x : Array(Float64), y : Array(Float64)

WORKER_COUNT  = Fiber::ExecutionContext.default_workers_count.clamp(1, N_FRAMES)
FRAME_CONTEXT = Fiber::ExecutionContext::Parallel.new("clifford-frames", WORKER_COUNT)

def produce_frames
  jobs = Channel(Int32).new(WORKER_COUNT)
  frames = Channel(FrameData).new(WORKER_COUNT)
  wait_group = WaitGroup.new(WORKER_COUNT)

  FRAME_CONTEXT.spawn do
    N_FRAMES.times { |frame_index| jobs.send(frame_index) }
    jobs.close
  end

  WORKER_COUNT.times do
    FRAME_CONTEXT.spawn do
      while frame_index = jobs.receive?
        x, y = clifford_points(frame_index, N_POINTS)
        frames.send(FrameData.new(frame_index, x, y))
      end
    ensure
      wait_group.done
    end
  end

  {frames, wait_group}
end

def draw_frame(frame_index, x, y)
  printf("\r%d", frame_index)

  GR.setviewport(0, 1, 0, 1)
  GR.setwindow(-3, 3, -3, 3)
  GR.setcolormap(8)
  GR.shadepoints(x, y, 5, 1080, 1080) # NOTE: use dims: xform: ?
  GR.updatews
end

frames, wait_group = produce_frames
pending = {} of Int32 => FrameData
next_frame = 0

N_FRAMES.times do
  frame = frames.receive
  pending[frame.index] = frame

  while ready = pending.delete(next_frame)
    draw_frame(ready.index, ready.x, ready.y)
    next_frame += 1
  end
end

wait_group.wait
