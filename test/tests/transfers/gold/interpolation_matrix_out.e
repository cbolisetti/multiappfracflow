CDF      
      
len_string     !   len_line   Q   four      	time_step          len_name   !   num_dim       	num_nodes         num_elem      
num_el_blk        num_node_sets         num_side_sets         num_el_in_blk1        num_nod_per_el1       num_side_ss1      num_side_ss2      num_side_ss3      num_side_ss4      num_nod_ns1       num_nod_ns2       num_nod_ns3       num_nod_ns4       num_nod_var       num_info  ~         api_version       @�
=   version       @�
=   floating_point_word_size            	file_size               int64_status             title         interpolation_matrix_out.e     maximum_name_length                     
time_whole                            ��   	eb_status                             �   eb_prop1               name      ID              	    	ns_status         	                    	   ns_prop1      	         name      ID              	   	ss_status         
                    	$   ss_prop1      
         name      ID              	4   coordx                      `      	D   coordy                      `      	�   eb_names                       $      
   ns_names      	                 �      
(   ss_names      
                 �      
�   
coor_names                         D      0   node_num_map                    0      t   connect1                  	elem_type         QUAD4         `      �   elem_num_map                             elem_ss1                             side_ss1                          (   elem_ss2                          4   side_ss2                          <   elem_ss3                          D   side_ss3                          L   elem_ss4                          T   side_ss4                          `   node_ns1                          l   node_ns2                          |   node_ns3                          �   node_ns4                          �   vals_nod_var1                          `      ��   vals_nod_var2                          `      �0   name_nod_var                       D      �   info_records                      x�      �                                                                 ?�      ?�              @       @       @      @      ?�              @       @                      ?�      ?�              ?�              ?�      @       @       @       @                                           bottom                           right                            top                              left                             top                              left                             right                            bottom                                                                                                                          	   
                                                   	   
            	                                                                                                                  	   
               
dummy                            matrix_var                         ####################                @"      @       @      @      @      @   # Created by MOOSE #       @      ?�                                            ####################                                                             ### Command Line Arguments ###                                                    ../../../../csiro/csiro-opt -i interpolation_matrix.i### Version Info ###                                                                                        Framework Information:                                                           MOOSE Version:           git commit ced1e7690a on 2021-06-02                     LibMesh Version:         c02af017673655633edfc4ebf8454f46bd94f059                PETSc Version:           3.11.4                                                  SLEPc Version:           3.11.0                                                  Current Time:            Tue Jun  8 13:35:32 2021                                Executable Timestamp:    Thu Jun  3 09:49:50 2021                                                                                                                                                                                                  ### Input File ###                                                                                                                                                []                                                                                 inactive                       = (no_default)                                    custom_blocks                  = (no_default)                                    custom_orders                  = (no_default)                                    element_order                  = AUTO                                            order                          = AUTO                                            side_order                     = AUTO                                            type                           = GAUSS                                         []                                                                                                                                                                [AuxVariables]                                                                                                                                                      [./matrix_var]                                                                     family                       = LAGRANGE                                          inactive                     = (no_default)                                      initial_condition            = INVALID                                           isObjectAction               = 1                                                 order                        = FIRST                                             scaling                      = INVALID                                           type                         = MooseVariableBase                                 initial_from_file_timestep   = LATEST                                            initial_from_file_var        = INVALID                                           block                        = INVALID                                           components                   = 1                                                 control_tags                 = AuxVariables                                      eigen                        = 0                                                 enable                       = 1                                                 fv                           = 0                                                 outputs                      = INVALID                                           use_dual                     = 0                                               [../]                                                                          []                                                                                                                                                                [Executioner]                                                                      auto_preconditioning           = 1                                               inactive                       = (no_default)                                    isObjectAction                 = 1                                               type                           = Transient                                       abort_on_solve_fail            = 0                                               accept_on_max_picard_iteration = 0                                               auto_advance                   = INVALID                                         automatic_scaling              = INVALID                                         compute_initial_residual_before_preset_bcs = 0                                   compute_scaling_once           = 1                                               contact_line_search_allowed_lambda_cuts = 2                                      contact_line_search_ltol       = INVALID                                         control_tags                   = (no_default)                                    custom_abs_tol                 = 1e-50                                           custom_rel_tol                 = 1e-08                                           direct_pp_value                = 0                                               disable_picard_residual_norm_check = 0                                           dt                             = 1                                               dtmax                          = 1e+30                                           dtmin                          = 2e-14                                           enable                         = 1                                               end_time                       = 1e+30                                           error_on_dtmin                 = 1                                               l_abs_tol                      = 1e-50                                           l_max_its                      = 10000                                           l_tol                          = 1e-05                                           line_search                    = default                                         line_search_package            = petsc                                           max_xfem_update                = 4294967295                                      mffd_type                      = wp                                              n_max_nonlinear_pingpong       = 100                                             n_startup_steps                = 0                                               nl_abs_div_tol                 = 1e+50                                           nl_abs_step_tol                = 0                                               nl_abs_tol                     = 1e-50                                           nl_div_tol                     = 1e+10                                           nl_forced_its                  = 0                                               nl_max_funcs                   = 10000                                           nl_max_its                     = 50                                              nl_rel_step_tol                = 0                                               nl_rel_tol                     = 1e-08                                           num_grids                      = 1                                               num_steps                      = 1                                               outputs                        = INVALID                                         petsc_options                  = INVALID                                         petsc_options_iname            = INVALID                                         petsc_options_value            = INVALID                                         picard_abs_tol                 = 1e-50                                           picard_custom_pp               = INVALID                                         picard_force_norms             = 0                                               picard_max_its                 = 1                                               picard_rel_tol                 = 1e-08                                           relaxation_factor              = 1                                               relaxed_variables              = (no_default)                                    reset_dt                       = 0                                               resid_vs_jac_scaling_param     = 0                                               restart_file_base              = (no_default)                                    scaling_group_variables        = INVALID                                         scheme                         = implicit-euler                                  skip_exception_check           = 0                                               snesmf_reuse_base              = 1                                               solve_type                     = NEWTON                                          splitting                      = INVALID                                         ss_check_tol                   = 1e-08                                           ss_tmin                        = 0                                               start_time                     = 0                                               steady_state_detection         = 0                                               steady_state_start_time        = 0                                               steady_state_tolerance         = 1e-08                                           time_period_ends               = INVALID                                         time_period_starts             = INVALID                                         time_periods                   = INVALID                                         timestep_tolerance             = 2e-14                                           trans_ss_check                 = 0                                               update_xfem_at_timestep_begin  = 0                                               use_multiapp_dt                = 0                                               verbose                        = 0                                             []                                                                                                                                                                [ICs]                                                                                                                                                               [./matrix_var]                                                                     inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = FunctionIC                                        block                        = INVALID                                           boundary                     = INVALID                                           control_tags                 = ICs                                               enable                       = 1                                                 function                     = '9 - x - 3 * y'                                   ignore_uo_dependency         = 0                                                 variable                     = matrix_var                                      [../]                                                                          []                                                                                                                                                                [Kernels]                                                                                                                                                           [./dummy]                                                                          inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = Diffusion                                         block                        = INVALID                                           control_tags                 = Kernels                                           diag_save_in                 = INVALID                                           displacements                = INVALID                                           enable                       = 1                                                 extra_matrix_tags            = INVALID                                           extra_vector_tags            = INVALID                                           implicit                     = 1                                                 matrix_tags                  = system                                            save_in                      = INVALID                                           seed                         = 0                                                 use_displaced_mesh           = 0                                                 variable                     = dummy                                             vector_tags                  = nontime                                         [../]                                                                          []                                                                                                                                                                [Mesh]                                                                             displacements                  = INVALID                                         inactive                       = (no_default)                                    use_displaced_mesh             = 1                                               include_local_in_ghosting      = 0                                               output_ghosting                = 0                                               block_id                       = INVALID                                         block_name                     = INVALID                                         boundary_id                    = INVALID                                         boundary_name                  = INVALID                                         construct_side_list_from_node_list = 0                                           ghosted_boundaries             = INVALID                                         ghosted_boundaries_inflation   = INVALID                                         isObjectAction                 = 1                                               second_order                   = 0                                               skip_partitioning              = 0                                               type                           = FileMesh                                        uniform_refine                 = 0                                               allow_renumbering              = 1                                               build_all_side_lowerd_mesh     = 0                                               centroid_partitioner_direction = INVALID                                         construct_node_list_from_side_list = 1                                           control_tags                   = INVALID                                         dim                            = 1                                               enable                         = 1                                               final_generator                = INVALID                                         ghosting_patch_size            = INVALID                                         max_leaf_size                  = 10                                              nemesis                        = 0                                               parallel_type                  = DEFAULT                                         partitioner                    = default                                         patch_size                     = 40                                              patch_update_strategy          = never                                                                                                                            [./generate]                                                                       inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = GeneratedMeshGenerator                            bias_x                       = 1                                                 bias_y                       = 1                                                 bias_z                       = 1                                                 boundary_id_offset           = 0                                                 boundary_name_prefix         = INVALID                                           control_tags                 = Mesh                                              dim                          = 2                                                 elem_type                    = INVALID                                           enable                       = 1                                                 extra_element_integers       = INVALID                                           gauss_lobatto_grid           = 0                                                 nx                           = 3                                                 ny                           = 2                                                 nz                           = 1                                                 show_info                    = 0                                                 xmax                         = 3                                                 xmin                         = 0                                                 ymax                         = 2                                                 ymin                         = 0                                                 zmax                         = 1                                                 zmin                         = 0                                               [../]                                                                          []                                                                                                                                                                [Mesh]                                                                                                                                                              [./generate]                                                                     [../]                                                                          []                                                                                                                                                                [Mesh]                                                                                                                                                              [./generate]                                                                     [../]                                                                          []                                                                                                                                                                [MultiApps]                                                                                                                                                         [./fracture_app]                                                                   inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = TransientMultiApp                                 app_type                     = INVALID                                           bounding_box_inflation       = 0.01                                              bounding_box_padding         = '(x,y,z)=(       0,        0,        0)'          catch_up                     = 0                                                 cli_args                     = Outputs/file_base=interpolation_matrix_out... _fracture_app0                                                                       clone_master_mesh            = 0                                                 control_tags                 = MultiApps                                         detect_steady_state          = 0                                                 enable                       = 1                                                 execute_on                   = TIMESTEP_BEGIN                                    global_time_offset           = 0                                                 implicit                     = 1                                                 input_files                  = /Users/wil04q/projects/multiappfracflow/te... st/tests/transfers/fracture.i                                                        interpolate_transfers        = 0                                                 keep_solution_during_restore = 0                                                 library_name                 = (no_default)                                      library_path                 = (no_default)                                      max_catch_up_steps           = 2                                                 max_failures                 = 0                                                 max_procs_per_app            = 4294967295                                        min_procs_per_app            = 1                                                 move_apps                    = INVALID                                           move_positions               = INVALID                                           move_time                    = 1.79769e+308                                      output_in_position           = 0                                                 output_sub_cycles            = 0                                                 positions                    = INVALID                                           positions_file               = INVALID                                           print_sub_cycles             = 1                                                 relaxation_factor            = 1                                                 relaxed_variables            = (no_default)                                      reset_apps                   = INVALID                                           reset_time                   = 1.79769e+308                                      steady_state_tol             = 1e-08                                             sub_cycling                  = 0                                                 tolerate_failure             = 0                                                 use_displaced_mesh           = 0                                               [../]                                                                          []                                                                                                                                                                [Outputs]                                                                          append_date                    = 0                                               append_date_format             = INVALID                                         checkpoint                     = 0                                               color                          = 1                                               console                        = 1                                               controls                       = 0                                               csv                            = 0                                               dofmap                         = 0                                               execute_on                     = 'INITIAL TIMESTEP_END'                          exodus                         = 1                                               file_base                      = INVALID                                         gmv                            = 0                                               gnuplot                        = 0                                               hide                           = INVALID                                         inactive                       = (no_default)                                    interval                       = 1                                               json                           = 0                                               nemesis                        = 0                                               output_if_base_contains        = INVALID                                         perf_graph                     = 0                                               print_linear_converged_reason  = 1                                               print_linear_residuals         = 1                                               print_mesh_changed_info        = 0                                               print_nonlinear_converged_reason = 1                                             print_perf_log                 = 0                                               show                           = INVALID                                         solution_history               = 0                                               sync_times                     = (no_default)                                    tecplot                        = 0                                               vtk                            = 0                                               xda                            = 0                                               xdr                            = 0                                               xml                            = 0                                             []                                                                                                                                                                [Transfers]                                                                                                                                                         [./matrix_to_fracture]                                                             inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = MultiAppInterpolationTransfer                     allow_skipped_adjustment     = 0                                                 check_multiapp_execute_on    = 1                                                 control_tags                 = Transfers                                         direction                    = to_multiapp                                       displaced_source_mesh        = 0                                                 displaced_target_mesh        = 0                                                 distance_tol                 = 1e-10                                             enable                       = 1                                                 exclude_gap_blocks           = INVALID                                           execute_on                   = TIMESTEP_BEGIN                                    from_postprocessors_to_be_preserved = INVALID                                    from_solution_tag            = INVALID                                           interp_type                  = inverse_distance                                  multi_app                    = fracture_app                                      num_points                   = 3                                                 power                        = 2                                                 radius                       = -1                                                shrink_gap_width             = 0                                                 shrink_mesh                  = SOURCE                                            source_variable              = matrix_var                                        to_postprocessors_to_be_preserved = INVALID                                      to_solution_tag              = INVALID                                           use_displaced_mesh           = 0                                                 variable                     = from_matrix_var                                 [../]                                                                          []                                                                                                                                                                [Variables]                                                                                                                                                         [./dummy]                                                                          family                       = LAGRANGE                                          inactive                     = (no_default)                                      initial_condition            = INVALID                                           isObjectAction               = 1                                                 order                        = FIRST                                             scaling                      = INVALID                                           type                         = MooseVariableBase                                 initial_from_file_timestep   = LATEST                                            initial_from_file_var        = INVALID                                           block                        = INVALID                                           components                   = 1                                                 control_tags                 = Variables                                         eigen                        = 0                                                 enable                       = 1                                                 fv                           = 0                                                 outputs                      = INVALID                                           use_dual                     = 0                                               [../]                                                                          []                                                                                                                                                                                         @"      @       @      @      @      @      @      @      @       @      ?�              ?�                                                                                                      @"      @       @      @      @      @      @      @      @       @      ?�              