# Encoding: utf-8

require 'minitest/autorun'
require './dijkstra'

describe DistanceGraph do

  describe "when initiaized with dijkstraMinData.txt" do

    before do
      @dg = DistanceGraph.new('dijkstraMinData.txt')
    end

    it "creates an object of type DistanceGraph" do
      @dg.must_be_instance_of DistanceGraph 
    end

    it "contains eight vertices" do
      @dg.vertices.size.must_equal 8
    end

    it "contains a vertex of 2 with three edges" do
      edges = @dg.vertices[2]
      
      edges.size.must_equal 3
      edges[0][:connected_vertex].must_equal 1
      edges[0][:distance].must_equal 3
      edges[1][:connected_vertex].must_equal 4
      edges[1][:distance].must_equal 2
      edges[2][:connected_vertex].must_equal 6
      edges[2][:distance].must_equal 13
    end
  end

  describe "test shortest paths from dijkstraMinData.txt" do

    it "creates a list of the shortest paths for each vertex" do
      dg = DistanceGraph.new('dijkstraMinData.txt')
      shortest_paths = dg.find_shortest_paths(1)

      shortest_paths.size.must_equal 8
      shortest_paths[1].must_equal 0
      shortest_paths[2].must_equal 3
      shortest_paths[3].must_equal 2
      shortest_paths[4].must_equal 4
      shortest_paths[5].must_equal 7
      shortest_paths[6].must_equal 9
      shortest_paths[7].must_equal 7
      shortest_paths[8].must_equal 12
    end
  end

  describe "run shortest paths with full datset (dijkstraData.txt)" do
    it "creates a list of the shortest paths for each vertex" do
      dg = DistanceGraph.new('dijkstraData.txt')
      shortest_paths = dg.find_shortest_paths(1)

      shortest_paths.size.must_equal 200
      target_vertices = [7, 37, 59, 82, 99, 115, 133, 165, 188, 197]

      target_vertices_distances = []
      target_vertices.each do |vertex|
        puts "vertex: #{vertex}: #{shortest_paths[vertex]}"
        target_vertices_distances << shortest_paths[vertex]
      end
      puts target_vertices_distances.join(',')
    end
  end
end