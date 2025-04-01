import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import re
import glob

def get_time_from_filename(filename):
    # Extract time from filename format 'dustywave-t1.900.out'
    match = re.search(r't(\d+\.\d+)', filename)
    return float(match.group(1)) if match else 0.0

def read_dustywave_file(filename):
    # Read header (first line) to get column labels
    with open(filename, 'r') as f:
        header = f.readline().strip('# []\n').split('][')
    
    # Load the numerical data, skipping header
    data = np.loadtxt(filename, skiprows=1)
    return header, data

# Get all files and sort by time
files = sorted(glob.glob('dustywave-t*.out'))
if not files:
    print("No dustywave output files found!")
    exit(1)

times = [get_time_from_filename(f) for f in files]

# Read first file to get x range
header, first_data = read_dustywave_file(files[0])
x = first_data[:, 0]

# Set up the figure and animation
plt.rcParams['axes.grid'] = True
plt.rcParams['grid.alpha'] = 0.3
fig = plt.figure(figsize=(10, 8))
gs = fig.add_gridspec(2, 1, height_ratios=[1, 1], hspace=0.3)
ax1 = fig.add_subplot(gs[0])
ax2 = fig.add_subplot(gs[1])

fig.suptitle('Dustywave Evolution', y=0.95, size=14)

# Set x limits for both plots
ax1.set_xlim(x.min(), x.max())
ax2.set_xlim(x.min(), x.max())

# Find y limits from all data
v_min, v_max = float('inf'), float('-inf')
rho_min, rho_max = float('inf'), float('-inf')
for file in files:
    _, data = read_dustywave_file(file)
    v_min = min(v_min, data[:, 1].min(), data[:, 2].min())
    v_max = max(v_max, data[:, 1].max(), data[:, 2].max())
    rho_min = min(rho_min, data[:, 3].min(), data[:, 4].min())
    rho_max = max(rho_max, data[:, 3].max(), data[:, 4].max())

# Add some padding to the limits
v_pad = 0.1 * (v_max - v_min)
rho_pad = 0.1 * (rho_max - rho_min)
ax1.set_ylim(v_min - v_pad, v_max + v_pad)
ax2.set_ylim(rho_min - rho_pad, rho_max + rho_pad)

# Initialize lines with the correct x data
line_vgas, = ax1.plot(x, np.zeros_like(x), label='Gas velocity', lw=2, color='#1f77b4')
line_vdust, = ax1.plot(x, np.zeros_like(x), '--', label='Dust velocity', lw=2, color='#ff7f0e')
line_rhogas, = ax2.plot(x, np.zeros_like(x), label='Gas density', lw=2, color='#1f77b4')
line_rhodust, = ax2.plot(x, np.zeros_like(x), '--', label='Dust density', lw=2, color='#ff7f0e')

# Add labels and legends
ax1.set_ylabel('Velocity', size=12)
ax1.legend(loc='upper right', framealpha=0.9)
ax2.set_xlabel('x', size=12)
ax2.set_ylabel('Density', size=12)
ax2.legend(loc='upper right', framealpha=0.9)

# Make tick labels larger
ax1.tick_params(labelsize=10)
ax2.tick_params(labelsize=10)

time_text = ax1.text(0.02, 0.95, '', transform=ax1.transAxes, size=12, bbox=dict(facecolor='white', alpha=0.8, edgecolor='none'))

def animate(i):
    header, data = read_dustywave_file(files[i])
    time = times[i]
    
    line_vgas.set_ydata(data[:, 1])
    line_vdust.set_ydata(data[:, 2])
    line_rhogas.set_ydata(data[:, 3])
    line_rhodust.set_ydata(data[:, 4])
    
    time_text.set_text(f't = {time:.3f}')

ani = animation.FuncAnimation(fig, animate, frames=len(files),
                            interval=100)  # 100ms between frames

# Uncomment the next line to save the animation
#ani.save('dustywave.mp4', writer='ffmpeg')

plt.show()
