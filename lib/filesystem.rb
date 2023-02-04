# input: a list of files including their paths
# dup_name_check() will check that all the basename(file)
# are unique. Will stop with error if two incoming paths
# have the same basename()

class FS
  def self.verify_no_dup_files_across_dirs(vids)
    hash = {}
    probs = []
    vids.each do |vid|
      v = File.basename(vid)
      if ! hash[v]
        hash[v] = vid
      else
        probs << vid
      end
    end
    if probs.size > 0
      STDERR.puts("ERROR: found dup-named vids:")
      probs.each do |prob|
        puts "       #{prob}"
        puts "       #{hash[File.basename(prob)]}"
      end
      exit 1
    end
  end
end
