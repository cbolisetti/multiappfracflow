[Mesh]
  [fileRead]
    type = FileMeshGenerator
    file = '../filament.e'
  []
[]

[Variables]
  [T]
  []
[]

[Functions]
  [linear]
    type = PiecewiseLinear
    x = '0 100 300 1000'
    y = '0 1 1 1'
  []
[]

[BCs]
  [left]
    type = FunctionDirichletBC
    boundary = 'mid_left'
    variable = T
    function = linear
  []
  [right]
    type = DirichletBC
    boundary = 'right'
    variable = T
    value = 0
  []
[]

[AuxVariables]
  [frac_T]
    order = FIRST
    family=LAGRANGE
  []
  [main_matrix_res]
    order = FIRST
    family=LAGRANGE
  []
[]

[MultiApps]
  [sub]
    type = TransientMultiApp
    input_files = ../heat_sub.i
    execute_on = TIMESTEP_BEGIN
    # sub_cycling = true
    # interpolate_transfers = true
  []
[]

[Transfers]
  [T_from_sub]
    type = MultiAppMeshFunctionTransfer
    direction = from_multiapp
    multi_app = sub
    source_variable = T
    variable = frac_T
  []
  [T_to_sub]
    type = MultiAppMeshFunctionTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = T
    variable = matrix_T
  []
[]

[Kernels]
  [dot]
    type = TimeDerivative
    variable = T
  []
  [fracture_diffusion]
    type = AnisotropicDiffusion
    tensor_coeff = '1e-3 0 0  0 1e-3 0  0 0 1e-3'
    variable = T
  []
  [fromFrac]
    type = PorousFlowHeatMassTransfer
    variable = T
    v = frac_T
    transfer_coefficient = -0.1
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
  dt = 0.1
  dtmin = 0.001
  end_time = 10
  nl_abs_tol = 1E-7
[]

# [VectorPostprocessors]
#   [xmass]
#     type = LineValueSampler
#     start_point = '0.4 0 0'
#     end_point = '0.5 0 0'
#     sort_by = x
#     num_points = 167
#     variable = massfrac0
#   []
# []

[Outputs]
  file_base = 'main_begin'
  perf_graph = true
  console = true
  exodus = true
  #csv = true
  # [csv]
  #   type= CSV
  #   sync_times = '.1 .2 .3 .4 .5 .6 .7 .8 .9 1 2 3 4 5 6 7 8 9 10'
  #   sync_only = true
  # []
  # [exodus]
  #   type= Exodus
  #   sync_times = '.1 .2 .3 .4 .5 .6 .7 .8 .9 1 2 3 4 5 6 7 8 9 10'
  #   sync_only = true
  # []
[]
