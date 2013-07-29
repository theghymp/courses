# Encoding: utf-8

class Graph
  attr_accessor :adjacency_list

  def self.load_file(filename)
    adjacency_list = {}

    File.readlines(filename).each do |line|
      line_array = line.split(' ')
      vertex = line_array[0].to_i
      line_array.delete_at(0)
      connected_vertices = line_array
      connected_vertices = connected_vertices.map { |e| e.to_i }
      adjacency_list[vertex] = connected_vertices
    end

    adjacency_list
  end

  def initialize(list)
    @adjacency_list = list
  end

  def find_cut
    merge_vertices while @adjacency_list.length > 2
    @adjacency_list[@adjacency_list.keys[0]].size
  end

  def merge_vertices
    vertex_a, vertex_b = get_vertices_for_merge

    @adjacency_list[vertex_b].each do |vertex|
      @adjacency_list[vertex].map! { |x| x == vertex_b ? vertex_a : x }
    end

    @adjacency_list[vertex_a].concat(@adjacency_list[vertex_b])
    @adjacency_list[vertex_a].delete(vertex_a)

    @adjacency_list.delete(vertex_b)
  end

  def get_vertices_for_merge
    keys = @adjacency_list.keys

    vertex_a = keys[rand(keys.size)]
    vertex_b = @adjacency_list[vertex_a][rand(@adjacency_list[vertex_a].size)]

    return vertex_a, vertex_b
  end

  def to_s
    s = ''
    @adjacency_list.each do |vertex_detail|
      s << "#{vertex_detail.to_s}\n"
    end

    s
  end
end

# Call with: ruby graph_cuts.rb kargerMinCut.txt 5

min_cut_size = nil
orig_adjacency_list = Graph.load_file(ARGV[0])

ARGV[1].to_i.times do |i|
  g = Graph.new(Marshal.load(Marshal.dump(orig_adjacency_list)))
  cut_size = g.find_cut
  puts "iteration: #{i}, cut_size: #{cut_size}, min_cut_size: #{min_cut_size} "
  
  if min_cut_size
    min_cut_size = cut_size if min_cut_size > cut_size
  else
    min_cut_size = cut_size
  end
end
