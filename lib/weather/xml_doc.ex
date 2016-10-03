defmodule Weather.XMLDoc do
  require Record

  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,    from_lib: "xmerl/include/xmerl.hrl")
  
  def from_string(xml_string, options \\ [quiet: true]) do
    {doc, []} =
      xml_string
      |> :binary.bin_to_list
      |> :xmerl_scan.string(options)
      
    doc
  end
  
  def get_details(node) do
    # [
    #  location: get_location(node),
    #  temperature: get_temperature(node),
    #  dewpoint: get_dewpoint(node),
    #  humidity: get_humidity(node),
    #  wind: get_wind(node),
    #  weather: get_weather(node)
    # ]
    # Enum.into([
    #            {"location", get_location(node)},
    #            {"temperature", get_temperature(node)},
    #            {"dewpoint", get_dewpoint(node)},
    #            {"humidity", get_humidity(node)},
    #            {"wind", get_wind(node)},
    #            {"weather", get_weather(node)}
    #           ], HashDict.new)
    Enum.into([
               {"location", get_location(node)},
               {"temperature", get_temperature(node)},
               {"dewpoint", get_dewpoint(node)},
               {"humidity", get_humidity(node)},
               {"wind", get_wind(node)},
               {"weather", get_weather(node)}
              ], HashDict.new)
  end
  
  def get_location(node) do
    get_xml_text(node, "//location")
  end
  
  def get_weather(node) do
    get_xml_text(node, "//weather")
  end
  
  def get_temperature(node) do
    get_xml_text(node, "//temperature_string")
  end
  
  def get_dewpoint(node) do
    get_xml_text(node, "//dewpoint_string")
  end
  
  def get_humidity(node) do
    get_xml_text(node, "//relative_humidity")
  end
  
  def get_wind(node) do
    get_xml_text(node, "//wind_string")
  end
  
  def get_xml_text(node, path) do
    node
      |> first(path)
      |> text
  end
  
  def all(node, path) do
    for child_element <- xpath(node, path) do
      child_element
    end
  end
  
  def first(node, path), do: node |> xpath(path) |> take_one
  defp take_one([head | _]), do: head
  defp take_one(_), do: nil

  def node_name(nil), do: nil
  def node_name(node), do: elem(node, 1)

  def attr(node, name), do: node |> xpath('./@#{name}') |> extract_attr
  defp extract_attr([xmlAttribute(value: value)]), do: List.to_string(value)
  defp extract_attr(_), do: nil

  def text(node), do: node |> xpath('./text()') |> extract_text
  defp extract_text([xmlText(value: value)]), do: List.to_string(value)
  defp extract_text(_x), do: nil
  
  defp xpath(nil, _), do: []
  defp xpath(node, path) do
    :xmerl_xpath.string(to_char_list(path), node)
  end
  
end
