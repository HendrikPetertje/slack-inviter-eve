class EveAuth
  require 'httparty'

  def initialize(attributes  = {})
    @eve_code = attributes[:eve_code]
  end

  def authenticated
    bearer_token = auth_with_eve
    return {status: 'error'} unless bearer_token
    character_info = fetch_character_info(bearer_token)
    return character_info if character_info[:status] == 'error'
    alliance_info = fetch_alliance_info(character_info)
    return alliance_info if alliance_info[:status] == 'error'
    alliance_user = user_allowed_access?(alliance_info)
    return alliance_user if alliance_user[:status] == 'error'
    end_user = fetch_corp_info(alliance_user)
    end_user
  end

  private

  # AUTH
  def auth_with_eve
    response = HTTParty.post(
      'https://login.eveonline.com/oauth/token',
      basic_auth: auth_http_auth,
      headers: auth_headers,
      body: auth_body
    ).parsed_response

    response['access_token']
  rescue StandardError => e
    puts e
    nil
  end

  def auth_http_auth
    client_id = Rails.application.config.client_id
    secret_key = Rails.application.config.secret_key
    { username: client_id, password: secret_key }
  end

  def auth_headers
    {
      "Content-Type" => 'application/json',
      "accept" => 'application/json'
    }
  end

  def auth_body
    {
      "grant_type" => 'authorization_code',
      "code" => @eve_code
    }.to_json
  end

  ## Character info
  def fetch_character_info(bearer_token)
    response = HTTParty.get(
      'https://login.eveonline.com/oauth/verify',
      headers: character_headers(bearer_token)
    ).parsed_response
    {
      id: response['CharacterID'],
      name: response['CharacterName'],
      status: 'ok'
    }
  rescue StandardError => e
    puts e
    {status: 'error'}
  end

  def character_headers(bearer_token)
    {
      "Authorization" => "Bearer #{bearer_token}"
    }
  end

  ## Alliance info
  def fetch_alliance_info(character_info)
    response = HTTParty.get(
      'https://api.eveonline.com/eve/CharacterInfo.xml.aspx',
      query: {characterID: character_info[:id] }
    ).parsed_response
    character_info[:corp_id] = response['eveapi']['result']['corporationID']
    character_info[:alliance] = response['eveapi']['result']['alliance']
    character_info
  rescue StandardError => e
    puts e
    {status: 'error'}
  end

  ## User allowed access?
  def user_allowed_access?(alliance_info)
    allowed_access = Rails.application.config.alliances.include?(alliance_info[:alliance])
    alliance_info[:allowed_access] = allowed_access
    alliance_info
  end

  def fetch_corp_info(character_info)
    response = HTTParty.get(
      'https://api.eveonline.com/corp/CorporationSheet.xml.aspx',
      query: {corporationID: character_info[:corp_id] }
    ).parsed_response
    character_info[:corp] = response['eveapi']['result']['ticker']
    character_info
  rescue StandardError => e
    puts e
    {status: 'error'}
  end
end
