import string
import plotly.plotly as py
from plotly.graph_objs import *
py.sign_in('heifetz97', '1z2atec83q')
traces = []
with open("doit.txt") as f:
	content = f.readlines()
	for line in content:
		coordinates = line.split()
		if len(coordinates) < 10 or coordinates[30] == "-1":
			continue
		x0 = []
		y0 = []
		z0 = []
		for i in range(1,10):
			x0.append(float(coordinates[i*3]))
			y0.append(float(coordinates[i*3+1]))
			z0.append(float(coordinates[i*3+2]))
		traces.append(Scatter(
			y = x0,
			x = range(0,9)
		))

data = Data(traces)
py.plot(data)
