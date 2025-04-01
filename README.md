# Dustywave

Example program for computing the DUSTYWAVE exact solution from Laibe & Price (2011) `DUSTYBOX and DUSTYWAVE: two test problems for numerical simulations of two-fluid astrophysical dust-gas mixtures <http://adsabs.harvard.edu/abs/2011MNRAS.418.1491L>`_, MNRAS 418, 1491L
http://arXiv.org/abs/1106.1736

## requirements
You will need to have gfortran, the Gnu Fortran Compiler, installed::

  brew install gfortran

or

  sudo apt install gfortran

## how to run the code

Type "make" to compile the Fortran example code.

run ./dustywave to generate the dustywave solutions.

The file "dustywave.mws" is a Maple worksheet that can be used to
produce the analytic expressions.
