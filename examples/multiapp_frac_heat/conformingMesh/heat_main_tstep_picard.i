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
  [main_frac_res]
    order = FIRST
    family=LAGRANGE
  []
  [neg_main_frac_res]
    order = FIRST
    family=LAGRANGE
  []
[]

[MultiApps]
  [sub]
    type = TransientMultiApp
    input_files = ../heat_sub.i
    execute_on = TIMESTEP_END
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
  [res_from_sub]
    type = MultiAppMeshFunctionTransfer
    direction = from_multiapp
    multi_app = sub
    source_variable = sub_frac_res
    variable = main_frac_res
  []
  [res_to_sub]
    type = MultiAppMeshFunctionTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = main_matrix_res
    variable = sub_matrix_res
  []
[]

[AuxKernels]
  [fluxOutFromMainApp]
    type = ParsedAux
    args = 'main_frac_res'
    variable = neg_main_frac_res
    function = '-1*main_frac_res'
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
    transfer_coefficient = -.1
  []
  # I'm trying to account for the flux transfer from the PorousFlowHeatMassTransfer
  # on the sub app
  [residual]
    type = CoupledForce
    variable = T
    v = main_frac_res
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
  # just forcing 2 picard iterations.  Probably not converging
  accept_on_max_picard_iteration = true
  picard_max_its = 2
  picard_abs_tol = 1e-50
  picard_rel_tol = 1e-50
[]

# [Postprocessors]
#   [./picard_its]
#     type = NumPicardIterations
#     execute_on = 'initial timestep_end'
#   [../]
# []

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
  file_base = 'main_picard'
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
