require 'minitest/unit'
require './scc_calc'

MiniTest::Unit.autorun

class SCCTests < MiniTest::Unit::TestCase
	def test_load_edges
		edge_list = EdgeList.new('scc_test1.txt')
		assert_equal([1, 4], edge_list.edges[0])
	end

	def test_reverse_edges
		edge_list = EdgeList.new('scc_test1.txt')
		rev_edges = edge_list.reverse_edges
		assert_equal(rev_edges[0], [4, 1])			
	end

	def test_vertices_creation
		edge_list = EdgeList.new('scc_test1.txt')
		rev_edges = edge_list.reverse_edges
		g_rev = Graph.new(rev_edges)
		assert_equal(g_rev.vertices[6], {
      id: 6,
			is_explored: false,
			finishing_time: nil,
			leader_id: nil,
		  edges: [3, 8]})
		assert_equal(g_rev.vertices.size, 9)
	end

	def test_finishing_times
		edge_list = EdgeList.new('scc_test1.txt')
		rev_edges = edge_list.reverse_edges
		g_rev = Graph.new(rev_edges)
    g_rev.depth_first_search_loop
    finishing_times = g_rev.summarize_finishing_times
	
		v = g_rev.vertices
		assert_equal(7, v[1][:finishing_time])
		assert_equal(6, v[9][:finishing_time])
		assert_equal(true, v[6][:is_explored])
		assert_equal([4, 9], v[7][:edges])

		assert_equal(9, finishing_times.size)
		assert_equal(9, finishing_times[7])
		assert_equal(2, finishing_times[5])
	end

	def test_index_by_finishing_times
		edge_list = EdgeList.new('scc_test1.txt')
		rev_edges = edge_list.reverse_edges
		g_rev = Graph.new(rev_edges)
    g_rev.depth_first_search_loop

    finishing_times = g_rev.summarize_finishing_times
		remapped_edges = edge_list.map_by_finishing_times(finishing_times)

		g = Graph.new(remapped_edges)

		v = g.vertices
		assert_equal(v[6][:is_explored], false)
		assert_equal(v[9][:edges], [7])
		assert_equal(v[6][:edges], [1, 9])
	end	

  def test_set_leaders
    edge_list = EdgeList.new('scc_test1.txt')
    rev_edges = edge_list.reverse_edges
    g_rev = Graph.new(rev_edges)
    g_rev.depth_first_search_loop

    finishing_times = g_rev.summarize_finishing_times
    remapped_edges = edge_list.map_by_finishing_times(finishing_times)

    g = Graph.new(remapped_edges)
    g.depth_first_search_loop

    v = g.vertices
    assert_equal(9, v[8][:leader_id])
    assert_equal(4, v[2][:leader_id])
    assert_equal(6, v[5][:leader_id])
  end

  def test_count_leaders
    edge_list = EdgeList.new('scc_test1.txt')
    rev_edges = edge_list.reverse_edges
    g_rev = Graph.new(rev_edges)
    g_rev.depth_first_search_loop

    finishing_times = g_rev.summarize_finishing_times
    remapped_edges = edge_list.map_by_finishing_times(finishing_times)

    g = Graph.new(remapped_edges)
    g.depth_first_search_loop
    leaders = g.summarize_leaders

    assert_equal(3, leaders[6])
    assert_equal(3, leaders[9])
  end

  def test_second_input
    edge_list = EdgeList.new('scc_test2.txt')
    rev_edges = edge_list.reverse_edges
    g_rev = Graph.new(rev_edges)
    g_rev.depth_first_search_loop

    finishing_times = g_rev.summarize_finishing_times
    remapped_edges = edge_list.map_by_finishing_times(finishing_times)

    g = Graph.new(remapped_edges)
    g.depth_first_search_loop
    leaders = g.summarize_leaders

    leaders = leaders.sort { |x, y| y[1] <=> x[1] }

    assert_equal(152, leaders[0][1])
    assert_equal(88, leaders[1][1])
    assert_equal(82, leaders[2][1])
    assert_equal(76, leaders[3][1])
    assert_equal(66, leaders[4][1])
  end
end


edge_list = EdgeList.new(ARGV[0])
rev_edges = edge_list.reverse_edges
g_rev = Graph.new(rev_edges)
g_rev.depth_first_search_loop

finishing_times = g_rev.summarize_finishing_times
remapped_edges = edge_list.map_by_finishing_times(finishing_times)

g = Graph.new(remapped_edges)
g.depth_first_search_loop
leaders = g.summarize_leaders

leaders = leaders.sort { |x, y| y[1] <=> x[1] }
leaders.take(20).each do |leader|
  puts "Leader #{leader[0]}: #{leader[1]}"
end


