[Mesh]
  [generate]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 44
    xmin = -10
    xmax = 210
    ny = 34
    ymin = -10
    ymax = 160
    nz = 44
    zmin = -10
    zmax = 210
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [matrix_P]
    initial_condition = 10 # MPa
    scaling = 1E6
  []
  [matrix_T]
    initial_condition = 473
  []
[]

[PorousFlowFullySaturated]
  coupling_type = ThermoHydro
  porepressure = matrix_P
  temperature = matrix_T
  fp = water
  gravity = '0 0 -9.81E-6' # Note the value, because of pressure_unit
  pressure_unit = MPa
[]

[DiracKernels]
  [heat_from_fracture]
    type = VectorPostprocessorPointSource
    variable = matrix_T
    vector_postprocessor = heat_transfer_rate
    value_name = transferred_joules_per_s
  []
[]

[Modules]
  [FluidProperties]
    [water]
      type = SimpleFluidProperties # this is largely irrelevant here since we care about heat conduction only
      thermal_expansion = 0 # to prevent depressurization as the reservoir is cooled
    []
  []
[]

[Materials]
  [porosity]
    type = PorousFlowPorosityConst
    porosity = 1E-3 # small porosity of rock
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-18 0 0   0 1E-18 0   0 0 1E-18'
  []
  [internal_energy]
    type = PorousFlowMatrixInternalEnergy
    density = 2700 # kg/m^3
    specific_heat_capacity = 800 # rough guess at specific heat capacity
  []
  [aq_thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '5 0 0  0 5 0  0 0 5' # thermal conductivity of water times fracture aperture
  []
[]

[VectorPostprocessors]
  [heat_transfer_rate]
    type = ConstantVectorPostprocessor
    vector_names = 'transferred_joules_per_s x y z'
    value = '0; 0; 0; 0'
    outputs = none
  []
[]

[AuxVariables]
  [normal_thermal_conductivity]
    family = MONOMIAL
    order = CONSTANT
  []
  [fracture_normal_x]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 0
  []
  [fracture_normal_y]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 1
  []
  [fracture_normal_z]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 0
  []
  [element_normal_length]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [normal_thermal_conductivity]
    type = ConstantAux
    variable = normal_thermal_conductivity
    value = 5 # very simple in this case
  []
  [element_normal_length]
    type = PorousFlowElementLength
    variable = element_normal_length
    direction = 'fracture_normal_x fracture_normal_y fracture_normal_z'
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
    dt = 1E4
    optimal_iterations = 4
    timestep_limiting_postprocessor = 1E8
  []
  end_time = 1E9
  nl_abs_tol = 1E-4
[]

[Outputs]
  print_linear_residuals = false
  exodus = true
[]

[MultiApps]
  [fracture_app]
    type = TransientMultiApp
    input_files = fracture_app.i
    execute_on = TIMESTEP_BEGIN
    sub_cycling = true
### catch_up = true
### max_catch_up_steps = 100
  []
[]

[Transfers]
  [element_normal_length_to_fracture]
    type = MultiAppNearestNodeTransfer
    direction = to_multiapp
    multi_app = fracture_app
    source_variable = element_normal_length
    variable = enclosing_element_normal_length
  []
  [element_normal_thermal_cond_to_fracture]
    type = MultiAppNearestNodeTransfer
    direction = to_multiapp
    multi_app = fracture_app
    source_variable = normal_thermal_conductivity
    variable = enclosing_element_normal_thermal_cond
  []
  [T_to_fracture]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = fracture_app
    source_variable = matrix_T
    variable = transferred_matrix_T
  []
  [normal_x_from_fracture]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = fracture_app
    source_variable = normal_dirn_x
    variable = fracture_normal_x
  []
  [normal_y_from_fracture]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = fracture_app
    source_variable = normal_dirn_y
    variable = fracture_normal_y
  []
  [normal_z_from_fracture]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = fracture_app
    source_variable = normal_dirn_z
    variable = fracture_normal_z
  []
  [heat_from_fracture]
    type = MultiAppReporterTransfer
    direction = from_multiapp
    multi_app = fracture_app
    from_reporters = 'heat_transfer_rate/joules_per_s heat_transfer_rate/x heat_transfer_rate/y heat_transfer_rate/z'
    to_reporters = 'heat_transfer_rate/transferred_joules_per_s heat_transfer_rate/x heat_transfer_rate/y heat_transfer_rate/z'
  []
[]
