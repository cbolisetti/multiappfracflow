[Mesh]
  [generate]
    type = GeneratedMeshGenerator
    dim = 3
    xmin=-260
    xmax=260
    nx=52
    ymin=-260
    ymax=260
    ny=52
    zmin=-100
    zmax=160
    nz=26
  []
[]

[Variables]
  [matrix_T]
  []
[]

[BCs]
  [frac_T]
    type = DirichletBC
    variable = matrix_T
    boundary = bottom
    value = 1
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
  dt = 10
  end_time = 1000
  nl_rel_tol = 1e-8
  petsc_options_iname = '-pc_type  -pc_factor_mat_solver_package'
  petsc_options_value = 'lu        superlu_dist'
[]


[Outputs]
  print_linear_residuals = false
  exodus = true
  csv=true
[]

[MultiApps]
  [fracture_app]
    type = TransientMultiApp
    input_files = fracture_app_dirac.i
    execute_on = TIMESTEP_BEGIN
#    sub_cycling = true
#    interpolate_transfers = true
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
