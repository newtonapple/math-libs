module DiscreteDistribution
  
  # Return a collection of cdf values given a pdf
  def self.cdf(pdf)
    sum = 0
    pdf.collect{ |fraction|  sum += fraction }
  end
  
  # Returns a collection of cdf value ranges given a pdf
  def self.cdf_ranges(pdf)
    sum = prev = 0
    ranges = []
    pdf.each { |fraction| 
      ranges << ( prev...(sum += fraction) )
      prev = sum
    }
    ranges
  end
  
  # pick_random is useful for spliting up a collection by its specified discrete distribution.
  # Some use cases:
  # 1. you might want to send 80 % of traffic to node1 and 10% to node2 and 10% to node3. 
  # 2. you might want to do a multivariate test by showing a landing page to 20% of its vistors using theme A, 
  # 30% using theme B, and 50% using theme C.
  #
  # def test(runtime=1000, pdf=[0.5, 0.15, 0.35])
  #   sum = pdf.inject(0){|fraction, sum| sum += fraction}
  #   raise "cdf = #{sum}; it doesn't add up to 1; delta: #{sum > 1 ? sum-1 : 1-sum }" if sum != 1
  #   histo = [0] * pdf.size
  #   collection = [] 
  #   pdf.each_with_index{|fraction, i| collection << [i, fraction]}
  #   runtime.times do 
  #     e = DiscreteDistribution.pick_random( collection, :last )
  #     histo[e.first] += 1
  #   end
  #   runtime = runtime.to_f
  #   histo.map{ |count| count / runtime }
  # end
  # test(100000, [0.1, 0.2, 0.124, 0.1235, 0.234, 0.2, 0.0185]) # => [0.09967, 0.2015, 0.12334, 0.12323, 0.23321, 0.2008, 0.01825]
  # 
  # Note the algorithm uses linear search for inverse transform sampling. 
  # Because of this, it achieves best performance characteristics when pdf is sorted in descending order and worst in ascending order.
  def self.pick_random(collection, pdf_method=:to_f)
    rand_fraction = rand
    sum = prev = 0
    collection.each { |element|
      return element if prev <= rand_fraction && rand_fraction < sum += element.send(pdf_method)
      prev = sum
    }
  end
end
