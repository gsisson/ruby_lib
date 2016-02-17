# The one method in this class, Grep::fgrepf, works similary to the fgrepf utility.  It 'greps'
# for patterns in one list, that match patterns in another list.  Whereas the fgrepf utility returns
# the 'grep matches', the fgrepf method here returns both the matches as well as the misses.
class Grep
  # return two arrays:
  #   first is array of every item in exam_list found in order_list (sorted in the order of order_list)
  #   second is array of every item in exam_list NOT found in order_list
  def self.fgrepf(exam_list, order_list)
    if ! exam_list.instance_of?(Array)
      raise ArgumentError.new("expected array to be passed as first argument!")
    end
    order_list ||= []
    # store pattern items in a hash
    exam_list_h = {}
    exam_list.each { |f| exam_list_h[f] = f }

    # look for the exam items per the ordered items list
    found = order_list.select do |line|
      exam_list_h.delete(line)
    end
    not_found = exam_list_h.keys
    [found, not_found]
  end
end
