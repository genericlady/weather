defmodule Weather.CLI do
  import Weather.TableFormatter, only: [ print_table_for_columns: 1 ]

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a table
  to display weather information for the 
  Denton Municipal Airport, TX.
  """
  
  def main(argv) do
    argv
      |> parse_args
      |> process
  end
  
  @doc """
  `argv` can be -h or --help, which returns :help.
  
  Otherwise it can be the location code for weather
  observtion lookup.
  
  Return a tuple of `{ observation_code }`, or `:help`
  if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(
                          argv,
                          switches: [ help: :boolean],
                          aliases:  [ h: :help ]
                         )
                         
    case parse do
      { [ help: true ], _, _ }       -> :help
      { _, [ observation_code ], _ } -> { observation_code }
      _                              -> :help
    end
  end
  
  def process(:help) do
    IO.puts "This is the help string"
  end
  
  def process({ observation_code }) do
    Weather.Observation.fetch(observation_code)
      |> print_table_for_columns
  end
end
