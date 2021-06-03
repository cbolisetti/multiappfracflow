import os
import sys
import numpy as np
import matplotlib.pyplot as plt


plt.figure()
data = np.genfromtxt(r'matrix_app_out_fracture_app0.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0 / 24.0, data['TK_out'][1:] - 273, label='With heat transfer from matrix')
data = np.genfromtxt(r'fracture_only_out.csv', delimiter=',', names=True)
plt.plot(data['time'][1:] / 3600.0 / 24.0, data['TK_out'][1:] - 273, label='No heat transfer')
plt.grid()
plt.legend()
plt.title("Production temperature")
plt.xlim([0, 350])
plt.xlabel("time (days)")
plt.ylabel("T (degC)")
plt.savefig("../doc/content/media/3dFracture_production_T.png")
plt.show()
plt.close()

sys.exit(0)
