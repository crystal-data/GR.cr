require "./gr3/libgr3.cr"

module GR3
  extend self

  # Forwardable methods
  # curl -sl https://raw.githubusercontent.com/sciapp/gr/v0.57.2/lib/gr3/gr3.h | grep -v '^#' | grep GR3API | grep -v '*' | grep -v '\[' | cut -f2 -d_ | sed 's/(.*//g'
  {% for name in %w[
                   terminate
                   clear
                   usecurrentframebuffer
                   useframebuffer
                   setquality
                   drawimage
                   deletemesh
                   cameralookat
                   setcameraprojectionparameters
                   setlightdirection
                   setbackgroundcolor
                   setobjectid
                   getprojectiontype
                   setprojectiontype
                   drawsurface
                   setorthographicprojection
                 ] %}
    def {{name.id}}(*args)
      LibGR.gr3_{{name.id}}(*args)
    end
  {% end %}
end
