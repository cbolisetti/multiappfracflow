[Mesh]
  [generate]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 3
    xmin = 0
    xmax = 3
    ny = 2
    ymin = 0
    ymax = 2
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
  [matrix_var]
  []
[]

[ICs]
  [matrix_var]
    type = FunctionIC
    variable = matrix_var
    function = '9 - x - 3 * y'
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

[MultiApps]
  [fracture_app]
    type = TransientMultiApp
    input_files = fracture.i
    cli_args = 'Outputs/file_base=interpolation_matrix_out_fracture_app0'
  []
[]

[Transfers]
  [matrix_to_fracture]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = fracture_app
    source_variable = matrix_var
    variable = from_matrix_var
  []
[]
