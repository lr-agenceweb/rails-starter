# frozen_string_literal: true
if Rails.env.development?
  task :set_annotation_options do
    # You can override any of these by setting an environment variable of the same name.
    Annotate.set_defaults(
      'require'              => '',
      'model_dir'            => 'app/models',
      'include_version'      => 'false',
      'ignore_model_sub_dir' => 'false',
      'skip_on_db_migrate'   => 'false',

      'exclude_controllers'  => 'true',
      'exclude_helpers'      => 'true',
      'exclude_tests'        => 'true',
      'exclude_fixtures'     => 'false',
      'exclude_factories'    => 'false',
      'exclude_scaffolds'    => 'true',

      'active_admin'         => 'false',
      'routes'               => 'false',
      'position_in_routes'   => 'after',

      'position_in_class'    => 'after',
      'position_in_test'     => 'after',
      'position_in_fixture'  => 'after',
      'position_in_factory'  => 'after',

      'show_indexes'         => 'true',
      'simple_indexes'       => 'false',
      'show_foreign_keys'    => 'false',

      'format_bare'          => 'true',
      'format_rdoc'          => 'false',
      'format_markdown'      => 'false',

      'sort'                 => 'false',
      'force'                => 'false',
      'trace'                => 'false'
    )
  end

  Annotate.load_tasks
end
