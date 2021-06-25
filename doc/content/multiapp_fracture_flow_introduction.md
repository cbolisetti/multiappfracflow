# Fracture flow using a MultiApp approach: Introduction

PorousFlow can be used to simulate flow through fractured porous media.  The fundamental premise is *the fractures can be considered as lower dimensional entities within the higher-dimensional porous media*.  This has two consequences.

- Meshing is often simplified and computational speed increased.
- The fractures do not provide a barrier to flow in their normal direction.  In fact, flows (of both mass and heat) in the normal direction do not even see the fracture as they move through the porous media.  This is certainly true if the fractures have very small width (as befits a lower-dimensional entity) and flow through the fracture is substantially faster than the flow through the porous media.

A related page TODO_link describes how to simulate porous flow in fractured porous media, assuming that the fractures can be incorporated directly into the mesh as lower dimensional elements, for instance, as 2D "fracture" elements inside a 3D "matrix" mesh.  Unfortunately, realistic fracture networks have such complicated geometry that meshing them is difficult, while incorporating their mesh directly into a higher-dimensional mesh is almost impossible.  In the following set of pages, it is illustrated that MOOSE's MultiApp system may be employed to solve this problem: the "fracture" mesh is governed by one App, which is seperate from the "matrix" mesh that is governed by another App.

- [Introduction](multiapp_fracture_flow_introduction.md)
- [Mathematics and physical interpretation](multiapp_fracture_flow_equations.md)
- [Transfers](multiapp_fracture_flow_transfers.md)
- [MultiApp primer](multiapp_fracture_flow_primer.md): the diffusion equation with no fractures, and quantifying the errors introduced by the MultiApp approach
- [Diffusion in mixed dimensions](multiapp_fracture_flow_diffusion.md)
- [Porous flow in a single matrix system](multiapp_fracture_flow_PorousFlow_2D.md)
- [Porous flow in a small fracture network](multiapp_fracture_flow_PorousFlow_3D.md)
