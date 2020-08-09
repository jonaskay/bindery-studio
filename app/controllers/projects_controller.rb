class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to edit_project_url(@project), notice: "Project created!"
    else
      flash.now[:alert] = "Oops! Could not create project."
      render :new
    end
  end

  def edit
    @project = find_project
  end

  def update
    @project = find_project
    if @project.update(project_params)
      redirect_to edit_project_url(@project), notice: "Project updated!"
    else
      flash.now[:alert] = "Oops! Could not update project."
      render :edit
    end
  end

  def destroy
    @project = find_project
    @project.discard
    redirect_to projects_url, notice: "Project is being deleted. It will take a few minutes before all the published resources are deleted."
  end

  private

  def project_params
    params.require(:project).permit(:title, :name)
  end

  def find_project
    current_user.projects.kept.find_by!(name: params[:name])
  end
end
