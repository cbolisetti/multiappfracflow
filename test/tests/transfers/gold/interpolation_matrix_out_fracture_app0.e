CDF      
      
len_string     !   len_line   Q   four      	time_step          len_name   !   num_dim       	num_nodes         num_elem   
   
num_el_blk        num_el_in_blk1     
   num_nod_per_el1       num_nod_var       num_info  �         api_version       @�
=   version       @�
=   floating_point_word_size            	file_size               int64_status             title         )interpolation_matrix_out_fracture_app0.e       maximum_name_length                    
time_whole                            �p   	eb_status                                eb_prop1               name      ID                 coordx                      �          coordy                      �      �   coordz                      �      `   eb_names                       $          
coor_names                         d      $   node_num_map                    P      �   connect1      	   
         	elem_type         EDGE2         P      �   elem_num_map                    (      (   vals_nod_var1                          �      �x   vals_nod_var2                          �      �   name_nod_var                       D      P   info_records                      ��      �       ��                      ?�      ?�      ?�      ?�      ?�      ?�      ?�������?�������?�ffffff?�ffffff?�������?�������?�ffffff?�ffffff@       @       @      @       ?�      ?�      ?�      ?�      ?�������?�������?�������?�������?�������?�������?�      ?�                      �����������������ə������ə�������                                                                                                                                                                                                                                                                                                                                         	   
                                                         	   
                                                         	   
dummy                            from_matrix_var                    ####################                                                             # Created by MOOSE #                                                             ####################                                                             ### Command Line Arguments ###                                                    ../../../../csiro/csiro-opt -i interpolation_matrix.i fracture_app0:Outputs/... file_base=interpolation_matrix_out_fracture_app0### Input File ###                                                                                                []                                                                                 inactive                       = (no_default)                                    custom_blocks                  = (no_default)                                    custom_orders                  = (no_default)                                    element_order                  = AUTO                                            order                          = AUTO                                            side_order                     = AUTO                                            type                           = GAUSS                                         []                                                                                                                                                                [AuxVariables]                                                                                                                                                      [./from_matrix_var]                                                                family                       = LAGRANGE                                          inactive                     = (no_default)                                      initial_condition            = INVALID                                           isObjectAction               = 1                                                 order                        = FIRST                                             scaling                      = INVALID                                           type                         = MooseVariableBase                                 initial_from_file_timestep   = LATEST                                            initial_from_file_var        = INVALID                                           block                        = INVALID                                           components                   = 1                                                 control_tags                 = AuxVariables                                      eigen                        = 0                                                 enable                       = 1                                                 fv                           = 0                                                 outputs                      = INVALID                                           use_dual                     = 0                                               [../]                                                                          []                                                                                                                                                                [Executioner]                                                                      auto_preconditioning           = 1                                               inactive                       = (no_default)                                    isObjectAction                 = 1                                               type                           = Transient                                       abort_on_solve_fail            = 0                                               accept_on_max_picard_iteration = 0                                               auto_advance                   = INVALID                                         automatic_scaling              = INVALID                                         compute_initial_residual_before_preset_bcs = 0                                   compute_scaling_once           = 1                                               contact_line_search_allowed_lambda_cuts = 2                                      contact_line_search_ltol       = INVALID                                         control_tags                   = (no_default)                                    custom_abs_tol                 = 1e-50                                           custom_rel_tol                 = 1e-08                                           direct_pp_value                = 0                                               disable_picard_residual_norm_check = 0                                           dt                             = 1                                               dtmax                          = 1e+30                                           dtmin                          = 2e-14                                           enable                         = 1                                               end_time                       = 1e+30                                           error_on_dtmin                 = 1                                               l_abs_tol                      = 1e-50                                           l_max_its                      = 10000                                           l_tol                          = 1e-05                                           line_search                    = default                                         line_search_package            = petsc                                           max_xfem_update                = 4294967295                                      mffd_type                      = wp                                              n_max_nonlinear_pingpong       = 100                                             n_startup_steps                = 0                                               nl_abs_div_tol                 = 1e+50                                           nl_abs_step_tol                = 0                                               nl_abs_tol                     = 1e-50                                           nl_div_tol                     = 1e+10                                           nl_forced_its                  = 0                                               nl_max_funcs                   = 10000                                           nl_max_its                     = 50                                              nl_rel_step_tol                = 0                                               nl_rel_tol                     = 1e-08                                           num_grids                      = 1                                               num_steps                      = 1                                               outputs                        = INVALID                                         petsc_options                  = INVALID                                         petsc_options_iname            = INVALID                                         petsc_options_value            = INVALID                                         picard_abs_tol                 = 1e-50                                           picard_custom_pp               = INVALID                                         picard_force_norms             = 0                                               picard_max_its                 = 1                                               picard_rel_tol                 = 1e-08                                           relaxation_factor              = 1                                               relaxed_variables              = (no_default)                                    reset_dt                       = 0                                               resid_vs_jac_scaling_param     = 0                                               restart_file_base              = (no_default)                                    scaling_group_variables        = INVALID                                         scheme                         = implicit-euler                                  skip_exception_check           = 0                                               snesmf_reuse_base              = 1                                               solve_type                     = NEWTON                                          splitting                      = INVALID                                         ss_check_tol                   = 1e-08                                           ss_tmin                        = 0                                               start_time                     = 0                                               steady_state_detection         = 0                                               steady_state_start_time        = 0                                               steady_state_tolerance         = 1e-08                                           time_period_ends               = INVALID                                         time_period_starts             = INVALID                                         time_periods                   = INVALID                                         timestep_tolerance             = 2e-14                                           trans_ss_check                 = 0                                               update_xfem_at_timestep_begin  = 0                                               use_multiapp_dt                = 0                                               verbose                        = 0                                             []                                                                                                                                                                [Kernels]                                                                                                                                                           [./dummy]                                                                          inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = Diffusion                                         block                        = INVALID                                           control_tags                 = Kernels                                           diag_save_in                 = INVALID                                           displacements                = INVALID                                           enable                       = 1                                                 extra_matrix_tags            = INVALID                                           extra_vector_tags            = INVALID                                           implicit                     = 1                                                 matrix_tags                  = system                                            save_in                      = INVALID                                           seed                         = 0                                                 use_displaced_mesh           = 0                                                 variable                     = dummy                                             vector_tags                  = nontime                                         [../]                                                                          []                                                                                                                                                                [Mesh]                                                                             displacements                  = INVALID                                         inactive                       = (no_default)                                    use_displaced_mesh             = 1                                               include_local_in_ghosting      = 0                                               output_ghosting                = 0                                               block_id                       = INVALID                                         block_name                     = INVALID                                         boundary_id                    = INVALID                                         boundary_name                  = INVALID                                         construct_side_list_from_node_list = 0                                           ghosted_boundaries             = INVALID                                         ghosted_boundaries_inflation   = INVALID                                         isObjectAction                 = 1                                               second_order                   = 0                                               skip_partitioning              = 0                                               type                           = FileMesh                                        uniform_refine                 = 0                                               allow_renumbering              = 1                                               build_all_side_lowerd_mesh     = 0                                               centroid_partitioner_direction = INVALID                                         construct_node_list_from_side_list = 1                                           control_tags                   = INVALID                                         dim                            = 1                                               enable                         = 1                                               final_generator                = INVALID                                         ghosting_patch_size            = INVALID                                         max_leaf_size                  = 10                                              nemesis                        = 0                                               parallel_type                  = DEFAULT                                         partitioner                    = default                                         patch_size                     = 40                                              patch_update_strategy          = never                                                                                                                            [./generate1]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = INVALID                                           nodal_positions              = '(x,y,z)=(      -1,        2,        0) (x... ,y,z)=(       0,      1.5,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate10]                                                                     inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate9                                         nodal_positions              = '(x,y,z)=(       2,     -0.2,        0) (x... ,y,z)=(       3,       -1,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate2]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate1                                         nodal_positions              = '(x,y,z)=(       0,      1.5,        0) (x... ,y,z)=(     0.5,        1,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate3]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate2                                         nodal_positions              = '(x,y,z)=(     0.5,        1,        0) (x... ,y,z)=(     0.5,      0.9,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate4]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate3                                         nodal_positions              = '(x,y,z)=(     0.5,      0.9,        0) (x... ,y,z)=(       1,      0.9,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate5]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate4                                         nodal_positions              = '(x,y,z)=(       1,      0.9,        0) (x... ,y,z)=(     1.3,      0.9,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate6]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate5                                         nodal_positions              = '(x,y,z)=(     1.3,      0.9,        0) (x... ,y,z)=(     1.4,      0.5,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate7]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate6                                         nodal_positions              = '(x,y,z)=(     1.4,      0.5,        0) (x... ,y,z)=(     1.8,        0,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate8]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate7                                         nodal_positions              = '(x,y,z)=(     1.8,        0,        0) (x... ,y,z)=(     1.9,     -0.1,        0)'                                                show_info                    = 0                                               [../]                                                                                                                                                             [./generate9]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ElementGenerator                                  control_tags                 = Mesh                                              elem_type                    = EDGE2                                             element_connectivity         = '0 1'                                             enable                       = 1                                                 input                        = generate8                                         nodal_positions              = '(x,y,z)=(     1.9,     -0.1,        0) (x... ,y,z)=(       2,     -0.2,        0)'                                                show_info                    = 0                                               [../]                                                                          []                                                                                                                                                                [Mesh]                                                                                                                                                              [./generate1]                                                                    [../]                                                                                                                                                             [./generate10]                                                                   [../]                                                                                                                                                             [./generate2]                                                                    [../]                                                                                                                                                             [./generate3]                                                                    [../]                                                                                                                                                             [./generate4]                                                                    [../]                                                                                                                                                             [./generate5]                                                                    [../]                                                                                                                                                             [./generate6]                                                                    [../]                                                                                                                                                             [./generate7]                                                                    [../]                                                                                                                                                             [./generate8]                                                                    [../]                                                                                                                                                             [./generate9]                                                                    [../]                                                                          []                                                                                                                                                                [Mesh]                                                                                                                                                              [./generate1]                                                                    [../]                                                                                                                                                             [./generate10]                                                                   [../]                                                                                                                                                             [./generate2]                                                                    [../]                                                                                                                                                             [./generate3]                                                                    [../]                                                                                                                                                             [./generate4]                                                                    [../]                                                                                                                                                             [./generate5]                                                                    [../]                                                                                                                                                             [./generate6]                                                                    [../]                                                                                                                                                             [./generate7]                                                                    [../]                                                                                                                                                             [./generate8]                                                                    [../]                                                                                                                                                             [./generate9]                                                                    [../]                                                                          []                                                                                                                                                                [Outputs]                                                                          append_date                    = 0                                               append_date_format             = INVALID                                         checkpoint                     = 0                                               color                          = 1                                               console                        = 1                                               controls                       = 0                                               csv                            = 0                                               dofmap                         = 0                                               execute_on                     = 'INITIAL TIMESTEP_END'                          exodus                         = 1                                               file_base                      = interpolation_matrix_out_fracture_app0          gmv                            = 0                                               gnuplot                        = 0                                               hide                           = INVALID                                         inactive                       = (no_default)                                    interval                       = 1                                               json                           = 0                                               nemesis                        = 0                                               output_if_base_contains        = INVALID                                         perf_graph                     = 0                                               print_linear_converged_reason  = 1                                               print_linear_residuals         = 1                                               print_mesh_changed_info        = 0                                               print_nonlinear_converged_reason = 1                                             print_perf_log                 = 0                                               show                           = INVALID                                         solution_history               = 0                                               sync_times                     = (no_default)                                    tecplot                        = 0                                               vtk                            = 0                                               xda                            = 0                                               xdr                            = 0                                               xml                            = 0                                             []                                                                                                                                                                [Variables]                                                                                                                                                         [./dummy]                                                                          family                       = LAGRANGE                                          inactive                     = (no_default)                                      initial_condition            = INVALID                                           isObjectAction               = 1                                                 order                        = FIRST                                             scaling                      = INVALID                                           type                         = MooseVariableBase                                 initial_from_file_timestep   = LATEST                                            initial_from_file_var        = INVALID                                           block                        = INVALID                                           components                   = 1                                                 control_tags                 = Variables                                         eigen                        = 0                                                 enable                       = 1                                                 fv                           = 0                                                 outputs                      = INVALID                                           use_dual                     = 0                                               [../]                                                                          []                                                                                                                                                                                                                                                                                                                                                                                                                         ?�                                                                                                                                                                      @��m��n@.���.@.���.@E�t]F@E�t]F@������@������@/��=@/��=@h"�<��@h"�<��@|ؼw\@|ؼw\@����@����@�+�?@�+�?@      @      @m��m��