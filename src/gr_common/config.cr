# Set gksqt as default because gksterm does not work with homebrew packages.
{% if flag?(:darwin) %}
  ENV["GKSwstype"] ||= "gksqt"
{% end %}

# Set UTF-8 so that non-alphabetic characters can be displayed.
ENV["GKS_ENCODING"] ||= "utf8"
