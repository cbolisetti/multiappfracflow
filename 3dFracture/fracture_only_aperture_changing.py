import os
import sys
import numpy as np
import matplotlib.pyplot as plt


plt.figure()
data = np.genfromtxt(r'fracture_only_aperture_changing_out_0.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0, data['TK_out'][1:] - 273, label='9.2m')
data = np.genfromtxt(r'fracture_only_aperture_changing_out_1.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0, data['TK_out'][1:] - 273, label='4.6m')
data = np.genfromtxt(r'fracture_only_aperture_changing_out_2.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0, data['TK_out'][1:] - 273, label='2.3m')
plt.grid()
plt.legend()
plt.title("Production temperature: no heat transfer, various mesh sizes")
plt.xlim([0, 4])
plt.xlabel("time (hours)")
plt.ylabel("T (degC)")
plt.savefig("../doc/content/media/fracture_only_aperture_changing_T_out.png")
plt.show()
plt.close()

plt.figure()
data = np.genfromtxt(r'fracture_only_aperture_changing_out_0.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0, data['P_out'][1:], label='9.2m')
data = np.genfromtxt(r'fracture_only_aperture_changing_out_1.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0, data['P_out'][1:], label='4.6m')
data = np.genfromtxt(r'fracture_only_aperture_changing_out_2.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0, data['P_out'][1:], label='2.3m')
plt.grid()
plt.legend()
plt.title("Production porepressure: no heat transfer, various mesh sizes")
plt.xlim([0, 4])
plt.xlabel("time (hours)")
plt.ylabel("P (MPa)")
plt.savefig("../doc/content/media/fracture_only_aperture_changing_P_out.png")
plt.show()
plt.close()
sys.exit(0)
