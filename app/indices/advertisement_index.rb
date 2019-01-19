ThinkingSphinx::Index.define :advertisement,  :primary_key => :integer_id,:with => :real_time do
  indexes title
  indexes content

end
