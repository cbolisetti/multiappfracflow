[Mesh]
    type = FileMesh
    file = 'Cluster_34.exo'
[]

[Variables]
  [frac_T]
  []
[]

[AuxVariables]
  [transferred_matrix_T]
  []
  [joules_per_s]
  []
[]

[Kernels]
  [dot_frac_T]
    type = CoefTimeDerivative
    Coefficient = 1E-2
    variable = frac_T
  []
  [fracture_diffusion]
    type = AnisotropicDiffusion
    variable = frac_T
    tensor_coeff = '1E-2 0 0 0 1E-2 0 0 0 1E-2'
  []
  [toMatrix]
    type = PorousFlowHeatMassTransfer
    variable = frac_T
    v = transferred_matrix_T
    transfer_coefficient = 0.02
    save_in = joules_per_s
  []
[]

[VectorPostprocessors]
  [heat_transfer_rate]
    type = NodalValueSampler
    #outputs = none
    sort_by = id
    variable = joules_per_s
  []
  [frac_T]
    type = NodalValueSampler
    outputs = frac_csv
    sort_by = x
    variable = frac_T
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
  [frac_csv]
    type = CSV
    execute_on = final
  []
[]
