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
    transfer_coefficient = 0.004
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
    input_files = matrix_app_dirac.i
    execute_on = TIMESTEP_END
  []
[]

[Transfers]
  [heat_to_matrix]
    type = MultiAppReporterTransfer
    direction = to_multiapp
    multi_app = matrix_app
    from_reporters = heat_transfer_rate/joules_per_s
    to_reporters = heat_transfer_rate/transferred_joules_per_s
  []
  [T_from_matrix]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = matrix_app
    source_variable = matrix_T
    variable = transferred_matrix_T
  []
[]
