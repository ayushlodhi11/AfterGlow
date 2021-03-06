defmodule AfterGlow.ColumnTest do
  use AfterGlow.ModelCase

  alias AfterGlow.Column

  @valid_attrs %{name: "some content", type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Column.changeset(%Column{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Column.changeset(%Column{}, @invalid_attrs)
    refute changeset.valid?
  end
end
