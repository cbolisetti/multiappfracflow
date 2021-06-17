# Fracture flow using a MultiApp approach: Porous flow in a single matrix system

## Background

PorousFlow can be used to simulate flow through fractured porous media.  The fundamental premise is *the fractures can be considered as lower dimensional entities within the higher-dimensional porous media*.  This page is part of a set that describes a MOOSE MultiApp approach to simulating such models:

- [Introduction](multiapp_fracture_flow_introduction.md)
- [Mathematics and physical interpretation](multiapp_fracture_flow_equations.md)
- [Transfers](multiapp_fracture_flow_transfers.md)
- [MultiApp primer](multiapp_fracture_flow_primer.md): the diffusion equation with no fractures, and quantifying the errors introduced by the MultiApp approach
- [Diffusion in mixed dimensions](multiapp_fracture_flow_diffusion.md)
- [Porous flow in a single matrix system](multiapp_fracture_flow_PorousFlow_2D.md)
- [Porous flow in a small fracture network](multiapp_fracture_flow_PorousFlow_3D.md)

## Porous flow through a 3D fracture network

A sample PorousFlow simulation through the small 3D fracture network shown in [orbit_fracture] is presented in this section.  The methodology is described in the above pages.  It is assumed that

- the physics is fully-saturated, non-isothermal porous flow with heat conduction and convection;
- the porepressure is initially hydrostatic, around 10$\,$MPa corresponding to a depth of around 1$\,$km;
- the temperature is 200$^{\circ}$C;
- injection is into the fracture network only, through one point, at a rate of $10\,$kg.s$^{-1}$ and temperature of 100$^{\circ}$C;
- production is from the fracture network only, through one point, at a rate of approximately $10\,$kg.s$^{-1}$ (it cannot be exactly $10\,$kg.s$^{-1}$ initially because this causes large porepressure reductions due to thermal contraction of water and because the aperture increases in response to the injection);
- the fracture aperture dilates elastically in response to enhanced porpressure;
- only heat energy is transferred between the fracture and the matrix: the matrix heats the cool water injected into the fracture network.


!media media/orbit_fracture.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=orbit_fracture
	caption=Fracture network.  The injection point is coloured green.  The production point is red.

## No heat transfer

Before introducing the matrix, consider a model containing just the fracture network.

### Physics

The physics is captured by the [PorousFlowFullySaturated](PorousFlowFullySaturated.md) Action:

!listing 3dFracture/fracture_only_aperture_changing.i block=PorousFlowFullySaturated

Because large changes of temperature and pressure are experienced in this model, the Water97 equation of state is employed:

!listing 3dFracture/fracture_only_aperture_changing.i block=FluidProperties


### Material properties

The insitu fracture aperture is assumed to be $a_{0} = 0.1\,$mm for all the fracture planes.  The fractures are assumed to dilate due to increasing porepressure:

\begin{equation}
\label{eqn.frac.open}
a = a_{0} + A(P - P_{0}) \ ,
\end{equation}

where $A = 10^{-3}\,$m.MPa$^{-1}$.  [eqn.frac.open] could easily be generalised to include a temperature-dependent term (which would still be modelled using [PorousFlowPorosityLinear](PorousFlowPorosityLinear.md)), or more complicated physics introduced through the use of other [PorousFlow porosity](porous_flow/porosity.md) classes.  Using $A = 10^{-3}\,$m.MPa$^{-1}$ means that a pressure increase of 1$\,$MPa dilates the fracture by 1$\,$mm.

The page on [mathematics and physical interpretation](multiapp_fracture_flow_equations.md) demonstrated that the porosity in the 2D fracture simulation should be multiplied by $a$.  Assuming that the porosity of the fracture is 1, the simulation's porosity is $\phi = a$:

!listing 3dFracture/fracture_only_aperture_changing.i block=porosity

The insitu fracture permeability is assumed to be $10^{-11}\,$m$^{2}$.  It is assumed that this is $r a_{0}^{2}/12$, where $r=0.012$ is a factor capturing the roughness of the fracture surfaces.  It is also assumed that when the fracture dilates, this becomes $ra^{2}/12$.  Because of the multplication by $a$ (see [here](multiapp_fracture_flow_equations.md)), the value of permeability used in the simulations is $ra^{3}/12$:

\begin{equation}
\label{eqn.frac.perm}
k = ra^{3}/12 = \frac{ra_{0}^{3}}{12} \frac{a^{3}}{a_{0}^{3}} = 10^{-15} \left(\frac{\phi}{\phi_{0}}\right)^{3} \ .
\end{equation}

Hence a [PorousFlowPermeabilityKozenyCarman](PorousFlowPermeabilityKozenyCarman.md) Material can be used:

!listing 3dFracture/fracture_only_aperture_changing.i block=permeability

Because there is essentially no rock material within the fracture, the matrix internal energy is zero, and it is assumed that the thermal conductivity is constant and independent of $a$ (in reality, this too should increase with $a$, but PorousFlow currently lacks this capability, and thermal conductivity is unlikely to be important within the fracture):

!listing 3dFracture/fracture_only_aperture_changing.i block=internal_energy

!listing 3dFracture/fracture_only_aperture_changing.i block=aq_thermal_conductivity

### Injection and production

The [Thiem equation](https://en.wikipedia.org/wiki/Aquifer_test) may be used to estimate flows to and from the fracture network.  Imagine a single well piercing the fracture network in a normal direction to a fracture plane.  The Thiem equation is

\begin{equation}
Q = \frac{2\pi \rho k_{\mathrm{3D}} L \Delta P}{\mu \log(R/r_{\mathrm{well}})}
\end{equation}

Here

- Q is the flow rate to the well, with SI units kg.s$^{-1}$.
- $\rho$ is the fluid density: in this case $\rho \approx 870\,$kg.m$^{-3}$.
- $k_{\mathrm{3D}}$ is the fracture permeability: in this case $k_{\mathrm{3D}} = ra^{2}/12$ (it is not the 2D version with the "extra" factor of $a$)
- $L$ is the length of well piercing the fracture network: in this case $L=a$.
- $\Delta P$ is the change in pressure resulting from the well pumping: $\Delta P = P_{\mathrm{well}} - P_{0}$.
- $\mu$ is the fluid viscosity: in this case $\mu \approx 1.4\times 10^{-10}\,$MPa.s$^{-1}$
- $R$ is the radius of influence of the well: in this case it is appropriate to choose $R\sim 200\,$m since that is the size of the fracture network
- $r_{\mathrm{well}}$ is the radius of the borehole.  Assume this is $r = 0.075\,$m

[eqn.frac.open] may be used to write $a$ in terms of $\Delta P$.  This analysis is only approximate, but it provides a rough idea of the flow rates to expect, as shown in [table:flowrates].

!table id=table:flowrates caption=Indicative flow rate, aperture and permeability, depending on well pressure
| $\Delta P = P_{\mathrm{well}} - P_{0}$ (MPa) | Q (kg.s$^{-1}$) | a (mm) | permeability (m$^{2}$) |
| --- | --- | --- | --- |
| 0.1 | 0.004 | 0.2 | $4\times 10^{-11}$ |
| 0.2 | 0.03 | 0.3 | $9\times 10^{-11}$ |
| 0.5 | 0.5 | 0.6 | $4\times 10^{-10}$ |
| 1 | 7 | 1 | $10^{-9}$ |
| 2 | 90 | 2 | $4\times 10^{-9}$ |

Economically-viable flow rates are usually greater than about 10$\,$kg.s$^{-1}$, which is the amount prescribed in the MOOSE input file, below.  This means a pressure change of $\sim 1\,$MPa is expected, and apertures will be around 1$\,$mm.  Note that the porepressure around the *producer* should be around 1$\,$MPa *higher* than insitu, in order for the fluid to flow from the fracture to the production well.  If the production well reduces pressure too much, then according to [eqn.frac.open], the fracture will close in its vicinity, resulting in limited fluid production.  Therefore, the numerical model relies on the injector increasing the porepressure throughout the system (by greater than 1$\,$MPa in most places) and the producer removes excess fluid.

PorousFlow has many different types of [sinks](porous_flow/sinks.md) and [boundary conditions](porous_flow/boundaries.md) that can be used to model injection and production wells.  To most accurately represent the physics around these points, appropriate boundary conditions should be chosen that closely match the operating parameters of the pump infrastructure employed.  However, before obsessing over such details, it is worth noting that the fundamental assumption underpinning the PorousFlow module --- that the flow is slow --- is likely to be violated close to the wells.  For instance, if 10$\,$kg.s$^{-1}$ (approximately $10^{-2}\,$m$^{3}$.s$^{-1}$) is injected into a fracture of aperture 2$\,$mm through a borehole of diameter 15$\,$cm, the fluid velocity is approximately $10^{-2}/0.002/(\pi\times 0.15) \approx 11\,$m.s$^{-1}$, which is certainly turbulent and not laminar Darcy flow.  This also means that the injection and production pressures predicted by the PorousFlow model are likely to be inaccurate.

For this reason, the current model implements the injection and production rather simply.  The injection is implemented using a [DirichletBC](DirichletBC.md) for the temperature at the injection node:

!listing 3dFracture/fracture_only_aperture_changing.i block=BCs

and a [PorousFlowPointSourceFromPostprocessor](PorousFlowPointSourceFromPostprocessor.md) DiracKernel for the fluid injection:

!listing 3dFracture/fracture_only_aperture_changing.i block=inject_fluid

As noted above, the production cannot always be 10$\,$kg.s$^{-1}$ (although it assumes this value at steady-state) so it is implemented using two [PorousFlowPeacemanBoreholes](PorousFlowPeacemanBorehole.md): one withdrawing fluid and the other heat energy.  There is a minor subtlety that can arise when using [PorousFlowPeacemanBoreholes](PorousFlowPeacemanBorehole.md) in lower-dimensional input files.  Peaceman [write the flux](porous_flow/sinks.md) as

\begin{equation}
f = W \frac{k_{r}\rho}{\mu}(P - P_{\mathrm{well}}) \ .
\end{equation}

The prefactor, $k_{r}\rho/\mu$ is automatically included when `use_mobility = true`, but Peaceman's "well constant", $W$, is

\begin{equation}
W = 2\pi k_{\mathrm{3D}}L / \log(r_{e}/r_{\mathrm{well}})
\end{equation}

Here $k_{\mathrm{3D}} = k/a$ is the "3D" permeability, and $L = a$ is the length of borehole that is piercing the fracture system.  Hence

\begin{equation}
W = 2\pi k / \log(r_{e}/r_{\mathrm{well}})
\end{equation}

is the appropriate lower-dimensional form.  This is easily obtained in the MOOSE model by setting `line_length = 1` in the input file, and then MOOSE will compute the well constant correctly:

!listing 3dFracture/fracture_only_aperture_changing.i block=DiracKernels

As mentioned above `bottom_p_or_t` is chosen so that the borehole don't "suck" water: instead they rely on the injection to increase the porepressure and pump water into the production borehole.  The reason for this is that if the porepressure reduces around the production well (due to a "suck") then the fracture aperture reduces, making it increasingly difficult to extract water.

### Results

The pressure at the injection point rises from its insitu value of around 9.4$\,$MPa to around 12.2$\,$MPa: an increase of 3$\,$MPa, which results in a fracture aperture of around 3$\,$mm according to [eqn.frac.open].  This results in permeability increasing by a factor of around 27000.

Some results are shown in [fracture_only_aperture_changing_T_out] and [fracture_only_aperture_changing_P_out].  Thermal breakthrough occurs at around 1.5 hours after injection starts.  These simulations were run using different mesh sizes (by choosing `Mesh/uniform_refine` appropriately) to illustrate the impact of different meshes in this problem.  Some observations are:

- There is an interesting increase of temperature around the production well in the finest-resolution case.  The reason for this is that a thin layer of insitu hot fluid is "squashed" against the fracture ends as the cold fluid invades the fracture (the thin layer is not resolved in the low-resolution cases).  This is also clearly seen in [orbit_T].  The hot fluid cannot escape, and it becomes pressurized, leading to an increase in temperature.  Eventually the porepressure increases to 10.6$\,$MPa and the production well activates, withdrawing the hot fluid, and the near-well area cools.  In regions where there is no production well, the high temperature eventually diffuses.  If the production well were in the middle of a fracture, this interesting phenomenon wouldn't be seen.
- As mesh resolution is increased, the results appear to be converging to an "infinite-resolution" case.  Given the likely uncertainties in parameter values and the physics of aperture dilation, a mesh with element side-lengths of 10$\,$m is likely to be perfectly adequate for this type of problem.

!media media/fracture_only_aperture_changing_P_out.png
	style=width:70%;margin:auto;padding-top:2.5%;
	id=fracture_only_aperture_changing_P_out
	caption=Porepressure around the production point in the case where there is no matrix.  The legend's numbers indicate the size of elements used in the simulation

!media media/fracture_only_aperture_changing_T_out.png
	style=width:70%;margin:auto;padding-top:2.5%;
	id=fracture_only_aperture_changing_T_out
	caption=Production temperature in the case where there is no matrix.  The legend's numbers indicate the size of elements used in the simulation

Some animations are shown in [orbit_T] and [orbit_aperture].  One month is simulated, but steady state is rapidly approached within the first few hours of simulation.   The cold injectate invades most of the fracture network: hot pockets of fluid only remain at the tops of some fractures, due to buoyancy.

!media media/fracture_only_aperture_changing_T.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=orbit_T
	caption=Temperature in the fracture for the case where there is no matrix, during the first month of simulation.  The cold injectate invades most of the fracture network: hot pockets of fluid only remain at the tops of some fractures, due to buoyancy.  Time is indicated by the green bar: most of the temerature changes occur within the first few hours

!media media/fracture_only_aperture_changing_aperture.mp4
	style=width:60%;margin:auto;padding-top:2.5%;
	id=orbit_aperture
	caption=Fracture aperture for the case where there is no matrix, during the first month of simulation.  Time is indicated by the green bar: most of the dilation occurs within the first few hours


## Including the matrix

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

The model assumes all fractures have aperture $a = 0.1\,$mm, although prescribing a block-dependent $a$ is obviously easy in MOOSE (it just makes the input file a lot longer).  All fractures are assumed to have porosity 1.0 and permeability $10^{-11}\,$m$^{2}$.  Because there is no "matrix" (rock material) inside the fractures, the matrix specific heat capacity is zero (in the matrix input file the matrix specific heat capacity is non zero) and the thermal conductivity is due to water, $0.6\,$W.m$^{-1}$.K$^{-1}$.  Remembering that all fracture properties much be multiplied by $a$ (see [mathematics and physical interpretation](multiapp_fracture_flow_equations.md)), the `Materials` block reads:

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
