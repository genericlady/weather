defmodule XMLDocTest do
  use ExUnit.Case
  import Weather.XMLDoc

  test "scan a string of xml and transform into a tuple" do
    xml_string = Weather.XMLDoc.from_string(
    """
    <current_observation version="1.0"
             xmlns:xsd="http://www.w3.org/2001/XMLSchema"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:noNamespaceSchemaLocation="http://www.weather.gov/view/current_observation.xsd">
            <credit>NOAA's National Weather Service</credit>
            <credit_URL>http://weather.gov/</credit_URL>
            <image>
                    <url>http://weather.gov/images/xml_logo.gif</url>
                    <title>NOAA's National Weather Service</title>
                    <link>http://weather.gov</link>
            </image>
            <location>Denton Municipal Airport, TX</location>
    </current_observation>
    """)
    
    # it should find what i need without iteration
    Enum.each(Weather.XMLDoc.all(xml_string, "//location"), fn(node) ->
      IO.puts """
      name=#{Weather.XMLDoc.node_name(node)} 
      id=#{Weather.XMLDoc.attr(node, "id")} 
      text=#{Weather.XMLDoc.text(node)}
      """
    end)
  end
end
