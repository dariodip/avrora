defmodule Avrora.AvroDecoderOptions do
  @moduledoc """
  A wrapper with a bit of a login around the `:avro_binary_decoder` and
  `:avro_ocf` decoder options.
  """

  alias Avrora.Config

  @null_type_name "null"

  @doc """
  A unified erlavro decoder options compatible for both binary and OCF decoders.
  """
  def options do
    %{
      encoding: :avro_binary,
      hook: &__MODULE__.__hook__/4,
      is_wrapped: true,
      map_type: :map,
      record_type: :map
    }
  end

  # NOTE: This is internal module function and should never be used directly
  @doc false
  def __hook__(type, sub_name_or_idx, data, decode_fun) do
    decoder_hook = decoder_hook()

    result = decoder_hook.(type, sub_name_or_idx, data, decode_fun)

    if :avro.get_type_name(type) == @null_type_name,
      do: {nil, data},
      else: result
  end

  defp decoder_hook, do: Config.self().decoder_hook()
end
