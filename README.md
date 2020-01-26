# gr-crystal
Crystal binding for GR framework

A (still incomplete) interface to GR framework from Crystal


## Installation

You need to place grlib.cr

You also need to install GR in the standard way.

grlib.cr assumes that  @[Link("GR")] works. That means all necessary
libraries from GR must be in the search pass of your ld. 

## Getting started

Download grsample.cr and

   crystal grsample.cr

should show simple plot.

## Usage

Essentially the same as that for C binging. Difference:

* All size+pointer arguments to C array is replaced by one Crystal
  array.
* C char* is replaced by Crysral Sring

### Example of API

 void gr_polyline(int, double *, double *)

is called as


  GR.polyline(Array(Float64), Array(Float64))

## Todo

All source and documents should be generate automatically...
