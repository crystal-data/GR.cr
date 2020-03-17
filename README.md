# gr-crystal
Crystal binding for GR framework

A (still incomplete) interface to GR framework from Crystal


## Installation


0. You need to install GR in the standard way and set the enviromental variable GRDIR point to the installed directory.

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     grlib:
       github: jmakino/gr-crystal
   ```

2. Run `shards install`


## Getting started

At your project directory (where you ran shards install), try

   crystal lib/grlib/examples/grsample.cr

should show a simple plot.

* GRDIR env variable should point to the directory where you placed
  gr files. In particular,  lib and fonts directories should be there
* GKS_WSTYPE env variable should be set. For X11, its value should
  be "x11".
  

## Usage

Essentially the same as that for C binging. Difference:

* All size+pointer arguments to C array are replaced by  Crystal
  arrays.

* C char* is replaced by Crysral Sring

### Example of API

    void gr_polyline(int, double *, double *)


is called as


    GR.polyline(Array(Float64), Array(Float64))

## Examples

[polyline plot](./examples/grsample.cr)

![polyline sample output](./images/grsample-sample.jpg)

[contour plot](./examples/grcontour.cr)

![contour sample output](./images/grcontour-sample.jpg)

[3d contour plot](./examples/grcontour3d.cr)

![contour sample output](./images/grcontour3d-sample.jpg)

[3d animation](./examples/gr3drotate.cr)

![3d animation sample output](./images/gr3drotate.gif)

[log-log plot](./examples/grloglogsample.cr)

![log-log plot sample output](./images/grloglogsample.jpg)

[semilog plot](./examples/grsemilogsample.cr)

![semilog plot sample output](./images/grsemilogsample.jpg)



## Todo

All source and documents should be generated automatically...
