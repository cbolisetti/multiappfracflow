# Fracture
# aperture = 0.01
# length = 10

[Mesh]
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
  [frac_T]
  []
[]

# [AuxVariables]
#   [transferred_matrix_T]
#   []
# []

[BCs]
  [left]
    type = FunctionDirichletBC
    boundary = 'left'
    variable = frac_T
    function = linear
  []
[]

[Functions]
  [linear]
    type = PiecewiseLinear
    x = '0 100 300 1000'
    y = '0 0 1 1'
  []
[]

[Kernels]
  [dot]
    type = TimeDerivative
    variable = frac_T
  []
  [fracture_diffusion]
    type = AnisotropicDiffusion
    tensor_coeff = '1 0 0  0 1 0  0 0 1'
    variable = frac_T
  []
  # [fromMatrix]
  #   type = PorousFlowHeatMassTransfer
  #   variable = frac_T
  #   v = transferred_matrix_T
  # []
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
  nl_abs_tol = 1E-13
  nl_rel_tol = 1E-12
[]

[Postprocessors]
  [left]
    type = PointValue
    point = '-5.0 0 0'
    variable = frac_T
  []
  [mid]
    type = PointValue
    point = '0 0 0'
    variable = frac_T
  []
  [right]
    type = PointValue
    point = '5.0 0 0'
    variable = frac_T
  []
[]

[Outputs]
  print_linear_residuals = false
  exodus = true
  csv = true
[]
