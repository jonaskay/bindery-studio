class PublicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @publications = current_user.publications
  end

  def show
    @publication = find_publication
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

  private

  def publication_params
    params.require(:publication).permit(:title)
  end

  def find_publication
    current_user.publications.find(params[:id])
  end
end
