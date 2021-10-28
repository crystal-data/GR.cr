module GR
  class GRparms
    @@charheight = 0.027

    def self.charheight
      @@charheight
    end

    def self.charheight(x)
      @@charheight = x
    end

    @@winmax = [1.0, 1.0]
    @@winmin = [0.0, 0.0]

    def self.winmax
      @@winmax
    end

    def self.winmax(x)
      @@winmax = x
    end

    def self.winmin
      @@winmin
    end

    def self.winmin(x)
      @@winmin = x
    end
  end

  def box(x_tick = (GRparms.winmax[0] - GRparms.winmin[0]) * 0.25,
          y_tick = (GRparms.winmax[1] - GRparms.winmin[1]) * 0.25,
          x_org = GRparms.winmin[0], y_org = GRparms.winmin[1], major_x = 1, major_y = 1, tick_size = 0.01, xlog = false, ylog = false)
    scalearg = 0
    scalearg += 1 if xlog
    scalearg += 2 if ylog
    LibGR.setscale(scalearg)
    LibGR.setcharheight(GRparms.charheight.to_f)
    LibGR.axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size)
    LibGR.setcharheight(0.00001)
    LibGR.axes(x_tick, y_tick, GRparms.winmax[0], GRparms.winmax[1], major_x, major_y,
      -tick_size)
    LibGR.setcharheight(GRparms.charheight.to_f)
  end
end
