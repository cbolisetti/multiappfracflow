import os
import sys
import numpy as np
import matplotlib.pyplot as plt

def analytical_simple(t, x):
    return 1.0 / np.sqrt(4 * np.pi * t) * np.exp(-np.power(x, 2) / 4.0 / t)

def analytical_multi(t, x):
    # the heat transfer coefficient is 0.004
    return 0.5 * (1.0 + np.exp(-2 * 0.004 * t)) * analytical_simple(t, x)

# results with no heat transfer
plt.figure()
xvals = range(51)
plt.plot(xvals, analytical_simple(100.0, xvals), label='analytical')
data = np.genfromtxt(r'gold/single_var_final_csv_final_results_0001.csv', delimiter=',', names=True)
plt.plot(data['x'], data['T'], linestyle='dotted', marker='.', label='dt = 100')
data = np.genfromtxt(r'gold/single_var_final_csv_final_results_0010.csv', delimiter=',', names=True)
plt.plot(data['x'], data['T'], linestyle='dotted', marker='.', label='dt = 10')
data = np.genfromtxt(r'gold/single_var_final_csv_final_results_0100.csv', delimiter=',', names=True)
plt.plot(data['x'], data['T'], '.', label='dt = 1')
plt.grid()
plt.legend()
plt.title("Diffusion (no heat transfer) at t=100")
plt.xlim([0, 50])
plt.xlabel("x")
plt.ylabel("T")
plt.savefig("single_var.png")
plt.show()
plt.close()

# results with heat transfer but not using a MultiApp
plt.figure()
xvals = range(51)
plt.plot(xvals, analytical_multi(100.0, xvals), label='analytical')
data = np.genfromtxt(r'gold/two_vars_final_csv_final_results_0001.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], linestyle='dotted', marker='.', label='dt = 100')
data = np.genfromtxt(r'gold/two_vars_final_csv_final_results_0010.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], linestyle='dotted', marker='.', label='dt = 10')
data = np.genfromtxt(r'gold/two_vars_final_csv_final_results_0100.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], '.', label='dt = 1')
plt.grid()
plt.legend()
plt.title("Diffusion with heat transfer (no MultiApp) at t=100")
plt.xlim([0, 50])
plt.xlabel("x")
plt.ylabel("T")
plt.savefig("two_vars.png")
plt.show()
plt.close()

# results with MultiApp using transfer of temperature
plt.figure()
xvals = range(51)
plt.plot(xvals, analytical_multi(100.0, xvals), label='analytical')
data = np.genfromtxt(r'gold/fracture_app_final_csv_final_results_0001.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], linestyle='dotted', marker='.', label='dt = 100')
data = np.genfromtxt(r'gold/fracture_app_final_csv_final_results_0010.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], linestyle='dotted', marker='.', label='dt = 10')
data = np.genfromtxt(r'gold/fracture_app_final_csv_final_results_0100.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], '.', label='dt = 1')
plt.grid()
plt.legend()
plt.title('Diffusion with heat transfer (via "T" MultiApp) at t=100')
plt.xlim([0, 50])
plt.xlabel("x")
plt.ylabel("fracture T")
plt.savefig("fracture_app.png")
plt.show()
plt.close()

# results with MultiApp using transfer of heat energy
plt.figure()
xvals = range(51)
plt.plot(xvals, analytical_multi(100.0, xvals), label='analytical')
data = np.genfromtxt(r'gold/fracture_app_heat_final_csv_final_results_0001.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], linestyle='dotted', marker='.', label='dt = 100')
data = np.genfromtxt(r'gold/fracture_app_heat_final_csv_final_results_0010.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], linestyle='dotted', marker='.', label='dt = 10')
data = np.genfromtxt(r'gold/fracture_app_heat_final_csv_final_results_0100.csv', delimiter=',', names=True)
plt.plot(data['x'], data['frac_T'], '.', label='dt = 1')
plt.grid()
plt.legend()
plt.title('Diffusion with heat transfer (via "heat" MultiApp) at t=100')
plt.xlim([0, 50])
plt.xlabel("x")
plt.ylabel("fracture T")
plt.savefig("fracture_app_heat.png")
plt.show()
plt.close()
