[Mesh]
  [generate1]
    type = ElementGenerator
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '-1 2 0  0 1.5 0'
  []
  [generate2]
    type = ElementGenerator
    input = generate1
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '0 1.5 0  0.5 1 0'
  []
  [generate3]
    type = ElementGenerator
    input = generate2
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '0.5 1 0  0.5 0.9 0'
  []
  [generate4]
    type = ElementGenerator
    input = generate3
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '0.5 0.9 0  1 0.9 0'
  []
  [generate5]
    type = ElementGenerator
    input = generate4
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '1 0.9 0  1.3 0.9 0'
  []
  [generate6]
    type = ElementGenerator
    input = generate5
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '1.3 0.9 0  1.4 0.5 0'
  []
  [generate7]
    type = ElementGenerator
    input = generate6
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '1.4 0.5 0  1.8 0 0'
  []
  [generate8]
    type = ElementGenerator
    input = generate7
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '1.8 0 0  1.9 -0.1 0'
  []
  [generate9]
    type = ElementGenerator
    input = generate8
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '1.9 -0.1 0  2 -0.2 0'
  []
  [generate10]
    type = ElementGenerator
    input = generate9
    elem_type = 'EDGE2'
    element_connectivity = '0 1'
    nodal_positions = '2 -0.2 0  3 -1 0'
  []
[]

[Variables]
  [dummy]
  []
[]

[Kernels]
  [dummy]
    type = Diffusion
    variable = dummy
  []
[]

[AuxVariables]
  [fracture_var]
    family = MONOMIAL
    order = CONSTANT
  []
  [from_matrix_var]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[ICs]
  [fracture_var]
    type = FunctionIC
    variable = fracture_var
    function = 'y - x'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  dt = 1
  num_steps = 1
[]

[Outputs]
  exodus = true
[]
