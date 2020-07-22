class Api::V1::PublicationsController < Api::V1::BaseController
  def show
    @publication = Publication.published.joins(:site).find_by!(sites: { name: params[:name] })

    render json: PublicationSerializer.new(@publication).serialized_json
  end
end
