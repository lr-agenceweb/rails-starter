# frozen_string_literal: true

#
# == Connections Controller
#
class ConnectionsController < PostsController
  decorates_assigned :connection

  # GET /liens
  # GET /liens.json
  def index
    @connections = Connection.includes(:translations, :user, :picture, :video_uploads, :video_platforms, :link).online.by_position
    per_p = @setting.per_page == 0 ? @connections.count : @setting.per_page
    @connections = ConnectionDecorator.decorate_collection(@connections.page(params[:page]).per(per_p))
    seo_tag_index category
  end
end
