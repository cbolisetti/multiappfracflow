# Fracture flow using a MultiApp approach

A related page [TODO: link] describes how to simulate porous flow in fractured porous media, assuming that the fractures can be incorporated into the mesh as lower dimensional elements, for instance, as 2D "fracture" elements inside a 3D "matrix" mesh.  Unfortunately, realistic fracture networks have such complicated geometry that meshing them is difficult, while incorporating their mesh into a higher-dimensional mesh is almost impossible.  In this page, it is illustrated that MOOSE's MultiApp system may be employed to solve this problem: the "fracture" mesh is governed by one App, which is seperate from the "matrix" mesh that is governed by another App.

## A MultiApp primer using the diffusion equation

Before considering porous flow in a mixed-dimensional fracture-matrix system, consider the simpler situation involving two coupled diffusion equations in 1D.  Introduce the "temperature" variables, $T_{f}$ and $T_{m}$, which obey

\begin{equation}
\begin{aligned}
0 &= \dot{T}_{f} - \nabla^{2}T_{f} + h(T_{f} - T_{m}) \ , \\
0 &= \dot{T}_{m} - \nabla^{2}T_{m} + h(T_{m} - T_{f}) \ .
\end{aligned}
\end{equation}

In each line, the first two terms are the diffusion equation, while the third is heat transfer between the two systems.  The heat transfer coefficient is denoted by $h$.  In applications, the numerical value of $h$ is usually determined by experiment, or by consulting established empirical relationships, such those found on [wikipedia](https://en.wikipedia.org/wiki/Heat_transfer_coefficient).  If $T_{f} > T_{m}$ then the heat-transfer term takes heat energy from the $T_{f}$ system and applies it to the $T_{m}$ system.  It is important that the same numerical value of $h$ is used in both formulae, otherwise heat energy would not be conserved.

In this section, assume the boundary conditions are
\begin{equation}
T_{f}(x = \pm\infty) = 0 = T_{m}(x = \pm\infty)
\end{equation}
and the initial conditions are
\begin{equation}
\begin{aligned}
T_{f}(t = 0) &= \delta(x) \ , \\
T_{m}(t = 0) &= 0 \ ,
\end{aligned}
\end{equation}
where $\delta$ is the Dirac delta functions.  These conditions make the analytic solution easy to derive.

Physically, this system represents the situation in which the $T_{f}$ system is initially provided with a unit of heat energy at $x=0$, and that heat energy is allowed to disperse under diffusion, and transfer to the $T_{m}$ system, which also disperses it.  To derive the solution, the sum of the two governing equations yields the standard diffusion equation (which may be solved using the [fundamental solution](https://en.wikipedia.org/wiki/Heat_equation)), while the difference yields the diffusion equation augmented with a decay term.  The final result is:
\begin{equation}
\begin{aligned}
T_{f}(t, x) &= \frac{1 + e^{-2ht}}{4\sqrt{\pi t}}\exp\left(-\frac{x^{2}}{4t}\right) \ , \\
T_{m}(t, x) &= \frac{1 - e^{-2ht}}{4\sqrt{\pi t}}\exp\left(-\frac{x^{2}}{4t}\right) \ , \\
\end{aligned}
\end{equation}

### A single variable

When $h=0$, the system becomes decoupled.  The solution is $T_{m} = 0$, and $T_{f}$ given by the fundamental solution.  This may be solved by MOOSE without any MultiApp system using the following input file

TODO: listing single_var.i

The result depends on the spatial and temporal discretisation.  The temporal-discretisation dependence is shown below:

![Image](diffusion_multiapp/single_var.png)

### Two coupled variables

The system is coupled when $h\neq 0$..  A MultiApp approach is not strictly needed in this case, because there are no meshing problems: the domain is just the real line.  Hence, the system may be solved by MOOSE using the following input file

TODO: listing two_vars.i

The result depends on the spatial and temporal discretisation.  The temporal-discretisation dependence is shown below.  Notice that the matrix has removed heat from the fracture, so the temperature is decreased compared with the $h=0$ case.

![Image](diffusion_multiapp/two_vars.png)

### A MultiApp approach

Using a MultiApp approach for the $h\neq 0$ case yields similar results.  The MultiApp methodology used throughout this page is as follows.

1. One timestep of the fracture physics is solved, holding the matrix variables fixed.
2. Transfers from the fracture system to the matrix system are performed.
3. One timestep of the matrix system is solved, holding the fracture variables fixed.
4. Transfers from the matrix system to the fracture system are performed.

Upon reflection, the reader will realise there are many potential ways of actually implementing this.  In the case at hand, the fracture physics ($T_{f}$) is governed by the "main" App, and the matrix physics ($T_{m}$) by the "sub" App.

#### Transfer of heat energy

In order to conserve heat energy, the following approach may be used

1. One timestep of the fracture App is solved, holding the $T_{m}$ fixed, using [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel to implement the $h(T_{f} - T_{m})$ term, and recording the heat lost to the matrix, $h(T_{f} - T_{m})$ into an `AuxVariable`.
2. The heat lost to the matrix is transferred to the matrix App.
3. One timestep of the matrix system is solved, using a `CoupledForce` Kernel to inject the heat gained from the fracture at each node.
4. The resulting $T_{m}$ is transferred to the fracture App.

This is implemented using the following `AuxKernel` in the fracture App:

TODO listing fracture_app_heat.i block=AuxKernels

along with the following Transfers:

TODO listing fracture_app_heat.i block=Transfers

and the `Kernel` in the matrix App:

TODO listing matrix_app_heat.i start=[fromFrac] end=[]

A couple of subtleties are that the `CoupledForce` Kernel will smooth the nodal `heat_to_matrix` AuxVariable (since it uses quad-point values) and that a `save_in` cannot be employed in the `frac_app_heat.i` input file [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel (since that would include the nodal volume).  The results are:

![Image](diffusion_multiapp/fracture_app_heat.png)

#### Transfer of temperature

An alternative approach is to transfer $T_{m}$ and $T_{f}$:

1. One timestep of the fracture App is solved, holding $T_{m}$ fixed, using [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel to implement the $h(T_{f} - T_{m})$ term.
2. The resulting $T_{f}$ is transferred to the matrix App.
3. One timestep of the matrix system is solved, holding $T_{f}$ fixed, using [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel to implement the $h(T_{f} - T_{m})$ term (using the same $h$ as the fracture App).
4. The resulting $T_{m}$ is transferred to the fracture App.

The disadvantage of this approach is that it doesn't conserve heat energy, however, the advantage is that the original differential equations are clearly evident.  Given that the error of using a MultiApp is $\Delta t$ irrespective of the type of Transfer implemented, the non-conservation of heat energy, which is also proportional to $\Delta t$, is probably not of critical importance.  This idea is implemented using the following `Kernel` in the fracture App:

TODO listing fracture_app.i start=[toMatrix] end=[]

along with the following Transfers:

TODO listing fracture_app.i block=Transfers

and the `Kernel` in the matrix App:

TODO listing fracture_app_heat.i start=[toMatrix] end=[]

The results are:

![Image](diffusion_multiapp/fracture_app.png)

### Error in each approach

TODO


