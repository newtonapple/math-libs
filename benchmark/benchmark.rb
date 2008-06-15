require '../discrete_distribution'
require 'benchmark'

pdf_sorted_asc  = [ 0.1, 0.2, 0.7 ]  # worst case
pdf_sorted_desc = pdf_sorted_asc.reverse                  # best case
pdf_sorted_rand = pdf_sorted_asc.sort_by{rand}            # random

Benchmark.bmbm(10000) do |b|
  b.report( 'best:' ) { DiscreteDistribution.pick_random pdf_sorted_desc }
  b.report( 'worst:' ) { DiscreteDistribution.pick_random pdf_sorted_asc }
  b.report( 'average' ) { DiscreteDistribution.pick_random pdf_sorted_rand }
end
