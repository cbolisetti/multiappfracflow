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

[AuxVariables]
  [transferred_joules_per_s]
  []
[]

[VectorPostprocessors]
  [heat_transfer_rate]
    type = NodalValueSampler
    outputs = none
    execute_on = NONE
    sort_by = x
    variable = transferred_joules_per_s
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
[]


[Outputs]
  print_linear_residuals = false
  exodus = true
[]
