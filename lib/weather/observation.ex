defmodule Weather.Observation do
  require Logger
  
  def fetch(observation_code) do
    Logger.info "Lets fetch the observation code: #{observation_code}"
    observation_url(observation_code)
      |> HTTPoison.get!
      |> handle_response
  end
  
  def observation_url(observation_code) do
    "http://w1.weather.gov/xml/current_obs/display.php?stid=#{observation_code}"
  end
  
  def handle_response(%{status_code: 200, body: body}) do
    Logger.info "Successful response"
    decode(body)
  end
  
  def decode(body) do
    body
      |> Weather.XMLDoc.from_string
      |> Weather.XMLDoc.get_details
  end
  
end
