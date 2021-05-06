[Mesh]
  [fileRead]
    type = FileMeshGenerator
    file = 'filament.e'
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

[Kernels]
  [dot]
    type = TimeDerivative
    variable = T
  []
  [fracture_diffusion]
    type = AnisotropicDiffusion
    tensor_coeff = '2 0 0  0 2 0  0 0 2'
    variable = T
    block = 'fracture'
  []
  [matrix_diffusion]
    type = AnisotropicDiffusion
    tensor_coeff = '1e-3 0 0  0 1e-3 0  0 0 1e-3'
    variable = T
    block = 'matrix'
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
  dt = .1
  dtmin = 0.001
  end_time = 20
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
  file_base = 'all'
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
