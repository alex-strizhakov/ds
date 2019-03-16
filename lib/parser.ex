defmodule DS.Parser do
  @moduledoc """
  Parser module, which looks for cached value. If is not found, parses user agent by UAInspector (https://github.com/elixytics/ua_inspector)
  """

  @type found :: {:found, DS.t()}
  @type not_found :: {:not_found, DS.ua()}
  @type map_with_result :: %{ds: DS.t(), result: %UAInspector.Result{}}

  @mobile_device_types ["smartphone", "tablet"]

  @doc """
  Parses user agent
  """
  @spec parse(DS.ua()) :: DS.t()
  def parse(ua) do
    ua
    |> check_cache()
    |> do_parse()
  end

  @spec check_cache(DS.ua()) :: found | not_found
  def check_cache(ua) do
    case DS.Cache.UA.get(generate_key(ua)) do
      nil -> {:not_found, ua}
      json -> {:found, Poison.decode!(json, as: %DS{})}
    end
  end

  @spec do_parse(found | not_found) :: DS.t()
  defp do_parse({:found, ds}), do: ds

  defp do_parse({:not_found, ua}) do
    ds =
      UAInspector.parse(ua)
      |> assemble_client()
      |> assemble_device()
      |> assemble_os

    with key <- generate_key(ua),
         json <- Poison.encode!(ds) do
      DS.Cache.UA.set(key, json)
    end

    ds
  end

  @spec assemble_client(%UAInspector.Result{} | %UAInspector.Result.Bot{}) ::
          map_with_result | DS.t()
  defp assemble_client(%{client: :unknown}) do
    %DS{
      device_type: "desktop"
    }
  end

  # TODO: make PULL request for documentation fix, return Result OR Bot
  defp assemble_client(%UAInspector.Result.Bot{name: name}) do
    %DS{
      bot?: true,
      bot_name: name
    }
  end

  defp assemble_client(%{client: client} = result) do
    ds = %DS{
      browser: client.name,
      browser_version: client.version
    }

    Map.new(ds: ds, result: result)
  end

  @spec assemble_device(map_with_result | %DS{}) :: map_with_result | DS.t()
  defp assemble_device(%DS{} = ds), do: ds

  defp assemble_device(%{ds: ds, result: %{device: device} = result}) do
    %{
      ds: %{
        ds
        | device_type: device.type,
          device_brand: device.brand,
          device_model: to_string(device.model),
          mobile?: device.type in @mobile_device_types
      },
      result: result
    }
  end

  @spec assemble_os(map_with_result | %DS{}) :: map_with_result | DS.t()
  defp assemble_os(%DS{} = ds), do: ds

  defp assemble_os(%{ds: ds, result: %{os: os}}) do
    %{ds | os: os.name, os_version: os.version}
  end

  @spec generate_key(DS.ua()) :: String.t()
  defp generate_key(ua) do
    Base.encode16(:crypto.hash(:md5, ua), case: :lower)
  end
end
