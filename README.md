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

## Plotting the results

By default the code prints a series of ascii files showing the solution at different times
```
dustywave-energies.out	dustywave-t1.000.out	dustywave-t2.100.out	dustywave-t3.200.out	dustywave-t4.300.out
dustywave-t0.000.out	dustywave-t1.100.out	dustywave-t2.200.out	dustywave-t3.300.out	dustywave-t4.400.out
dustywave-t0.100.out	dustywave-t1.200.out	dustywave-t2.300.out	dustywave-t3.400.out	dustywave-t4.500.out
dustywave-t0.200.out	dustywave-t1.300.out	dustywave-t2.400.out	dustywave-t3.500.out	dustywave-t4.600.out
dustywave-t0.300.out	dustywave-t1.400.out	dustywave-t2.500.out	dustywave-t3.600.out	dustywave-t4.700.out
dustywave-t0.400.out	dustywave-t1.500.out	dustywave-t2.600.out	dustywave-t3.700.out	dustywave-t4.800.out
dustywave-t0.500.out	dustywave-t1.600.out	dustywave-t2.700.out	dustywave-t3.800.out	dustywave-t4.900.out
dustywave-t0.600.out	dustywave-t1.700.out	dustywave-t2.800.out	dustywave-t3.900.out	dustywave-t5.000.out
dustywave-t0.700.out	dustywave-t1.800.out	dustywave-t2.900.out	dustywave-t4.000.out
dustywave-t0.800.out	dustywave-t1.900.out	dustywave-t3.000.out	dustywave-t4.100.out
dustywave-t0.900.out	dustywave-t2.000.out	dustywave-t3.100.out	dustywave-t4.200.out
```
To plot the output data using Python:

```python
import numpy as np
import matplotlib.pyplot as plt

# Load the data (columns are: x, vgas, vdust, rhogas, rhodust)
data = np.loadtxt('dustywave-t1.800.out')

# Create a simple plot
plt.figure(figsize=(10, 6))
plt.plot(data[:, 0], data[:, 1], label='vgas')
plt.plot(data[:, 0], data[:, 2], label='vdust')
plt.xlabel('x')
plt.ylabel('Velocity')
plt.legend()
plt.show()
```

You can modify the column indices to plot different quantities:
- Column 0: x position
- Column 1: gas velocity
- Column 2: dust velocity
- Column 3: gas density
- Column 4: dust density


