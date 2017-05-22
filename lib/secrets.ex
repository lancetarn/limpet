defmodule Limpet.Secrets do
  alias Elixir.Plug.Crypto.KeyGenerator

  @auth_data "Limpet message"

  def encrypt(cleartext, passwd) do
    key = keygen(passwd)
    case ExCrypto.encrypt(key, @auth_data, cleartext) do
      {:error, error} ->
        IO.inspect error
      {:ok, {ad, {iv, cipher_text, cipher_tag}}} ->
        {:ok, payload} = ExCrypto.encode_payload(iv, cipher_text, cipher_tag)
        payload
    end
  end

  def decrypt(payload, passwd) do
    key = keygen(passwd)
    {:ok, {iv, cipher_text, cipher_tag}} = ExCrypto.decode_payload(payload)
    {:ok, cleartext} = ExCrypto.decrypt(key, @auth_data, iv, cipher_text, cipher_tag)
    cleartext
  end

  defp keygen(passwd) do
    salt = Application.get_env(:limpet, Limpet.Secrets)[:salt]
    key = KeyGenerator.generate(passwd, salt)
    key
  end
end
