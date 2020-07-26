class Api::V1::PublicationsController < Api::V1::BaseController
  def show
    @publication = Publication.published.find_by!(name: params[:name])

    render json: PublicationSerializer.new(@publication).serialized_json
  end
end
