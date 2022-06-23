defmodule TryoutTest do
  use ExUnit.Case
  doctest Tryout

  test "greets the world" do
    assert Tryout.hello() == :world
  end
end
