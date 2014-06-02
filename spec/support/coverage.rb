require 'fileutils'

if ENV["COVERAGE"] =~ /true|yes|on/i
  at_exit do
    src = File.expand_path("../../../../vendor/fontana/coverage", __FILE__)
    if Dir.exist?(src)
      dest = File.expand_path("../../../../coverage", __FILE__)
      FileUtils.rm_rf(dest) if Dir.exist?(dest)
      FileUtils.cp_r(src, dest)
    else
      puts "\e[33mcoverage not found: #{src}\e[0m"
    end
  end
end
