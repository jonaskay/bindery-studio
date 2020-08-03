class PublicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @publications = current_user.publications.kept
  end

  def new
    @publication = Publication.new
  end

  def create
    @publication = current_user.publications.build(publication_params)
    if @publication.save
      redirect_to edit_publication_url(@publication), notice: "Content created!"
    else
      flash.now[:alert] = "Oops! Could not create content."
      render :new
    end
  end

  def edit
    @publication = find_publication
  end

  def update
    @publication = find_publication
    if @publication.update(publication_params)
      redirect_to edit_publication_url(@publication), notice: "Content updated!"
    else
      flash.now[:alert] = "Oops! Could not update content."
      render :edit
    end
  end

  def destroy
    @publication = find_publication
    @publication.discard
    redirect_to publications_url, notice: "Content is being deleted. It will take a few minutes before all the published resources are deleted."
  end

  private

  def publication_params
    params.require(:publication).permit(:title, :name)
  end

  def find_publication
    current_user.publications.kept.find_by!(name: params[:name])
  end
end
