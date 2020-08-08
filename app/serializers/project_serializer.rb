class ProjectSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :title
end
