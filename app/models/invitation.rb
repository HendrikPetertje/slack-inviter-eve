require "slack/client"

class Invitation
  include Virtus.model
  include ActiveModel::Model

  attribute :email, String
  attribute :first_name, String
  validates :email, :first_name, presence: true

  def enqueue
    InvitationWorker.perform_async(attributes)
  end

  def perform
    slack_client.invite({
        email: email,
        first_name: first_name,
        channels: ENV["SLACK_CHANNELS"].to_s.split(/\s*,\s*/)
      })
  end

  private
  def slack_client
    @slack_client ||= Slack::Client.new({
        subdomain: ENV.fetch("SLACK_SUBDOMAIN"),
        token: ENV.fetch("SLACK_TOKEN")
      })
  end
end
