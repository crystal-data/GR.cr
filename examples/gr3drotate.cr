#
# gr3drorate.cf
#
#  sample to make mp4 file 

require "./grlib.cr"
include Math
include GR
#ENV["GKS_WSTYPE"]= "mp4" # to make mp4 file. You can also use gif or mov
ENV["GKS_DOUBLE_BUF"]= "true" if  ENV["GKS_DOUBLE_BUF"]?==nil
setwindow(0,1,0,1)
setviewport(0.1, 0.9,0.1, 0.9)
n=50
dx = 1.0/n
x=Array(Float64).new(n){|i| i*dx+dx/2}
y=Array(Float64).new(n){|i| i*dx+dx/2}
h=Array(Float64).new(11){|i| i*0.2-1}
z = Array(Float64).new
n.times{|i| 
  n.times{|j|
    z.push (sin(x[i]*PI*2)*sin(y[j]*PI)+1)/2
  }
}
90.times{|i|
  clearws()
  setspace(0,1,30, i)
  axes3d(0.2, 0.2, 0.2, 0.0, 0.0, 0.0, 1,1,1,0.01)
  surface(x,y,z, 4)
  contour(x,y,h,z, 3)
  updatews()
  sleep 0.05 if ENV["GKS_WSTYPE"]=="x11"
}
