# Encoding: utf-8

class EdgeList
  attr_accessor :edges

  def initialize(filename)
    @edges = []

    File.new(filename).readlines.each do |line|
      line_array = line.split(' ')
      tail = line_array[0].to_i
      head = line_array[1].to_i

      @edges.push([tail, head])
    end
  end

  def reverse_edges
    return @edges.map { |e| e.reverse }
  end

  def map_by_finishing_times(finishing_times)
    remapped_edges = []

    @edges.each do |edge|
      new_edge = []
      new_edge[0] = finishing_times[edge[0]]
      new_edge[1] = finishing_times[edge[1]]
      remapped_edges << new_edge
    end

    remapped_edges
  end
end

class Graph
  attr_accessor :vertices
  attr_accessor :current_finishing_time
  attr_accessor :current_leader

  def initialize(edges)
    adjacency_list = generate_adjacency_list(edges)
    @current_finishing_time = 0
    @current_leader = 0
    @vertices = {}
    adjacency_list.each do |key, value|
      @vertices[key] = {
        id: key,
        is_explored: false,
        finishing_time: nil,
        leader_id: nil,
        edges: value }
    end
  end

  def generate_adjacency_list(edges)
    adjacency_list = {}

    edges.each do |edge|
      tail = edge[0]
      head = edge[1]

      adjacency_list[tail] ||= []
      adjacency_list[head] ||= []
      adjacency_list[tail] = adjacency_list[tail].push(head)
    end

    adjacency_list
  end

  def depth_first_search_loop
    @vertices.size.downto(1) do |i|
      depth_first_search(i) unless @vertices[i][:is_explored]
    end
  end

  def depth_first_search(vertex_id)
    to_be_explored = [vertex_id]

    until to_be_explored.empty?
      vertex_to_explore = to_be_explored.pop
      vertex = @vertices[vertex_to_explore]

      vertex[:is_explored] = true
      vertex[:leader_id] = vertex_id

      is_further_explorable = false

      vertex[:edges].each do |edge_id|
        unless @vertices[edge_id][:is_explored]
          to_be_explored << vertex_to_explore
          to_be_explored << edge_id
          is_further_explorable = true
          break
        end
      end

      unless is_further_explorable
        @current_finishing_time += 1
        vertex[:finishing_time] = @current_finishing_time
      end
    end
  end

  def summarize_finishing_times
    finishing_times = {}
    @vertices.each_value do |vertex|
      finishing_times[vertex[:id]] = vertex[:finishing_time]
    end

    finishing_times
  end

  def summarize_leaders
    leaders = {}

    @vertices.each_value do |vertex|
      if leaders.include? vertex[:leader_id]
        leaders[vertex[:leader_id]] = leaders[vertex[:leader_id]] + 1
      else
        leaders[vertex[:leader_id]] = 1
      end
    end

    leaders
  end
end

