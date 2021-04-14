# GR.cr

[Crystal](https://github.com/crystal-lang/crystal) bindings to [GR framework](https://github.com/sciapp/gr)

GR.cr has been forked from [gr-crystal](https://github.com/jmakino/gr-crystal) by [Jun Makino](https://github.com/jmakino)

:construction: Under development

## Installation

### GR Installation

#### Linux - APT

[packages.red-data-tools.org](https://github.com/red-data-tools/packages.red-data-tools.org) provides `libgr-dev`, `libgr3-dev` and `libgrm-dev`

Debian GNU/Linux and Ubuntu 

```sh
sudo apt install -y -V ca-certificates lsb-release wget
wget https://packages.red-data-tools.org/$(lsb_release --id --short | tr 'A-Z' 'a-z')/red-data-tools-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt install -y -V ./red-data-tools-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt update
sudo apt install libgrm-dev
```

#### Linux - Yum

CentOS

```sh
(. /etc/os-release && sudo dnf install -y https://packages.red-data-tools.org/centos/${VERSION_ID}/red-data-tools-release-latest.noarch.rpm)
sudo dnf install -

#### GR.cr

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  grlib:
    github: jmakino/gr-crystal
```

Run `shards install`

## API Overview (Plan)

```
  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
  │     GRM      │  │      GR      │  │      GR3     │
  │ ┌──────────┐ │  │ ┌──────────┐ │  │ ┌──────────┐ │
  │ │  LibGRM  │ │  │ │  LibGR   │ │  │ │  LibGR3  │ │
  │ │          │ │  │ │          │ │  │ │          │ │
  │ │          │ │  │ │          │ │  │ │          │ │
  │ └──────────┘ │  │ └──────────┘ │  │ └──────────┘ │
  │              │  │              │  │              │
  │              │  │              │  │              │
  └──────────────┘  └──────────────┘  └──────────────┘
```

## Quick Start

```crystal
require "../src/grm"
LibGRM = GR::GRM::LibGRM

n = 1000
x = [] of Float64
y = [] of Float64
z = [] of Float64
n.times do |i|
  x << i * 30.0 / n
  y << Math.cos(x[i]) * x[i]
  z << Math.sin(x[i]) * x[i]
end

plot_types = %w[line hexbin polar shade stem step contour contourf tricont
               trisurf surface wireframe plot3 scatter scatter3 quiver
               hist barplot polar_histogram pie]

plot_types.each do |type|
  LibGRM.grm_clear
  args = LibGRM.grm_args_new
  LibGRM.grm_args_push(args, "x", "nD", n, x)
  LibGRM.grm_args_push(args, "y", "nD", n, y)
  LibGRM.grm_args_push(args, "z", "nD", n, z)
  LibGRM.grm_args_push(args, "kind", "s", type)
  LibGRM.grm_args_push(args, "title", "s", type)
  LibGRM.grm_plot(args)
  sleep 2
end
```

## Usage

## Development

Use [c2ffi](https://github.com/rpav/c2ffi) to generate bindings.

* Run `script/c2ffi.cr` to generate json files from C headers.
* Run `script/convert.rb gr.json > gr.txt` to generate bindings.

## Acknowledgements

