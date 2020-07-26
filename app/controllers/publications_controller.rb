class PublicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @publications = current_user.publications
  end

  def new
    @publication = Publication.new
  end

  def create
    @publication = current_user.publications.build(publication_params)
    if @publication.save
      redirect_to publications_url, notice: "Content created!"
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
      redirect_to edit_publication_url, notice: "Content updated!"
    else
      flash.now[:alert] = "Oops! Could not update content."
      render :edit
    end
  end

  def destroy
    @publication = find_publication
    @publication.destroy
    redirect_to publications_url, notice: "Content deleted."
  end

  private

  def publication_params
    params.require(:publication).permit(:title, :name)
  end

  def find_publication
    current_user.publications.find(params[:id])
  end
end
