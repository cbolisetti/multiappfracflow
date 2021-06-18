import os
import sys
import numpy as np
import matplotlib.pyplot as plt

labels = {'0': '9.2m', '1': '4.6m', '2': '2.3m', '3': '1.15m'}
colours = {'0': 'g', '1': 'k', '2': 'b', '3': 'r'}

production_starts = {} # index into data at which production starts (P_out >= 10.6)
for i in ['0', '1', '2', '3']:
    data = np.genfromtxt(r'fracture_only_aperture_changing_out_' + i + '.csv', delimiter=',', names=True)
    for ind in range(1, len(data)):
        if data['P_out'][ind] >= 10.6:
            production_starts[i] = ind
            break

plt.figure()
for i in ['0', '1', '2', '3']:
    data = np.genfromtxt(r'fracture_only_aperture_changing_out_' + i + '.csv', delimiter=',', names=True)
    plt.plot(data['time'][1:production_starts[i]+1] / 3600.0, data['TK_out'][1:production_starts[i]+1] - 273, colours[i] + ":")
    plt.plot(data['time'][production_starts[i]] / 3600.0, data['TK_out'][production_starts[i]] - 273, colours[i] + "o")
    plt.plot(data['time'][production_starts[i]:] / 3600.0, data['TK_out'][production_starts[i]:] - 273, colours[i], label=labels[i])
plt.grid()
plt.legend()
plt.title("Production-point temperature: no heat transfer, various mesh sizes")
plt.xlim([0, 4])
plt.xlabel("time (hours)")
plt.ylabel("T (degC)")
plt.savefig("../doc/content/media/fracture_only_aperture_changing_T_out.png")
plt.show()
plt.close()

plt.figure()
for i in ['0', '1', '2', '3']:
    data = np.genfromtxt(r'fracture_only_aperture_changing_out_' + i + '.csv', delimiter=',', names=True)
    plt.plot(data['time'][1:production_starts[i]+1] / 3600.0, data['P_out'][1:production_starts[i]+1], colours[i] + ":")
    plt.plot(data['time'][production_starts[i]] / 3600.0, data['P_out'][production_starts[i]], colours[i] + "o")
    plt.plot(data['time'][production_starts[i]:] / 3600.0, data['P_out'][production_starts[i]:], colours[i], label=labels[i])
plt.grid()
plt.legend()
plt.title("Production-point porepressure: no heat transfer, various mesh sizes")
plt.xlim([0, 4])
plt.xlabel("time (hours)")
plt.ylabel("P (MPa)")
plt.savefig("../doc/content/media/fracture_only_aperture_changing_P_out.png")
plt.show()
plt.close()
sys.exit(0)
