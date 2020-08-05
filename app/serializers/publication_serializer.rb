class PublicationSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :title
end
