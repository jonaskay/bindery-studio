module ProjectsHelper
  def publish_link(project)
    link_to("Publish", project_publishings_path(project), method: :post)
  end
end
