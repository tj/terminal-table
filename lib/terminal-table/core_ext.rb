
module Enumerable
  def sum_of meth
    inject(0) { |sum, object| sum += object.send(meth) }
  end
end