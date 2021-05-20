[Mesh]
  [generate]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 50
    xmin = 0
    xmax = 50.0
    ny = 10
    ymin = -10
    ymax = 10.0
  []
[]

[Variables]
  [matrix_T]
  []
[]

[AuxVariables]
  [transferred_frac_T]
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
  [toMatrix]
    type = PorousFlowHeatMassTransfer
    variable = matrix_T
    v = transferred_frac_T
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
  dt = 200
  end_time = 200
  nl_rel_tol = 1e-8
  petsc_options_iname = '-pc_type  -pc_factor_mat_solver_package'
  petsc_options_value = 'lu        superlu_dist'
[]


[Outputs]
  print_linear_residuals = false
  exodus = true
[]
