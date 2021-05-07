[Mesh]
  [fileRead]
    type = FileMeshGenerator
    file = 'fracture_1d.e'
  []
[]

[Variables]
  [T]
  []
[]

[AuxVariables]
  [matrix_T]
    order = FIRST
    family=LAGRANGE
  []
  [sub_frac_res]
    order = FIRST
    family=LAGRANGE
  []
  [sub_matrix_res]
    order = FIRST
    family=LAGRANGE
  []
  [neg_sub_matrix_res]
    order = FIRST
    family=LAGRANGE
  []
[]

[AuxKernels]
  [fluxOutFromMainApp]
    type = ParsedAux
    args = 'sub_matrix_res'
    variable = neg_sub_matrix_res
    function = '-1*sub_matrix_res'
  []
[]

[Kernels]
  [dot]
    type = TimeDerivative
    variable = T
  []
  [fracture_diffusion]
    type = AnisotropicDiffusion
    tensor_coeff = '2 0 0  0 2 0  0 0 2'
    variable = T
  []
  [fromMatrix]
    type = PorousFlowHeatMassTransfer
    variable = T
    v = matrix_T
    transfer_coefficient = 2 # anisotropicDiffusion/distance between nodes?
    save_in = sub_frac_res
  []
  # this would remove the flux passed to the main app in PorousFlowHeatMassTransfer
  # but that would only work in the picard NumPicardIterations
  # as it is now, the subapp
  [residual]
    type = CoupledForce
    variable = T
    v = neg_sub_matrix_res
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
  file_base = 'sub1d'
  perf_graph = true
  console = true
  exodus = true
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
