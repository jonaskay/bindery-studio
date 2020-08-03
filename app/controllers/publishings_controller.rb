class PublishingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @publication = find_publication
    if @publication.publish
      flash.notice = "Content is being published. This process will take a few minutes."
    else
      flash.alert = "Oops! Could not publish content. Maybe it's already published?"
    end
    redirect_to edit_publication_url(@publication)
  end

  private

  def find_publication
    current_user.publications.kept.find_by!(name: params[:publication_name])
  end
end
