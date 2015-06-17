class VectorCalculation
  class << self
  def cos_of(array1, array2)
    inner_product(array1, array2)/(r_of(array1)*r_of(array2))
  end
  def inner_product(array1, array2)
    [array1, array2].transpose.map{ |x| x.inject(:*) }.inject(:+)
  end
  def r_of(array)
    Math.sqrt(array.map{ |x| x**2 }.sum)
  end
  end
end
