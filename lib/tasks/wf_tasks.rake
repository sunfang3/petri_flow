# frozen_string_literal: true

require "fileutils"
require "pathname"

desc "Wf tasks"

task wf: :environment do
  url = ENV.fetch("WF_LOLA_URL", "https://theo.informatik.uni-rostock.de/storages/uni-rostock/Alle_IEF/Inf_THEO/images/tools_daten/lola-2.0.tar.gz")
  tmp_dir = Rails.root.join("tmp")
  archive = tmp_dir.join("lola.tar.gz")
  source_root = tmp_dir.join("lola-source")
  prefix = tmp_dir.join("lola-prefix")
  lola_bin = prefix.join("bin/lola")

  if lola_bin.exist?
    puts "lola already available at #{lola_bin}, skip build."
    next
  end

  if system("which lola > /dev/null 2>&1")
    puts "lola already available in PATH, skip build."
    next
  end

  FileUtils.mkdir_p(tmp_dir)
  FileUtils.rm_f(archive) if archive.exist? && archive.zero?
  puts "Downloading lola from #{url}"

  unless archive.exist?
    unless system("curl", "-fL", "--retry", "3", "--retry-delay", "1", "-o", archive.to_s, url)
      warn "Skip app:wf: failed to download lola from #{url}."
      next
    end
    if archive.zero?
      warn "Skip app:wf: downloaded archive is empty."
      next
    end
  end

  FileUtils.rm_rf(source_root)
  FileUtils.mkdir_p(source_root)
  unless system("tar", "-zxf", archive.to_s, "-C", source_root.to_s)
    warn "Skip app:wf: failed to extract #{archive}."
    next
  end

  source_dir = Dir.children(source_root)
    .map { |entry| source_root.join(entry) }
    .find(&:directory?)
  unless source_dir
    warn "Skip app:wf: no source directory found after extraction."
    next
  end

  Dir.chdir(source_dir) do
    unless system("./configure", "--prefix=#{prefix}")
      warn "Skip app:wf: configure failed."
      next
    end
    unless system("make")
      warn "Skip app:wf: make failed."
      next
    end
    unless system("make", "install")
      warn "Skip app:wf: make install failed."
      next
    end
  end

  if lola_bin.exist?
    puts "lola installed to #{lola_bin}"
    system(lola_bin.to_s, "--help")
  else
    warn "Skip app:wf: lola binary not found after install."
  end
end
