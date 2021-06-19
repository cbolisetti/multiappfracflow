import os
import sys
import numpy as np
import matplotlib.pyplot as plt


plt.figure()
data = np.genfromtxt(r'matrix_app_out_fracture_app0_00.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0 / 24.0, data['TK_out'][1:] - 273, label='20m, 9.2m')
data = np.genfromtxt(r'matrix_app_out_fracture_app0_10.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0 / 24.0, data['TK_out'][1:] - 273, label='10m, 9.2m')
data = np.genfromtxt(r'matrix_app_out_fracture_app0_11.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0 / 24.0, data['TK_out'][1:] - 273, label='10m, 4.6m')
data = np.genfromtxt(r'matrix_app_out_fracture_app0_21.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0 / 24.0, data['TK_out'][1:] - 273, label='5m, 4.6m')
data = np.genfromtxt(r'matrix_app_out_fracture_app0_22.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0 / 24.0, data['TK_out'][1:] - 273, label='5m, 2.3m')
plt.grid()
plt.legend()
plt.title("Production temperature: with heat transfer, various mesh sizes")
plt.xlim([0, 1000])
plt.xlabel("time (days)")
plt.ylabel("T (degC)")
plt.savefig("../doc/content/media/matrix_app_T.png")
plt.show()
plt.close()

sys.exit(0)
