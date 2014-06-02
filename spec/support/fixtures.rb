# -*- coding: utf-8 -*-
module FixtureLoader

  def load_from_fixtures(target_name, base_dir = File.expand_path("../../fixtures", __FILE__))
    path = File.join(base_dir, target_name)
    base_dir =
      if File.directory?(path) then
        path
      elsif File.readable?(path) then
        path.scan(%r!(#{Regexp.escape(base_dir)}/[^/]+)/!).flatten.first
      end

    yamls =
      if File.directory?(path) then Dir[File.join(path, "**/*.yml")]
      elsif File.readable?(path) then [path]
      else raise "#{path} can't be read"
      end

    if yamls.empty?
      raise "no fixture found in #{path}"
    end

    yamls.each do |file|
      load_yaml_fixture(file, base_dir)
    end
  end

  MODEL_CLASS_ALIAS = {
    "AppSeed" => "Fontana::AppSeed",
    "ClientRelease" => "Fontana::ClientRelease",
    "ClientRelease::DeviceType" => "Fontana::ClientRelease::DeviceType",
    "MasterDiff" => "Fontana::MasterDiff",
    "VersionSet" => "Fontana::VersionSet",
  }

  def load_yaml_fixture(file, base_dir)
    rel_path = file.sub(/#{Regexp.escape(base_dir + "\/")}/, '') # "foo/bar/CamelCaseName.yml"
    last_name = File.basename(rel_path, '.*')
    base_name = rel_path.sub(/\.yml$/, '').sub(last_name, last_name.tableize)
    model_name = base_name.classify
    model_name = MODEL_CLASS_ALIAS[model_name] || model_name

    attrs_array = YAML.load(IO.read(file))
    if klass = model_name.constantize rescue nil
      # モデルがある場合
      Rails.logger.warn("using model '#{model_name}' for fixture loading")
      klass.delete_all
      attrs_array.each do |attrs|
        _id = attrs.delete("_id")
        obj = klass.new(attrs)
        obj._id = _id if _id
        obj.save!
      end
    else
      # モデルがない場合
      Rails.logger.warn("model '#{model_name}' not found for fixture loading")
      col_name = base_name.gsub(%r{/}, '_')
      col = Mongoid.default_session.with(safe: true)[col_name]
      col.find.remove_all
      attrs_array.each do |attrs|
        doc = attrs.each_with_object({}) do |(k,v), d|
          d[k] =
            case k
            when /_at\Z/ then # 末尾が_atで終わる場合
              v.is_a?(String) ? Time.zone.parse(v) : v
            else v
            end
        end
        col.insert(doc)
      end
    end
  end

end

def fixtures(name)
  include FixtureLoader
  before do
    load_from_fixtures(name)
  end
end
