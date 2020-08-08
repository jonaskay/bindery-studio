class PublishingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @project = find_project
    if @project.publish
      flash.notice = "Project is being published. This process will take a few minutes."
    else
      flash.alert = "Oops! Could not publish project. Maybe it's already published?"
    end
    redirect_to edit_project_url(@project)
  end

  private

  def find_project
    current_user.projects.kept.find_by!(name: params[:project_name])
  end
end
