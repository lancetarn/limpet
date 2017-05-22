defmodule Limpet.SecretsTest do
  alias Limpet.Secrets
  use ExUnit.Case

  @cleartext "foobar"
  @passwd "baz"


  test "Encrypts a string with a key" do
    payload = Secrets.encrypt(@cleartext, @passwd)
    IO.inspect payload
    assert is_binary(payload)
    assert payload != @cleartext
    assert Secrets.decrypt(payload, @passwd) == @cleartext
  end
end
