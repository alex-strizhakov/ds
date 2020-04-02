defmodule DS.Parser do
  @moduledoc """
  Parser module, which looks for cached value. If is not found, parses user agent by UAInspector (https://github.com/elixytics/ua_inspector)
  """

  @mobile_device_types ["smartphone", "tablet", "phablet", "feature phone"]

  @doc """
  Parses user agent
  """
  @spec parse(DS.ua()) :: DS.t() | nil
  def parse(""), do: nil
  def parse(nil), do: nil

  def parse(ua) do
    ua
    |> check_cache()
    |> do_parse()
  end

  defp check_cache(ua) do
    case :ets.lookup(:ds_cache, generate_key(ua)) do
      [] -> {:error, ua}
      [{_, result}] -> {:ok, result}
    end
  end

  defp do_parse({:ok, ds}), do: ds

  defp do_parse({:error, ua}) do
    ds =
      ua
      |> UAInspector.parse()
      |> assemble_client()
      |> assemble_device()
      |> assemble_os()

    key = generate_key(ua)
    :ets.insert(:ds_cache, {key, ds})
    ds
  end

  defp assemble_client(%{client: :unknown}) do
    %DS{
      device_type: "desktop"
    }
  end

  defp assemble_client(%UAInspector.Result.Bot{name: name}) do
    %DS{
      is_bot?: true,
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

  defp assemble_device(%DS{} = ds), do: ds

  defp assemble_device(%{ds: ds, result: %{device: device} = result}) do
    %{
      ds: %{
        ds
        | device_type: to_string(device.type),
          device_brand: to_string(device.brand),
          device_model: to_string(device.model),
          is_mobile?: device.type in @mobile_device_types
      },
      result: result
    }
  end

  defp assemble_os(%DS{} = ds), do: ds

  defp assemble_os(%{ds: ds, result: %{os: os}}) do
    %{ds | os: os.name, os_version: to_string(os.version)}
  end

  defp generate_key(ua), do: Base.encode16(:crypto.hash(:md5, ua), case: :lower)
end
