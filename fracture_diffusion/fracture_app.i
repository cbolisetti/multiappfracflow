[Mesh]
  [generate]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 100
    xmin = 0
    xmax = 50.0
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
    transfer_coefficient = 0.004
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
  dt = 10
  end_time = 200
[]

[Outputs]
  print_linear_residuals = false
  exodus = true
[]

[MultiApps]
  [matrix_app]
    type = TransientMultiApp
    input_files = matrix_app.i
    execute_on = TIMESTEP_END
  []
[]

[Transfers]
  [T_to_matrix]
    type = MultiAppMeshFunctionTransfer # gives zero if meshes don't conform
    direction = to_multiapp
    multi_app = matrix_app
    source_variable = frac_T
    variable = transferred_frac_T
  []
  [T_from_matrix]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = matrix_app
    source_variable = matrix_T
    variable = transferred_matrix_T
  []
[]
