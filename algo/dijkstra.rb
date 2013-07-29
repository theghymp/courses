# Encoding: utf-8

class DistanceGraph

  attr_accessor :vertices

  def initialize(filename)
    @vertices = {}

    File.new(filename).readlines.each do |line|
      line = line.chop
      line_array = line.split("\t")
      vertex = line_array[0].to_i

      edges = []

      (1..(line_array.size - 1)).each do |i|
        edge = line_array[i].split(',')
        edges << { connected_vertex: edge[0].to_i, distance: edge[1].to_i }
      end

      @vertices[vertex] = edges
    end
  end

  def find_shortest_paths(starting_vertex_id)
    shortest_paths = {}
    shortest_paths[starting_vertex_id] = 0

    (@vertices.size - 1).times do |v|

      low_greedy_score = nil
      low_greedy_vertex = nil

      shortest_paths.each do |vertex_id, shortest_path|
        edges = @vertices[vertex_id]

        edges.each do |edge|
          connected_vertex = edge[:connected_vertex]

          unless shortest_paths.include? connected_vertex
            distance = edge[:distance]

            if low_greedy_score.nil? || shortest_path + distance < low_greedy_score
              low_greedy_score = shortest_path + distance
              low_greedy_vertex = connected_vertex
            end
          end
        end
      end

      shortest_paths[low_greedy_vertex] = low_greedy_score
    end
    
    shortest_paths
  end

end

