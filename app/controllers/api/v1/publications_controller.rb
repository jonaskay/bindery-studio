class Api::V1::PublicationsController < Api::V1::BaseController
  def show
    @publication = Publication.published.find(params[:id])

    render json: PublicationSerializer.new(@publication).serialized_json
  end
end
