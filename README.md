# GR.cr

[Crystal](https://github.com/crystal-lang/crystal) bindings to [GR framework](https://github.com/sciapp/gr)

GR.cr has been forked from [gr-crystal](https://github.com/jmakino/gr-crystal) by [Jun Makino](https://github.com/jmakino)

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
sudo dnf install -y gr-devel
```

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
┌────────────────────────────────────────────────────────┐
│                        GR module                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │     GRM      │  │      GR      │  │      GR3     │  │
│  │ ┌──────────┐ │  │ ┌──────────┐ │  │ ┌──────────┐ │  │
│  │ │  LibGRM  │ │  │ │  LibGR   │ │  │ │  LibGR3  │ │  │
│  │ │          │ │  │ │          │ │  │ │          │ │  │
│  │ │          │ │  │ │          │ │  │ │          │ │  │
│  │ └──────────┘ │  │ └──────────┘ │  │ └──────────┘ │  │
│  │              │  │              │  │              │  │
│  │              │  │              │  │              │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                        │
└────────────────────────────────────────────────────────┘
```

## Quick Start

## Usage

## Acknowledgements

