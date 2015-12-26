class Task
  include Mongoid::Document
  field :title, type: String

  embedded_in :project
end
