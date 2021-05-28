# Fracture flow using a MultiApp approach

PorousFlow can be used to simulate flow through fractured porous media.  The fundamental premise is:

- The fractures can be considered as lower dimensional entities within the higher-dimensional porous media.  This has two consequences.

  - Meshing is often simplified and computational speed increased.
  - The fractures do not provide a barrier to flow in their normal direction.  In fact, flows (of both mass and heat) in the normal direction do not even see the fracture as they move through the porous media.  This is certainly true if the fractures have very small width (as befits a lower-dimensional entity) and flow through it is substantially faster than the flow through the porous media.

A related page TODO_link describes how to simulate porous flow in fractured porous media, assuming that the fractures can be incorporated directly into the mesh as lower dimensional elements, for instance, as 2D "fracture" elements inside a 3D "matrix" mesh.  Unfortunately, realistic fracture networks have such complicated geometry that meshing them is difficult, while incorporating their mesh directly into a higher-dimensional mesh is almost impossible.  In this page, it is illustrated that MOOSE's MultiApp system may be employed to solve this problem: the "fracture" mesh is governed by one App, which is seperate from the "matrix" mesh that is governed by another App.

## The heat equation in fracture-matrix systems

### Uncoupled equations

The 3D heat equation is

\begin{equation}
\label{eqn.3D.heat.eqn}
0 = c\frac{\partial T}{\partial t} - \nabla(\lambda \nabla T) \ .
\end{equation}
Here:

- $T$ is the temperature, with SI units K;
- $c$ is the volumetric heat capacity of the medium (which is the product of specific heat capacity and density), with SI units J.m$^{-3}$.K$^{-1}$;
- $t$ is time and $\nabla$ is the vector of spatial derivatives;
- $\lambda$ is the thermal conductivity, with SI units J.s$^{-1}$.m$^{-1}$.K$^{-1}$.

This equation (multiplied by the test functions) gets integrated over the elemental volume in the finite-element scheme.  The fracture is actually a 3D object, but it is so thin that temperature (and $c$ and $\lambda$) do not vary appreciably over its thickness (aperture).  Therefore, the integral over the thickness may be done explicitly, and the fracture modelled as a 2D object, with heat equation reading

\begin{equation}
\label{eqn.2D.heat.eqn}
0 = ac\frac{\partial T}{\partial t} - a\tilde{\nabla}(\lambda \tilde{\nabla} T) \ ,
\end{equation}

where $a$ is the fracture thickness (aperture), and $\tilde{\nabla}$ are derivatives transverse to the fracture.  This equation is integrated (by MOOSE) over the fracture-element 2D area in the finite-element method.

!alert note
The preceeding equation implies all the Kernels for heat and hass flow in the fracture system must be multiplied by the fracture aperture $a$.  If tensorial quantities such as $\lambda$ or the permeability tensor are anisotropic, they need to be expressed in 3D space.

### Coupling

In order to specify the coupling between the fracture and matrix system precisely, let us introduce some notation.  Suppose the position of the fracture is given by a level-set function, $f = f(x, y, z)$ (where $x$, $y$ and $z$ are the Cartesian coordinates): that is, the fracture is at points where $f=0$, but not at points where $f\neq 0$.  For example, if the fracture occupies the $(x, y)$ plane, then $f=z$ would be a suitable function.  The one-dimensional Dirac delta function, $\delta(f)$, has SI units m$^{-1}$, and is zero everywhere except on the fracture.  When $\delta(f)$ is integrated over a direction normal to the fracture, the result is $\int_{\mathrm{normal}}\delta(f) = 1$.  When $\delta(f)$ is integrated over a volume containing the fracture, the result is $\int_{V}\delta(f) = A$, where $A$ is the area of the fracture in the volume.

The approach explored in this page uses two temperature variables, $T_{m}$ and $T_{f}$, which are the temperature in the matrix and fracture, respectively.  $T_{m}$ is defined throughout the entire matrix (including the embedded fracture), while $T_{f}$ is defined on the fracture only.  These are assumed to obey:

\begin{equation}
\begin{aligned}
\label{eqn.coupled.basic}
0 &=  c_{m}\dot{T}_{m} -  \nabla(\lambda_{m}\nabla T_{m}) +  h(T_{m} - T_{f})\delta(f) \ , \\
0 &= ac_{f}\dot{T}_{f} - a\tilde{\nabla}(\lambda_{f}\tilde{\nabla} T_{f}) + h(T_{f} - T_{m}) \ .
\end{aligned}
\end{equation}

In these equations, $h$ is the heat-transfer coefficient between the matrix and the fracture, with SI units J.m$^{-2}$.s$^{-1}$.K$^{-1}$. If $T_{f} > T_{m}$ then the heat-transfer term takes heat energy from the $T_{f}$ system and applies it to the $T_{m}$ system.  The heat-transfer coefficient plays a central role in this page and is discussed in detail below.

When the second (fracture) equation is integrated over a (2D) portion of the fracture of area $A$, the heat-energy transferred to the matrix is $Ah\langle T_{f} - T_{m} \rangle$, where the $\langle\rangle$ indicates the average over $A$.  This is equal to the heat-energy transferred according to the first equation, when it is integrated over a volume containing the same portion of fracture (remember $\int_{V}\delta(f) = A$).  Therefore, heat energy is conserved in this system.

### The heat-transfer coefficient

Heat-transfer coefficients have been used by engineers to accurately account for the complicated processes that occur at the interface between two materials.  If the two materials have temperature $T_{a}$ and $T_{b}$, respectively, and are connected by an area $A$ then the rate of heat transfer between them is $Ah(T_{a} - T_{b})$, with SI units J.s$^{-1}$.  Heat-transfer coefficients have been estimated for many different situations (see, for instance [Wikipedia](https://en.wikipedia.org/wiki/Heat_transfer_coefficient)).

To motivate a numerical value for $h$, assume that the fracture width is tiny compared with any relevant length scales in the matrix (such as the finite-element sizes).  While the temperature distribution in the immediate vicinity of the fracture will be governed by complicated processes, the point of $h$ is to hide that complexity.  Assume there is a "skin" around the fracture in which the complicated processes occur.  Denote the temperature just outside this skin by $T_{s}$, so the heat transfer through the skin is

\begin{equation}
Q_{s} = h_{\mathrm{s}}(T_{f} - T_{s}) \ ,
\end{equation}
where $T_{f}$ is the fracture temperature, $h_{\mathrm{s}}$ is the heat-transfer coefficient of the skin, with SI units J.m$^{-2}$.s$^{-1}$.K$^{-1}$, and $Q_{s}$ is the heat flux, with SI units J.s$^{-1}$.m$^{-2}$.

Just as the fracture may be considered two-dimensional (implemented by including its aperture in the fracture `Kernels` and using 2D finite elements), the size of the skin is also ignored.  Thereby, the matrix "sees" the fracture as an object of $T_{s}$ (*not* $T_{f}$) sitting within it.  Consider [skin_two_nodes], where an object of temperature $T_{s}$ sits between two finite element nodes, of temperature $T_{0}$ and $T_{1}$.

!media media/skin_two_nodes.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=skin_two_nodes
	caption=An object of temperature $T_{s}$ sits a distance $L_{0}$ from a finite-element node of temperature $T_{0}$, and a distance $L_{1}$ from a node of temperature $T_{1}$.

The flow from the fictitious "skin" object to each matrix finite-element nodes is governed by the heat equation [eqn.3D.heat.eqn]:

\begin{equation}
\begin{aligned}
Q_{0} &= \lambda \frac{T_{s} - T_{0}}{L_{0}} \ , \\
Q_{1} &= \lambda \frac{T_{s} - T_{1}}{L_{1}} \ .
\end{aligned}
\end{equation}

At steady state $Q_{s} = Q_{0} + Q_{1}$, which allows $T_{s}$ to be eliminated and yields the heat-loss from the fracture:
\begin{equation}
Q = \frac{h_{\mathrm{s}}\lambda (L_{0} + L_{1})}{h_{\mathrm{s}}L_{0}L_{1} + \lambda(L_{0} + L_{1})} \left( \frac{L_{1}}{L_{0} + L_{1}}(T_{f} - T_{0}) + \frac{L_{0}}{L_{0} + L_{1}}(T_{f} - T_{1}) \right) \ .
\end{equation}
Notice that the prefactors $L_{1}/(L_{0}+L_{1})$ are exactly what a linear-lagrange element in MOOSE would prescribe to a `DiracKernel` sitting at the fracture position.  Hence, the effective heat-transfer coefficient that would be used in a MOOSE model of this situation is
\begin{equation}
h = \frac{h_{\mathrm{s}}\lambda (L_{0} + L_{1})}{h_{\mathrm{s}}L_{0}L_{1} + \lambda(L_{0} + L_{1})} \ .
\end{equation}

This may be generalised to the 2D-3D situation, with an arbitrary-shaped element containing a portion of a fracture.  Obviously the heat flows to each node, and hence $h$, depend on the shape of the element.  However, following the approach of the Peaceman borehole TODO_LINK, the following rule-of-thumb is suggested for MOOSE simulations:

\begin{equation}
\label{eqn.suggested.h}
h = \frac{h_{\mathrm{s}}\lambda_{\mathrm{m}}^{nn} (L_{\mathrm{right}} + L_{\mathrm{left}})}{h_{\mathrm{s}}L_{\mathrm{right}}L_{\mathrm{left}} + \lambda_{\mathrm{m}}^{nn}(L_{\mathrm{right}} + L_{\mathrm{left}})} \ ,
\end{equation}

where $h$ depends on the matrix element surrounding the fracture:

- $\lambda_{\mathrm{m}}^{nn}$ is the component of the matrix thermal conductivity in the normal direction to the fracture;
- $L_{\mathrm{right}}$ is the average of the distances between the fracture and the nodes that lie on its right side;
- $L_{\mathrm{left}}$ is the average of the distances between the fracture and the nodes that lie on its left side (opposite the right side).

Finally, notice that if $a A \gg V$, where $A$ is now the fracture area modelled by one finite-element fracture node, and $V$ is the volume modelled by one finite-element matrix node, then the single fracture node can apply a lot of heat to the "small" matrix node, which will likely cause numerical instability if $\Delta t$ is too large, in the multiApp approach.

## Mass flow

TODO

## Heat advection

TODO

## A MultiApp primer using the diffusion equation

Before considering porous flow in a mixed-dimensional fracture-matrix system, consider the simpler situation involving two coupled diffusion equations in 1D.  Hence there is no "fracture" and "matrix" in this section: the labels "f" and "m" simply distinguish two different variables.  Assume physical parameters have been chosen appropriately so that

\begin{equation}
\begin{aligned}
0 &= \dot{T}_{f} - \nabla^{2}T_{f} + h(T_{f} - T_{m}) \ , \\
0 &= \dot{T}_{m} - \nabla^{2}T_{m} + h(T_{m} - T_{f}) \ .
\end{aligned}
\end{equation}

It is important that the same numerical value of $h$ is used in both formulae, otherwise heat energy would not be conserved in this system.

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

### A single variable (no heat transfer)

When $h=0$, the system becomes decoupled.  The solution is $T_{m} = 0$, and $T_{f}$ given by the fundamental solution.  This may be solved by MOOSE without any MultiApp system using the following input file

!listing diffusion_multiapp/single_var.i

The result depends on the spatial and temporal discretisation.  The temporal-discretisation dependence is shown below:

!media media/diffusion_single_var.png
	style=width:40%;margin:auto;padding-top:2.5%;
	id=fig0
	caption=??

### Two coupled variables (no MultiApp)

The system is coupled when $h\neq 0$.  A MultiApp approach is not strictly needed in this case, because there are no meshing problems: the domain is just the real line.  Hence, the system may be solved by MOOSE using the following input file

!listing diffusion_multiapp/two_vars.i

The result depends on the spatial and temporal discretisation.  The temporal-discretisation dependence is shown below.  Notice that the matrix has removed heat from the fracture, so the temperature is decreased compared with the $h=0$ case.

!media media/diffusion_two_vars.png
	style=width:40%;margin:auto;padding-top:2.5%;
	id=fig1
	caption=??

### A MultiApp approach

Using a MultiApp approach for the $h\neq 0$ case yields similar results.  The MultiApp methodology used throughout this page is as follows.

1. One timestep of the fracture physics is solved, holding the matrix variables fixed.
2. Transfers from the fracture system to the matrix system are performed.
3. One timestep of the matrix system is solved, holding the fracture variables fixed.
4. Transfers from the matrix system to the fracture system are performed.

Upon reflection, the reader will realise there are many potential ways of actually implementing this.  In the case at hand, the fracture physics ($T_{f}$) is governed by the "main" App, and the matrix physics ($T_{m}$) by the "sub" App.

#### Transfer of heat energy ("heat" MultiApp)

In order to conserve heat energy, the following approach may be used

1. One timestep of the fracture App is solved, holding the $T_{m}$ fixed, using [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel to implement the $h(T_{f} - T_{m})$ term, and recording the heat lost to the matrix, $h(T_{f} - T_{m})$ into an `AuxVariable`.
2. The heat lost to the matrix is transferred to the matrix App.
3. One timestep of the matrix system is solved, using a `CoupledForce` Kernel to inject the heat gained from the fracture at each node.
4. The resulting $T_{m}$ is transferred to the fracture App.

This is implemented using the following `AuxKernel` in the fracture App:

!listing diffusion_multiapp/fracture_app_heat.i block=AuxKernels

along with the following Transfers:

!listing diffusion_multiapp/fracture_app_heat.i block=Transfers

and the `Kernel` in the matrix App:

!listing diffusion_multiapp/matrix_app_heat.i start=[fromFrac] end=[]

A couple of subtleties are that the `CoupledForce` Kernel will smooth the nodal `heat_to_matrix` AuxVariable (since it uses quad-point values) and that a `save_in` cannot be employed in the `frac_app_heat.i` input file [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel (since that would include the nodal volume).  The results are:

!media media/fracture_app_heat.png
	style=width:40%;margin:auto;padding-top:2.5%;
	id=fig1
	caption=??

#### Transfer of temperature ("T" MultiApp)

An alternative approach is to transfer $T_{m}$ and $T_{f}$:

1. One timestep of the fracture App is solved, holding $T_{m}$ fixed, using [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel to implement the $h(T_{f} - T_{m})$ term.
2. The resulting $T_{f}$ is transferred to the matrix App.
3. One timestep of the matrix system is solved, holding $T_{f}$ fixed, using [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel to implement the $h(T_{f} - T_{m})$ term (using the same $h$ as the fracture App).
4. The resulting $T_{m}$ is transferred to the fracture App.

The disadvantage of this approach is that it doesn't conserve heat energy, however, the advantage is that the original differential equations are clearly evident.  Given that the error of using a MultiApp is $\Delta t$ irrespective of the type of Transfer implemented, the non-conservation of heat energy, which is also proportional to $\Delta t$, is probably not of critical importance.  This idea is implemented using the following `Kernel` in the fracture App:

!listing diffusion_multiapp/fracture_app.i start=[toMatrix] end=[]

along with the following Transfers:

!listing diffusion_multiapp/fracture_app.i block=Transfers

and the `Kernel` in the matrix App:

!listing diffusion_multiapp/fracture_app_heat.i start=[toMatrix] end=[]

The results are:

!media media/fracture_app.png
	style=width:40%;margin:auto;padding-top:2.5%;
	id=fig1
	caption=??

### Error in each approach

The L2 error in each approach (square-root of the sum of squares of differences between the MOOSE result and the analytical result) is plotted below.  The errors are very similar for each of the models explored in this section.  The magnitude of the error is largely unimportant: the scaling with time-step size is more crucial, and in this case it follows the [expected first-order result](https://web.mit.edu/10.001/Web/Course_Notes/Differential_Equations_Notes/node3.html).

\begin{equation}
\mathrm{L2 error} \propto \mathrm{d}t \ .
\end{equation}

!media media/diffusion_l2_error.png
	style=width:40%;margin:auto;padding-top:2.5%;
	id=fig1
	caption=??

### Final remarks on stability

One aspect that is not captured in this analysis is stability.  The non-MultiApp approaches ("No heat transfer" and "Coupled, no MultiApp") use fully-implicit time-stepping, so are unconditionally stable.  Conversely, the MultiApp approaches break this unconditional stability, which could be important in PorousFlow applications.  For instance, the matrix temperature is "frozen" while the fracture App is solving.  If a very large time-step is taken before the matrix App is allowed to evolve, this would lead to huge, unphysical heat losses to the matrix system.  The fracture temperature could reduce to the matrix temperature during fracture evolution, and then the matrix temperature could rise significantly during its evolution when it receives the large quantity of heat from the fracture.  This oscillation is unlikely to become unstable, but is clearly unphysical.



## The diffusion equation with a mixed-dimensional problem

The "fracture" and "matrix" in the previous section were identical spatial domains.  In this section, the diffusion equation is used to explore a mixed-dimensional problem, where the fracture is a 1D line "living inside" the 2D matrix.  In reality, the fracture has a certain aperture, $a$, but it is so small that it may be approximated by a 1D line in MOOSE and its kernels multiplied by $a$ (see [eqn.2D.heat.eqn] for example).

### Geometry and mesh

Two cases are explored: "conforming" and "nonconforming".   In the conforming case, all fracture nodes are also matrix nodes: the fracture elements are actually created from a sideset of the 2D matrix elements.  The conforming case is shown in [fracture_diffusion_conforming_geometry] and [fracture_diffusion_conforming_mesh]: the solution domain consists of the `fracture` subdomain (1D red line) and the `matrix` subdomain (in blue), which share nodes.  In the nonconforming case, no fracture nodes coincide with matrix nodes.  The nonconforming case is shown in [fracture_diffusion_nonconforming_mesh].

!media media/fracture_diffusion_conforming_geometry.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=fracture_diffusion_conforming_geometry
	caption=The geometry of the conforming case

!media media/fracture_diffusion_conforming_mesh.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=fracture_diffusion_conforming_mesh
	caption=The mesh in the conforming case

!media media/fracture_diffusion_nonconforming_mesh.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=fracture_diffusion_nonconforming_mesh
	caption=The mesh in the nonconforming case

The conforming case is explored using a non-MultiApp approach and a MultiApp approach, while the nonconforming case can only be explored using a MultiApp approach.

In all cases, the finite-element mesh dictates the spatial resolution of the numerical solution, and the analysis that follows ignores this by using the same spatial resolution in each model.  However, it is important to remember that in practice, the use of finite elements means the solution is never "exact".  For instance, using large matrix elements will probably lead to poor results.  Large elements also produce more noticable overshoots and undershoots in the solution, which may be observed in the current models if the matrix `ny` is too small.

### Physics

The two variables, $T_{f}$ and $T_{m}$, are called `frac_T` and `matrix_T` in the MOOSE input files.  Each obeys at diffusion equation, with heat transfer between the two variables, as written in [eqn.coupled.basic].

When using a MultiApp, the fracture appears as a set of Dirac sources in the matrix subdomain:

\begin{equation}
0 = c_{m}\dot{T}_{m} - \nabla(\lambda_{m}\nabla T_{m}) - H\delta(f) \ ,
\end{equation}

where

\begin{equation}
H = h(T_{f} - T_{m}) \ .
\end{equation}

In the MultiApp approach, $H$ is generated as an `AuxVariable` by the `fracture` App, so exists only in the `fracture` subdomain.  It is then passed to the `matrix` App, and applied as a `DiracKernel`.

The boundary conditions are "no flow", except for the very left-hand side of the fracture domain, where temperature is fixed at $T_{f} = 1$.  The initial conditions are $T_{m} = 0 = T_{f}$.

Each of the heat capacities are unity, $c_{m} = 1 = c_{f}$, the conductivity in the fracture is $\lambda_{f} = 1.0$, and is $\lambda_{m} = 10^{-3}$ in the matrix.  The fracure has aperture $a=10^{-2}$.

Assume that $h_{s} = 0.02$.  This is the heat-transfer coefficient to use in the conforming case, since the matrix nodes align exactly with the fracture.  [eqn.suggested.h] may be used for the nonconforming case.  In this situation $L_{\mathrm{left}} = 0.1 = L_{\mathrm{right}}$ and $\lambda_{m}^{nn} = 10^{-3}$, so $h = 0.01$.

Each simulation runs with `end_time = 100`.


### No MultiApp: the benchmark

In the conforming case, a MultiApp approach need not be taken, and the Kernels (given by [eqn.coupled.basic]) are:

!listing fracture_diffusion/no_multiapp.i block=Kernels

Evaluating the `fromFracture` heat transfer Kernel only on `block = fracture` implements the Dirac delta function $\delta(f)$ in [eqn.coupled.basic].  The matrix temperature is shown in [no_multiapp_matrix_T]

!media media/no_multiapp_matrix_T.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=no_multiapp_matrix_T
	caption=Benchmark matrix temperature at the end of simulation

The solution produced by MOOSE depends upon time-step size.  Some examples are shown in [frac_no_multiapp_frac_T].  Evidently, reducing the time-step below 10.0 does not impact the solution very much.  Hence, the solution using $\Delta t = 0.125$ is used as the *benchmark* for the remainder of this section.

!media media/frac_no_multiapp_frac_T.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=frac_no_multiapp_frac_T
	caption=Impact of time-step size on the fracture temperature at the end of the simulation

### A MultiApp approach for the conforming case

In this case, the matrix App is the main App, and the fracture App is the subApp.  The fracture input file has the following features.

- An `AuxVariable` called `transferred_matrix_T` that is $T_{m}$ interpolated to the fracture mesh.

- An `AuxVariable` called `joules_per_s` that is the heat rate coming from each node.  Mathematically this is $h(T_{f} - T_{m})L$, where $L$ is the "volume" modelled by the fracture node.  This is populated by the `save_in` feature:

!listing fracture_diffusion/fracture_app_dirac.i block=Kernels

- A `NodalValueSampler` `VectorPostprocessor` that captures all the `joules_per_s` values at each fracture node

!listing fracture_diffusion/fracture_app_dirac.i block=VectorPostprocessors

The matrix input file has the following features

- Transfers that send $T_{m}$ to the fracture App, and receive the `joules_per_s` from the fracture App

!listing fracture_diffusion/matrix_app_dirac.i block=Transfers

- This latter `Transfer` writes its information into a `VectorPostprocessor` in the matrix App.  That is then converted to a Dirac source by a `VectorPostprocessorPointSource` `DiracKernel`:

!listing fracture_diffusion/matrix_app_dirac.i block=DiracKernels

### A MultiApp approach for the nonconforming case

This is identical to the conforming case except:

- the matrix mesh is nonconforming, as shown above
- the heat transfer coefficient is different, as described above

### Results

The L2 error of the fracture temperature in each approach (square-root of the sum of squares of differences between the $T_{f}$ and the benchmark result) is plotted in [frac_l2_error].  As expected, the error is proportional to $\Delta t$.  The error when using the MultiApp approaches is larger than the non-MultiApp approach, because $T_{f}$ is fixed when $T_{m}$ is being solved for, and vice versa.  The conforming and nonconforming cases produce similar results for larger time-steps, but as the time-step size reduces the results are slightly different, just because of the small differences in the effective finite-element discretisation.

!media media/frac_l2_error.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=frac_l2_error
	caption=L2 error of each approach to modelling the mixed-dimensional diffusion equation
