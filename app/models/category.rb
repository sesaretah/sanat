class Category < ActiveRecord::Base
  require 'rgl/adjacency'
  require 'rgl/traversal'
  require 'rgl/dijkstra'

  self.primary_key = 'uuid'
  belongs_to :user

  has_many :advertisements
  before_create :set_integer_id

  def cover(style)
    @upload = Upload.where(uploadable_id: self.id, attachment_type: 'category_cover').first
    if !@upload.blank?
      return @upload.attachment(style)
    else
      ActionController::Base.helpers.asset_path("#{rand(2..6)}.png", :digest => false)
    end
  end

  before_create :set_rank
  def set_rank
    self.rank = 0
  end

  def self.tree
    graph = RGL::DirectedAdjacencyGraph.new
    if Category.count > 0
      for category in Category.all
        if category.parent_id == nil
          graph.add_edge '0', category.id
        else
          graph.add_edge category.parent_id, category.id
        end
      end
      return graph.dfs_iterator.to_a
    else
      return []
    end
  end

  def indention
    graph = RGL::DirectedAdjacencyGraph.new
    edge_weights = {}
    for category in Category.all
      if category.parent_id == nil
        graph.add_edge '0', category.id
        edge_weights[['0', category.id]] = 1
      else
        graph.add_edge category.parent_id, category.id
        edge_weights[[category.parent_id, category.id]] = 1
      end
    end
    return graph.dijkstra_shortest_path(edge_weights, '0', self.id).length - 2
  end


  def set_integer_id
    @last = Category.all.order('integer_id desc').first
    if !@last.blank?
      @last_id = @last.integer_id
    else
      @last_id = 0
    end
    self.integer_id = @last_id + 1
  end

  before_create :set_uuid
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def id
    self.uuid
  end

  def self.find(uuid)
    Category.find_by_uuid(uuid)
  end
end
