module ApplicationHelper
  def title
    @title ||= (ENV["TITLE"] || "SlackInviter")
  end

  def top_subtitle
    @toptitle||= (ENV["TOP_SUBTITLE"] || "Come make some friends, share links, meet a lunch buddy.")
  end

  def slack_domain
    @sd ||= (ENV["SLACK_SUBDOMAIN"] || raise("missing SLACK_SUBDOMAIN"))
  end

  def background_image
    @bg ||= (ENV["BACKGROUND_IMAGE"] || "http://i.imgur.com/vDADTWP.jpg")
  end

  def eve_link
      response_type = 'code'
      redirect_uri = URI.escape("#{Rails.application.config.callback_url}")
      client_id = Rails.application.config.client_id
      scope = nil
      state = @current_user.presence || 'nothing'

    link_to("https://login.eveonline.com/oauth/authorize/?response_type=#{response_type}&redirect_uri=#{redirect_uri}&client_id=#{client_id}&scope=#{scope}&state=#{state}") do
      image_tag "/assets/img/login.png"
    end
  end
end
