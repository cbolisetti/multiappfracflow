[Mesh]
  # file = diffusion_1.e # or diffusion_5.e or diffusion_fine.e
  # file = diffusion_fine.e
  [generate]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 10
    ny = 1
    xmin = -5.0
    xmax = 5.0
    ymin = -1.0
    ymax = 1.0
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

# [BCs]
#   [left]
#     type = DirichletBC
#     boundary = 2
#     variable = T
#     value = 1
#   []
# []

[Kernels]
  [dot]
    type = TimeDerivative
    variable = matrix_T
  []
  [fracture_diffusion]
    type = AnisotropicDiffusion
    # block = 0
    tensor_coeff = '1 0 0  0 1 0  0 0 1'
    variable = matrix_T
  []
  [fromFrac]
    type = PorousFlowHeatMassTransfer
    variable = matrix_T
    v = transferred_frac_T
  []
  # [matrix_diffusion]
  #   type = AnisotropicDiffusion
  #   block = '2 3'
  #   tensor_coeff = '5e-3 0 0  0 5e-3 0  0 0 5e-3'
  #   variable = matrix_T
  # []
[]

[MultiApps]
  [frac]
    type = TransientMultiApp
    input_files = fracture.i
    sub_cycling = true
    interpolate_transfers = true
  []
[]

[Transfers]
  [T_from_fract]
    type = MultiAppMeshFunctionTransfer
    direction = from_multiapp
    multi_app = frac
    source_variable = frac_T
    variable = transferred_frac_T
  []
  [T_to_frac]
    type = MultiAppMeshFunctionTransfer
    direction = to_multiapp
    multi_app = frac
    source_variable = matrix_T
    variable = transferred_matrix_T
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
  dt = 1
  end_time = 1000
  nl_abs_tol = 1E-13
  nl_rel_tol = 1E-12
[]

[Postprocessors]
  [left]
    type = PointValue
    point = '-5.0 0 0'
    variable = matrix_T
  []
  [mid]
    type = PointValue
    point = '0 0 0'
    variable = matrix_T
  []
  [right]
    type = PointValue
    point = '5.0 0 0'
    variable = matrix_T
  []
[]

[Outputs]
  print_linear_residuals = false
  exodus = true
  csv = true
[]
