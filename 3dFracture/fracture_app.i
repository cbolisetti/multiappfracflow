injection_rate = 1E-2 # kg/s

twice_injection_rate = ${fparse 2*injection_rate}

[Mesh]
  [cluster34]
    type = FileMeshGenerator
    file = 'Cluster_34.exo'
  []
  [injection_node]
    type = BoundingBoxNodeSetGenerator
    input = cluster34
    bottom_left = '-1000 0 -1000'
    top_right = '1000 1 1000'
    new_boundary = injection_node
  []
  [production_node]
    type = BoundingBoxNodeSetGenerator
    input = injection_node
    bottom_left = '-1000 160 -1000'
    top_right = '1000 161 1000'
    new_boundary = production_node
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [frac_P]
    initial_condition = 10 # MPa
    scaling = 1E6
  []
  [frac_T]
    initial_condition = 473
  []
[]

[PorousFlowFullySaturated]
  coupling_type = ThermoHydro
  porepressure = frac_P
  temperature = frac_T
  fp = water
  stabilization = KT
  flux_limiter_type = minmod
  gravity = '0 0 -9.81E-6' # Note the value, because of pressure_unit
  pressure_unit = MPa
[]

[Kernels]
  [toMatrix]
    type = PorousFlowHeatMassTransfer
    variable = frac_T
    v = transferred_matrix_T
    transfer_coefficient = heat_transfer_coefficient
    save_in = joules_per_s
  []
[]

[AuxVariables]
  [heat_transfer_coefficient]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 0.0
  []
  [transferred_matrix_T]
    initial_condition = 473
  []
  [joules_per_s]
  []
  [normal_dirn_x]
    family = MONOMIAL
    order = CONSTANT
  []
  [normal_dirn_y]
    family = MONOMIAL
    order = CONSTANT
  []
  [normal_dirn_z]
    family = MONOMIAL
    order = CONSTANT
  []
  [enclosing_element_normal_length]
    family = MONOMIAL
    order = CONSTANT
  []
  [enclosing_element_normal_thermal_cond]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [normal_dirn_x]
    type = PorousFlowElementNormal
    variable = normal_dirn_x
    component = x
  []
  [normal_dirn_y]
    type = PorousFlowElementNormal
    variable = normal_dirn_y
    component = y
  []
  [normal_dirn_z]
    type = PorousFlowElementNormal
    variable = normal_dirn_z
    component = z
  []
  [heat_transfer_coefficient]
    type = ParsedAux
    variable = heat_transfer_coefficient
    args = 'enclosing_element_normal_length enclosing_element_normal_thermal_cond'
    constant_names = h_s
  constant_expressions = 1E-1 # if 1E-3 then fracture water heats to about 430K (160degC), if 1E-1 then fracture water heats to 473 (200degC)
    function = 'if(enclosing_element_normal_length = 0, 0, h_s * enclosing_element_normal_thermal_cond * 2 * enclosing_element_normal_length / (h_s * enclosing_element_normal_length * enclosing_element_normal_length + enclosing_element_normal_thermal_cond * 2 * enclosing_element_normal_length))' 
  []
[]

[BCs]
  [inject_heat]
    type = DirichletBC
    boundary = injection_node
    variable = frac_T
    value = 373
  []
[]

[DiracKernels]
  [inject_fluid]
    type = PorousFlowPointSourceFromPostprocessor
    mass_flux = ${injection_rate}
    point = '58.8124 0.50384 74.7838'
    variable = frac_P
  []
  [withdraw_fluid]
    type = PorousFlowPolyLineSink
    SumQuantityUO = kg_out_uo
    p_or_t_vals = '5 10 15'
    fluxes = '0 ${injection_rate} ${twice_injection_rate}'
    point_file = production.xyz
    line_length = 1
    variable = frac_P
  []
  [withdraw_heat]
    type = PorousFlowPolyLineSink
    SumQuantityUO = J_out_uo
    p_or_t_vals = '5 10 15'
    fluxes = '0 ${injection_rate} ${twice_injection_rate}'
    point_file = production.xyz
    line_length = 1
    use_enthalpy = true
    variable = frac_T
  []
[]

[UserObjects]
  [kg_out_uo]
    type = PorousFlowSumQuantity
  []
  [J_out_uo]
    type = PorousFlowSumQuantity
  []
[]

[Modules]
  [FluidProperties]
    [true_water]
      type = Water97FluidProperties
    []
    [water]
      type = TabulatedFluidProperties
      fp = true_water
      temperature_min = 275 # K
      temperature_max = 600
      interpolated_properties = 'density viscosity enthalpy internal_energy'
      fluid_property_file = water97_tabulated.csv
    []
  []
[]

[Materials]
  [porosity]
    type = PorousFlowPorosityConst
    porosity = 1E-4 # fracture porosity = 1.0, but this includes fracture aperture of 1E-4
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-15 0 0   0 1E-15 0   0 0 1E-15' # fracture perm = 1E-11 m^2, but this includes fracture aperture of 1E-4
  []
  [internal_energy]
    type = PorousFlowMatrixInternalEnergy
    density = 2700 # kg/m^3
    specific_heat_capacity = 0 # basically no rock inside the fracture
  []
  [aq_thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '0.6E-4 0 0  0 0.6E-4 0  0 0 0.6E-4' # thermal conductivity of water times fracture aperture
  []
[]

[Postprocessors]
  [kg_out]
    type = PorousFlowPlotQuantity
    uo = kg_out_uo
  []
  [J_out]
    type = PorousFlowPlotQuantity
    uo = J_out_uo
  []
  [TK_out]
    type = PointValue
    variable = frac_T
    point = '101.705 160.459 39.5722'
  []
  [P_out]
    type = PointValue
    variable = frac_P
    point = '101.705 160.459 39.5722'
  []
[]

[VectorPostprocessors]
  [heat_transfer_rate]
    type = NodalValueSampler
    outputs = none
    sort_by = id
    variable = joules_per_s
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
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1E3
    optimal_iterations = 4
    growth_factor = 1.1
    timestep_limiting_postprocessor = 1E7
  []
###  dt = 1E7
  end_time = 1E8
  nl_abs_tol = 1E-6
  nl_max_its = 10
[]

[Outputs]
  print_linear_residuals = false
  exodus = true
  csv = true
[]
