# DUSTYWAVE

Example program for computing the DUSTYWAVE exact solution from Laibe & Price (2011) "DUSTYBOX and DUSTYWAVE: two test problems for numerical simulations of two-fluid astrophysical dust-gas mixtures", MNRAS 418, 1491L [[link to paper](http://adsabs.harvard.edu/abs/2011MNRAS.418.1491L)]

## Requirements
You will need to have gfortran, the Gnu Fortran Compiler, installed:
```
brew install gfortran
```
or
```
sudo apt install gfortran
```

## How to Run the Code

Type `make` to compile the Fortran example code.

Run `./dustywave` to generate the dustywave solutions.

The file `dustywave.mws` is a Maple worksheet that can be used to
produce the analytic expressions.
