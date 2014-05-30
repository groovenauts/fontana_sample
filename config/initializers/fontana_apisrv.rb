FontanaApisrv.config do |c|
  c.application_class = FontanaSample::Application
end

FontanaApisrv.patch_origin_evolve_time_with_zone
FontanaApisrv.prepare_scm_workspace_class
FontanaApisrv.prepare_initial_version_set
FontanaApisrv.load_app_seed_from_yaml
FontanaApisrv.load_app_seed_from_yaml
FontanaApisrv.logging_configurations
FontanaApisrv.setup_moped_mapping
FontanaApisrv.setup_time_zone
FontanaApisrv.generate_collection_models
FontanaApisrv.setup_uniq_key_gen
FontanaApisrv.convert_unix_time_in_json
