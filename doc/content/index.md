# Fracture flow using a MultiApp approach

PorousFlow can be used to simulate flow through fractured porous media.  The fundamental premise is *the fractures can be considered as lower dimensional entities within the higher-dimensional porous media*.  This has two consequences.

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
\label{heat.transfer.skin}
Q_{s} = h_{\mathrm{s}}(T_{f} - T_{s}) \ ,
\end{equation}
where $T_{f}$ is the fracture temperature, $h_{\mathrm{s}}$ is the heat-transfer coefficient of the skin, with SI units J.m$^{-2}$.s$^{-1}$.K$^{-1}$, and $Q_{s}$ is the heat flux, with SI units J.s$^{-1}$.m$^{-2}$.  A method for estimating $h_{s}$ is provided below.

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

This may be generalised to the 2D-3D situation.  While [skin_two_nodes] is only a 1D picture, flow from the fracture to the matrix only occurs in the normal direction, so it also represents the 2D-3D situation.  With an arbitrary-shaped element containing a portion of a fracture, the heat flows to each node, and hence $h$, depend on the shape of the element.  However, following the approach of the Peaceman borehole TODO_LINK, the following rule-of-thumb is suggested for MOOSE simulations:

\begin{equation}
\label{eqn.suggested.h}
h = \frac{h_{\mathrm{s}}\lambda_{\mathrm{m}}^{nn} (L_{\mathrm{right}} + L_{\mathrm{left}})}{h_{\mathrm{s}}L_{\mathrm{right}}L_{\mathrm{left}} + \lambda_{\mathrm{m}}^{nn}(L_{\mathrm{right}} + L_{\mathrm{left}})} \ ,
\end{equation}

where $h$ depends on the matrix element surrounding the fracture:

- $\lambda_{\mathrm{m}}^{nn}$ is the component of the matrix thermal conductivity in the normal direction to the fracture;
- $L_{\mathrm{right}}$ is the average of the distances between the fracture and the nodes that lie on its right side;
- $L_{\mathrm{left}}$ is the average of the distances between the fracture and the nodes that lie on its left side (opposite the right side).

The result [eqn.suggested.h] depends on $L_{\mathrm{left}}$ and $L_{\mathrm{right}}$.  In most settings, it is appropriate to assume that $L_{\mathrm{left}} = L_{\mathrm{right}} = L$ since this corresponds to making a shift of the fracture position by an amount less than the finite-element size.  Since the accuracy of the finite-element scheme is governed by the element size, such small shifts introduce errors that are smaller than the finite-element error.  This means [eqn.suggested_h] reads

\begin{equation}
\label{eqn.suggested.h.L}
h = \frac{2h_{\mathrm{s}}\lambda_{\mathrm{m}}^{nn}L}{h_{\mathrm{s}}L^{2} + 2\lambda_{\mathrm{m}}^{nn}L} \ .
\end{equation}

The heat-transfer through the skin is likely to exceed heat conduction through the skin, since the heat transfer involves faster processes such as convection.  Therefore, $h_{\mathrm{s}} = c\lambda_{\mathrm{m}}/ s$, where $s$ is the skin size and $c>1$.  This yields

\begin{equation}
\label{eqn.simple.L}
h = \frac{2\lambda_{\mathrm{m}}^{nn}}{L + 2s/c} \rightarrow \frac{2\lambda_{\mathrm{m}}^{nn}}{L} \ ,
\end{equation}

where the final limit is for $s \ll L$, which is likely to be reasonably correct in most simulations.





Finally, notice that if $a A \gg V$, where $A$ is now the fracture area modelled by one finite-element fracture node, and $V$ is the volume modelled by one finite-element matrix node, then the single fracture node can apply a lot of heat to the "small" matrix node, which will likely cause numerical instability if $\Delta t$ is too large, in the multiApp approach.

## Mass flow

A "mass-transfer coefficient" $h^{\mathrm{mass}}$ may be used to model fluid mass transfer between the fracture and matrix.  The equations for all fluid phases are structurally identical, but just have different numerical values for viscosity, relative permeability, etc, so in this section consider just one phase.  Define the potential $\Phi$ (with SI units Pa) by

\begin{equation}
\Phi = P + \rho g z
\end{equation}

Here

- $P$ is the porepressure (SI units Pa);
- $\rho$ is the fluid density (SI units kg.m$^{-3}$);
- $g$ is the gravitational acceleration (SI units m.s$^{-2}$ or Pa.m$^{2}$.kg$^{-1}$);
- $z$ is the coordinate direction pointing "upwards" (i.e. in the opposite direction to gravity) with SI units m.  If gravity acted in a different direction then $z$ would be replaced by another coordinate direction.

In the Darcy setting modelled by PorousFlow, the equivalent of [heat.transfer.skin] is

\begin{equation}
Q_{\mathrm{s}}^{\mathrm{mass}} = h_{\mathrm{s}}^{\mathrm{mass}}(\Phi_{f} - \Phi_{s}) \ .
\end{equation}

Here

- $Q_{\mathrm{s}}^{\mathrm{mass}}$ is the mass flux through the skin, with SI units kg.s$^{-1}$.m$^{-2}$.
- $h_{\mathrm{s}}^{\mathrm{mass}}$ is the mass-transfer coefficient of the skin, with SI units kg.s$^{-1}$.m$^{-2}$.Pa$^{-1}$.

The heat-flow arguments presented above may now be followed using $\Phi$ instead of $T$, and $\rho k k_{\mathrm{rel}} / \mu$ in place of $\lambda$, to yield a suggestion for the mass-transfer coefficient in the 2D-3D situation:

\begin{equation}
\label{eqn.suggested.hmass}
h^{\mathrm{mass}} = \frac{h_{\mathrm{s}}^{\mathrm{mass}}\frac{\rho k_{\mathrm{m}}^{nn}k_{\mathrm{rel}}}{\mu} (L_{\mathrm{right}} + L_{\mathrm{left}})}{h_{\mathrm{s}}^{\mathrm{mass}}L_{\mathrm{right}}L_{\mathrm{left}} + \frac{\rho k_{\mathrm{m}}^{nn} k_{\mathrm{rel}}}{\mu}(L_{\mathrm{right}} + L_{\mathrm{left}})} \ ,
\end{equation}

where $h^{\mathrm{mass}}$ depends on the matrix element surrounding the fracture in the following way

- $\rho$ is the density of the fluid phase (SI units kg.m$^{-3}$).
- $k_{\mathrm{m}}^{nn}$ is the component of the matrix permeability tensor in the normal direction to the fracture (SI units m$^{2}$).
- $k_{\mathrm{rel}}$ is the relative permeability of the fluid phase (dimensionless).
- $\mu$ is the dynamic viscosity of the fluid phase (SI units Pa.s).
- $L_{\mathrm{right}}$ is the average of the distances between the fracture and the nodes that lie on its right side.
- $L_{\mathrm{left}}$ is the average of the distances between the fracture and the nodes that lie on its left side (opposite the right side).

This appears in the mass-transfer: $Q^{\mathrm{mass}} = h^{\mathrm{mass}}(\Phi_{f} - \Phi_{m})$, where $\Phi = P + \rho g z$.

The arguments that led to [eqn.suggested.h.L] and [eqn.simple.L] lead in this case to

\begin{equation}
\label{eqn.simple.hmass}
h^{\mathrm{mass}} = \frac{2\rho k_{\mathrm{m}}^{nn}k_{\mathrm{rel}}}{\mu L} \ .
\end{equation}

There are numerical subtleties in these expressions that may not impact many simulations, but modellers should be aware of the following.

- $\Phi$ seen by the fracture is the matrix nodal values interpolated to the fracture node.  There are clearly many ways of doing this interpolation, eg, $\rho z$ could be interpolated from the fracture nodes, or $\rho z$ could be evaluated at the fracture node given its position, porepressure and temperature.
- Similar remarks hold for $\rho k_{\mathrm{m}}^{nn}k_{\mathrm{rel}}/\mu$.
- Stability of the numerics will be improved by evaluating $\rho k_{\mathrm{m}}^{nn}k_{\mathrm{rel}}/\mu$ at the upwind position.  That is, if fluid is flowing from the fracture to the matrix, this term would best be evaluated using $(P, T)$ of the skin, while for the reverse flow the evaluation should be done using the nodal matrix values.  However, it is usually more convenient to fix the evaluation to use the elemental-averaged values of the matrix (using a constant, monomial `AuxVariable` for the matrix).


## Heat advection

Heat advection follows the same principal as mass transfer.  The heat transfer by advection through the skin:

\begin{equation}
Q_{\mathrm{s}} = eh_{\mathrm{s}}^{\mathrm{mass}}(\Phi_{f} - \Phi_{s}) \ .
\end{equation}

where $e$ is the fluid enthalpy, and the other terms are given above.  In the finite-element setting $Q = eh^{\mathrm{mass}}(\Phi_{f} - \Phi_{m})$, and

\begin{equation}
\label{eqn.suggested.ehmass}
eh^{\mathrm{mass}} = \frac{eh_{\mathrm{s}}^{\mathrm{mass}}\frac{e\rho k_{\mathrm{m}}^{nn}k_{\mathrm{rel}}}{\mu} (L_{\mathrm{right}} + L_{\mathrm{left}})}{eh_{\mathrm{s}}^{\mathrm{mass}}L_{\mathrm{right}}L_{\mathrm{left}} + \frac{e\rho k_{\mathrm{m}}^{nn} k_{\mathrm{rel}}}{\mu}(L_{\mathrm{right}} + L_{\mathrm{left}})} \ .
\end{equation}

The arguments that led to [eqn.suggested.h.L] and [eqn.simple.L] lead in this case to

\begin{equation}
\label{eqn.simple.ehmass}
eh^{\mathrm{mass}} = \frac{2e\rho k_{\mathrm{m}}^{nn}k_{\mathrm{rel}}}{\mu L} \ .
\end{equation}


As in the mass-transfer case, the numerics will be impacted by where these terms are evaluated.

## Combinations of transfer

In many simulations, heat transfer by both conduction and convection will be active, in addition to mass transfer.  The transfers are simply added together.  For instance

\begin{equation}
Q^{\mathrm{heat}} = h(T_{f} - T_{m}) + eh^{\mathrm{mass}}(\Phi_{f} - \Phi_{m}) \ .
\end{equation}




## A MultiApp primer using the diffusion equation

Before considering porous flow in a mixed-dimensional fracture-matrix system, consider the simpler situation involving two coupled diffusion equations in 1D.  Hence there is *no* "fracture" and "matrix" in this section: the labels "f" and "m" simply distinguish two different variables.  Assume physical parameters have been chosen appropriately so that

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
\label{eqn.analytical.pulse}
T_{f}(t, x) &= \frac{1 + e^{-2ht}}{4\sqrt{\pi t}}\exp\left(-\frac{x^{2}}{4t}\right) \ , \\
T_{m}(t, x) &= \frac{1 - e^{-2ht}}{4\sqrt{\pi t}}\exp\left(-\frac{x^{2}}{4t}\right) \ .
\end{aligned}
\end{equation}

### A single variable (no heat transfer)

When $h=0$, the system becomes decoupled.  The solution is $T_{m} = 0$, and $T_{f}$ given by the fundamental solution.  This may be solved by MOOSE without any MultiApp system using the following input file

!listing diffusion_multiapp/single_var.i

The result depends on the spatial and temporal discretisation.  The temporal-discretisation dependence is shown in [diffusion_single_var]

!media media/diffusion_single_var.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=diffusion_single_var
	caption=Decoupled case: comparison of the analytical solution with the MOOSE results as computed using no MultiApp

### Two coupled variables (no MultiApp)

The system is coupled when $h\neq 0$.  A MultiApp approach is not strictly needed in this case, because there are no meshing problems: the domain is just the real line.  Hence, the system may be solved by MOOSE using the following input file

!listing diffusion_multiapp/two_vars.i

The result depends on the spatial and temporal discretisation.  The temporal-discretisation dependence is shown in [diffusion_two_vars].  Notice that the matrix has removed heat from the fracture, so the temperature is decreased compared with the $h=0$ case.

!media media/diffusion_two_vars.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=diffusion_two_vars
	caption=Coupled case: comparison of the analytical solution with the MOOSE results as computed using no MultiApp

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

A couple of subtleties are that the `CoupledForce` Kernel will smooth the nodal `heat_to_matrix` AuxVariable (since it uses quad-point values) and that a `save_in` cannot be employed in the `frac_app_heat.i` input file [PorousFlowHeatMassTransfer](PorousFlowHeatMassTransfer.md) Kernel (since that would include the nodal volume).  The results are shown in [fracture_app_heat].

!media media/fracture_app_heat.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=fracture_app_heat
	caption=Coupled case: comparison of the analytical solution with the MOOSE results as computed using a "heat" MultiApp

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

The results are shown in [fracture_app].

!media media/fracture_app.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=fracture_app
	caption=Coupled case: comparison of the analytical solution with the MOOSE results as computed using a "T" MultiApp

### Error in each approach

The L2 error in each approach (square-root of the sum of squares of differences between the MOOSE result and the analytical result) is plotted in [diffusion_l2_error].  The errors are very similar for each of the models explored in this section.  The magnitude of the error is largely unimportant: the scaling with time-step size is more crucial, and in this case it follows the [expected first-order result](https://web.mit.edu/10.001/Web/Course_Notes/Differential_Equations_Notes/node3.html).

\begin{equation}
\mathrm{L2 error} \propto \mathrm{d}t \ .
\end{equation}

!media media/diffusion_l2_error.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=diffusion_l2_error
	caption=L2 error of each approach as a function of time-step size

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
	caption=The matrix mesh in the conforming case

!media media/fracture_diffusion_nonconforming_mesh.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=fracture_diffusion_nonconforming_mesh
	caption=The matrix mesh in the nonconforming case, where the red line is the fracture

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

## Porous flow in a single matrix system

The previous section may be extended to the Porous Flow setting.  As above, consider a single 1D planar fracture within a 2D mesh.  Fluid flows along the fracture according to Darcy's equation, so may be modelled using [PorousFlowFullySaturated](PorousFlowFullySaturated.md)

!listing single_fracture_heat_transfer/fracture_app.i block=PorousFlowFullySaturated

[Kuzmin-Turek](kt.md) stabilization is used to minimise numerical diffusion.  The following assumptions are used.

- The fracture aperture is $10^{-2}\,$m, and its porosity is $1$.  Therefore, the porosity required by PorousFlow is $a\phi = 10^{-2}$.
- The permeability is given by the $a^{2}/12$ formula, modified by a roughness coefficient, $r$, so the permeability required by PorousFlow is $a^{3}*r/12 = 10^{-8}$.
- The fracture is basically filled with water, so the internal energy of any rock material within it may be ignored.
- The thermal conductivity in the fracture is dominated by the water (which has thermal conductivity 0.6$\,$W.m$^{-1}$.K$^{-1}$), so the thermal conductivity required by PorousFlow is $0.6\times 10^{-2}$.

Hence, the Materials are

!listing single_fracture_heat_transfer/fracture_app.i block=Materials

The heat transfer between the fracture and matrix is encoded in the usual way.  The heat transfer coefficient is chosen to be 100, just so that an appreciable amount of heat energy is transferred, not because this is a realistic transfer coefficient for this case:

!listing single_fracture_heat_transfer/fracture_app.i block=Kernels

The boundary conditions correspond to injection of 100$^{\circ}$C water at a rate of 10$\,$kg.s$^{-1}$ at the left side of the model, and withdrawal of water at the same rate (and whatever temperature it is extracted at) at the right side:

!listing single_fracture_heat_transfer/fracture_app.i start=left_injection end=[]

!listing single_fracture_heat_transfer/fracture_app.i block=BCs

The physics in the matrix is assumed to be the simple heat equation.  Note that this has no stabilization, so there are overshoots and undershoots in the solution.

!listing single_fracture_heat_transfer/matrix_app.i block=Kernels

After 100$\,$s of simulation, the matrix temperature is shown in [single_fracture_heat_transfer_final_matrix_T].  The evolution of the temperatures is shown in [single_fracture_heat_transfer_T].  Without any heat transfer, the fracture heats up to 100$^{\circ}$C, but when the fracture transfers heat energy to the matrix, the temperature evolution is retarded.

!media media/single_fracture_heat_transfer_final_matrix_T.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=single_fracture_heat_transfer_final_matrix_T
	caption=Heat conduction into the matrix (the matrix mesh is shown)

!media media/single_fracture_heat_transfer_T.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=single_fracture_heat_transfer_T
	caption=Temperature along the fracture, with heat transfer to the matrix and without heat transfer to the matrix.  Fluid at 100degC is injected into the fracture at its left end, and fluid is withdrawn at the right end.  With heat transfer, the matrix heats up a little.


## Porous flow through a 3D fracture network

A sample PorousFlow simulation through the small 3D fracture network shown in [orbit_fracture] is presented in this section.  The above methodology used above is extended to the 3D case including fractures of various alignments.  It is assumed that

- the physics is fully-saturated, non-isothermal porous flow with heat conduction and convection;
- the porepressure is initially around 10$\,$MPa (hydrostatic) corresponding to a depth of around 1$\,$km;
- the temperature is 200$^{\circ}$C;
- injection is into the fracture network only, through one point, at a rate of $10^{-2}\,$kg.s$^{-1}$ and temperature of 100$^{\circ}$C;
- production is from the fracture network only, through one point, at a rate of approximately $10^{-2}\,$kg.s$^{-1}$ (it cannot be exactly $10^{-2}\,$kg.s$^{-1}$ initially because this causes large porepressure reductions due to thermal contraction of water);
- only heat energy is transferred between the fracture and the matrix: the matrix heats the cool water injected into the fracture network.


!media media/orbit_fracture.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=orbit_fracture
	caption=Fracture network.  The injection point is coloured green.  The production point is red.

Before presenting the input files in detail, the simulation's coupling involves the following steps.

1. Each fracture element must be prescribed with a normal direction, using a [PorousFlowElementNormal](PorousFlowElementNormal.md) AuxKernel.
2. The fracture-normal information must be sent from each fracture element to the nearest matrix element, which is implemented using a [MultiAppNearestNodeTransfer](MultiAppNearestNodeTransfer.md) Transfer.
3. Each matrix element must be prescribed with a normal length, $L$, using a [PorousFlowElementLength](PorousFlowElementLength.md) AuxKernel and the fracture-normal direction sent to it.
4. Each matrix element must be prescribed with a normal thermal conductivity, $\lambda_{\mathrm{m}}^{nn}$, using the fracture-normal direction sent to it.
5. Each fracture element must retrieve $L$ and $\lambda_{\mathrm{m}}^{nn}$ from its nearest matrix element.
6. Each fracture element must calculate $h$ using [eqn.suggested.h.L] or [eqn.simple.L].

These steps could be performed during the simulation initialization, however, it is more convenient to perform them at each time-step.  When these steps have been accomplished, each time-step involves the following (which is also used in the sections above).

1. The matrix temperature, `matrix_T`, is sent to the fracture nodes using a [MultiAppInterpolationTransfer](MultiAppInterpolationTransfer.md) Transfer.
2. The fracture physics is solved.
3. The heat flowing between the fracture and matrix is transferred using a [MultiAppReporterTransfer](MultiAppReporterTransfer.md) Transfer.
4. The matrix physics is solved.


### The fracture input file

The [PorousFlowFullySaturated](PorousFlowFullySaturated.md) physics is used to model this situation.  [Kuzmin-Turek](kt.md) stabilization is used, and porepressure is measured in MPa.

!listing 3dFracture/fracture_app.i block=PorousFlowFullySaturated

The coupling with the matrix is by the [PorousFlowHeatMassTransfer](PorousflowHeatMassTransfer.md) Kernel

!listing 3dFracture/fracture_app.i block=Kernels

The model assumes all fractures have aperture $a = 0.1\,$mm, although prescribing a block-dependent $a$ is obviously easy in MOOSE (it just makes the input file a lot longer).  All fractures are assumed to have porosity 1.0 and permeability $10^{-11}\,$m$^{2}$.  Because there is no "matrix" (rock material) inside the fractures, the matrix specific heat capacity is zero (in the matrix input file the matrix specific heat capacity is non zero) and the thermal conductivity is due to water, $0.6\,$W.m$^{-1}$.K$^{-1}$.  Remembering that all fracture properties much be multiplied by $a$, as in [eqn.2D.heat.eqn], the `Materials` block reads:

!listing 3dFracture/fracture_app.i block=Materials

This simulation involves considerable changes of water pressure and temperature, so a high-precision equation of state is used:

!listing 3dFracture/fracture_app.i block=Modules

PorousFlow contains many different [sources and sinks](sinks.md) that could be used to implement the injection and production.  In this case, temperature is fixed at the injection node using a [DirichletBC](DirichletBC.md) and a constant rate of fluid is injected using a [PorousFlowPointSourceFromPostprocessor](PorousFlowPointSourceFromPostprocessor.md) Dirac Kernel.  Two [PorousFlowPolyLineSink](PorousFlowPolyLineSink.md) Dirac Kernels extract mass and heat (the latter with `use_enthalpy = true`) from the production node.  These are designed to keep the porepressure around 10$\,$MPa, ramping up the production rate if the porepressure exceeds this, or reducing it if the porepressure is less than 10$\,$MPa.  The relevant blocks are:

!listing 3dFracture/fracture_app.i block=BCs

!listing 3dFracture/fracture_app.i block=DiracKernels

The above is run-of-the-mill PorousFlow material.  The coupling with the matrix is the most important to the current page.  The steps in the coupling were outlined above.  The `AuxKernels` needed are:

!listing 3dFracture/fracture_app.i block=AuxKernels

Notice the expression in the `heat_transfer_coefficient` function.  In the case at hand, if [eqn.simple.L] is used then the matrix very rapidly heats up the water in the fracture, leading to rather boring (though realistic) results.  Hence, various values for $h_{s}$ have been provided.

### The matrix input file

Most of the matrix input file is standard by now.  The physics is governed by [PorousFlowFullySaturated](PorousFlowFullySaturated.md) along with the familiar [VectorPostprocessorPointSource](VectorPostprocessorPointSource.md):

!listing 3dFracture/matrix_app.i block=PorousFlowFullySaturated

!listing 3dFracture/matrix_app.i block=DiracKernels

It is assumed the rock matrix has small porosity of 0.1 and permeability of $10^{-18}\,$m$^{2}$.  The rock density is 2700$\,$kg.m$^{-3}$ with specific heat capacity of 800$\,$J.kg$^{-1}$.K$^{-1}$ and isotropic thermal conductivity of 5$\,$W.m$^{-1}$.K$^{-1}$.  Hence, the `Materials` block is:

!listing 3dFracture/matrix_app.i block=Materials

The matrix needs to compute $\lambda_{\mathrm{m}}^{nn}$ and $L$ to send these to the fracture.  This is accomplished using the following:

!listing 3dFracture/matrix_app.i block=AuxKernels

The `Transfers` described above are:

!listing 3dFracture/matrix_app.i block=Transfers


### Results

When using a realistic heat-transfer coefficient, such as [eqn.simple.L] the matrix rapidly heats the injected cool water in the fracture, however smaller $h$ leads to less heating, as shown in [3dFracture_production_T]

!media media/3dFracture_production_T.png
	style=width:60%;margin:auto;padding-top:2.5%;
	id=3dFracture_production_T
	caption=Production temperature from the fracture system when injecting at 0.01g/s, with and without heat transfer from the matrix

The system rapidly reaches equilibrium, where the porepressure is around 20$\,$MPa at the injection well, as shown in [orbit_p].

!media media/orbit_p.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=orbit_p
	caption=Porepressure in the fracture rapidly reaches steady-state with approximately 20MPa at the injection well

For realistic heat-transfer coefficients such as [eqn.simple.L], the injected water is heated from 100$^{\circ}$C to 200$^{\circ}$C within a few metres of the injection well.  This does not produce interesting animations, however, so to get a feel for the system's evolution [orbit_t] shows the results when using an unrealistically small $h$, with $h_{s} = 10^{-3}$ in [eqn.suggested.h.L].  Notice that:

- the injectate does not invade parts of the fracture system
- the higher regions of the fracture system remain hot, due to the buoyancy of the hot water

!media media/orbit_t.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=orbit_t
	caption=Temperature in the fracture when using an unrealistically small heat-transfer coefficient to illustrate the evolution of the system

The temperature in the matrix does not degrade appreciably for a very long time, due to the matrix having such a huge thermal mass compared with the small amount of water passing through the fracture.  [orbit_t_matrix] shows the evolution of the cooled matrix region when using the unrealistically small heat-transfer coefficient.  When using a realistic value such as [eqn.simple.L], and running the simulation for a few years, the cooled region is within only a few metres of the injection well.

!media media/orbit_t_matrix.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=orbit_t_matrix
	caption=Evolution of the regions of the matrix that suffer more than 0.05degC temperature reduction.  Note these results are using an unrealistically small heat-transfer coefficient.
