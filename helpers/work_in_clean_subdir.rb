class WorkInCleanSubdir
  def self.go()
    begin
      @tmp_dir="_tmp_dir_#{rand(10000)}"
      @start_dir=Dir.pwd
      Dir.mkdir(@tmp_dir)
      Dir.chdir(@tmp_dir)
      yield
    ensure
      Dir.chdir(@start_dir)
      FileUtils.rm_r(@tmp_dir)
    end
  end
end
