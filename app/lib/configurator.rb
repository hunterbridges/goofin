class Configurator
  attr_accessor :valid_scopes

  def initialize(env_config)
    @env_config = env_config
    @valid_scopes = []
    @scope_files = {}
    @scope_cache = {}
    load_scopes
  end

  def [](k)
    @env_config[k]
  end

  def load_scopes
    puts "Loading scopes..."
    path = "#{$CONTAINER_ROOT}/config/scopes/**/*.{yml,yaml}"
    Dir.glob(path).each do |file|
      scopename = File.basename(file, ".*")
      @valid_scopes.push scopename
      @scope_files[scopename] = file
      puts "Loaded #{scopename}"
    end
  end

  def for_scope(scope)
    throw "Invalid scope" unless @valid_scopes.include? scope
    return @scope_cache[scope] if @scope_cache.include? scope

    scope_file = @scope_files[scope]
    scope_hash = Hash.transform_keys_to_symbols YAML.load_file(scope_file)
    merged = @env_config.deep_merge scope_hash
    @scope_cache[scope] = merged

    merged
  end
end
