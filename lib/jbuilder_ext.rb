class Jbuilder < JbuilderProxy
  def each_property(*array, &block)
    array.each do |property|
      set!(property) { yield }
    end
  end
end