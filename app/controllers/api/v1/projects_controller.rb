class Api::V1::ProjectsController < Api::V1::BaseController
  def show
    @project = Project.revealed.find(params[:id])

    render json: ProjectSerializer.new(@project).serialized_json
  end
end
