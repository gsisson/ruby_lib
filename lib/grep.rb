class Grep
  # return two arrays:
  #   first is array of every item in exam_list found in order_list (sorted in the order of order_list)
  #   second is array of every item in exam_list NOT found in order_list
  def self.fgrepf(exam_list, order_list)
    if ! exam_list.instance_of?(Array)
      abort "expected array to be passed!"
    end

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
