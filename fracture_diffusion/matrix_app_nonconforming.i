[Mesh]
  [generate]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 20
    xmin = 0
    xmax = 10.0
    ny = 20
    ymin = -1.9
    ymax = 2.1
  []
[]

[Variables]
  [matrix_T]
  []
[]

[Kernels]
  [dot]
    type = TimeDerivative
    variable = matrix_T
  []
  [matrix_diffusion]
    type = AnisotropicDiffusion
    variable = matrix_T
    tensor_coeff = '1E-3 0 0 0 1E-3 0 0 0 1E-3'
  []
[]

[DiracKernels]
  [heat_from_fracture]
    type = VectorPostprocessorPointSource
    variable = matrix_T
    vector_postprocessor = heat_transfer_rate
    value_name = transferred_joules_per_s
  []
[]

[VectorPostprocessors]
  [heat_transfer_rate]
    type = ConstantVectorPostprocessor
    vector_names = 'transferred_joules_per_s x y z'
    value = '0; 0; 0; 0'
    outputs = none
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
  dt = 2
  end_time = 100
[]


[Outputs]
  print_linear_residuals = false
  exodus = true
[]

[MultiApps]
  [fracture_app]
    type = TransientMultiApp
    input_files = fracture_app_dirac.i
    cli_args = 'Kernels/toMatrix/transfer_coefficient=0.01'
    execute_on = TIMESTEP_BEGIN
  []
[]

[Transfers]
  [T_to_fracture]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = fracture_app
    source_variable = matrix_T
    variable = transferred_matrix_T
  []
  [heat_from_fracture]
    type = MultiAppReporterTransfer
    direction = from_multiapp
    multi_app = fracture_app
    from_reporters = 'heat_transfer_rate/joules_per_s heat_transfer_rate/x heat_transfer_rate/y heat_transfer_rate/z'
    to_reporters = 'heat_transfer_rate/transferred_joules_per_s heat_transfer_rate/x heat_transfer_rate/y heat_transfer_rate/z'
  []
[]
