require "../src/grm"

n = 1000
x = (0...n).map { |i| i * 30.0 / n }
y = x.map { |v| Math.cos(v) * v }
z = x.map { |v| Math.sin(v) * v }

GRM.clear
GRM.line(x, y, title: "line")
sleep 2.seconds

GRM.clear
GRM.hexbin(x, y, title: "hexbin")
sleep 2.seconds

GRM.clear
GRM.polar(x, y, title: "polar")
sleep 2.seconds

GRM.clear
GRM.stem(x, y, title: "stem")
sleep 2.seconds

GRM.clear
GRM.step(x, y, title: "step")
sleep 2.seconds

GRM.clear
GRM.scatter(x, y, title: "scatter")
sleep 2.seconds

GRM.clear
GRM.scatter3d(x, y, z, title: "scatter3")
sleep 2.seconds
