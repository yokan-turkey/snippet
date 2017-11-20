class PersonalityInsights
  HEADERS = {
    'Content-Type' => "text/plain",
    'Accept' => 'application/json',
    'Accept-Language' => 'ja',
    'Content-Language' => 'ja'
  }.freeze

  def self.call_api(text)
    yml = Settings.ibm.personality_insights
    url =
      File.join(Settings.ibm.host, yml.path) + "?version=#{yml.version}"
    response = Excon.post(
      url,
      headers: HEADERS,
      user: yml.user_name,
      password: yml.user_pass,
      body: text
    )
    JSON.load(response.body)
  end
end
