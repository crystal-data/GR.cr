require "./grlib.cr"
include Math
include GR
setwindow(0,1,0,1)
setviewport(0.1, 0.9,0.1, 0.9)
box
n=50
dx = 1.0/n
x=Array(Float64).new(n){|i| i*dx+dx/2}
y=Array(Float64).new(n){|i| i*dx+dx/2}
h=Array(Float64).new(11){|i| i*0.2-1}
z = Array(Float64).new
n.times{|i| 
  n.times{|j|
    # xd=x[i]-0.5
    # yd=y[j]-0.5
    # z.push exp(-(xd*xd+yd*yd)*10)
    z.push sin(x[i]*PI*2)*sin(y[j]*PI)
  }
}
#p! x, y, z
contourf(x,y,h,z, 3)
setviewport(0.9, 0.92,0.1, 0.9)
colorbar

c=gets
