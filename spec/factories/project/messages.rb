FactoryBot.define do
  factory :project_message, class: Project::Message do
    project
    name { :success }
    detail { "detail" }
  end
end
