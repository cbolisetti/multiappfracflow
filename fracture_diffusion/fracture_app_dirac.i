[Mesh]
  [generate]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 30
    xmin = 0
    xmax = 30.0
  []
[]

[Variables]
  [frac_T]
  []
[]

[BCs]
  [frac_T]
    type = DirichletBC
    variable = frac_T
    boundary = left
    value = 1
  []
[]

[AuxVariables]
  [transferred_matrix_T]
  []
  [joules_per_s]
  []
[]

[Kernels]
  [dot]
    type = TimeDerivative
    variable = frac_T
  []
  [fracture_diffusion]
    type = Diffusion
    variable = frac_T
  []
  [toMatrix]
    type = PorousFlowHeatMassTransfer
    variable = frac_T
    v = transferred_matrix_T
    transfer_coefficient = 1E-2
    save_in = joules_per_s
  []
[]

[VectorPostprocessors]
  [heat_transfer_rate]
    type = NodalValueSampler
    outputs = none
    sort_by = x
    variable = joules_per_s
  []
  [frac_T]
    type = NodalValueSampler
    outputs = frac_T
    sort_by = x
    variable = frac_T
  []
[]

[Preconditioning]
  [entire_jacobian]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  dt = 50
  end_time = 50
[]

[Outputs]
  print_linear_residuals = false
  exodus = false
  [frac_T]
    type = CSV
    execute_on = final
  []
[]

