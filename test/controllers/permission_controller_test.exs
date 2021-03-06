defmodule AfterGlow.PermissionControllerTest do
  use AfterGlow.ConnCase

  alias AfterGlow.Permission
  alias AfterGlow.Repo

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, permission_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = get conn, permission_path(conn, :show, permission)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{permission.id}"
    assert data["type"] == "permission"
    assert data["attributes"]["name"] == permission.name
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, permission_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, permission_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "permission",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Permission, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, permission_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "permission",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = put conn, permission_path(conn, :update, permission), %{
      "meta" => %{},
      "data" => %{
        "type" => "permission",
        "id" => permission.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Permission, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = put conn, permission_path(conn, :update, permission), %{
      "meta" => %{},
      "data" => %{
        "type" => "permission",
        "id" => permission.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = delete conn, permission_path(conn, :delete, permission)
    assert response(conn, 204)
    refute Repo.get(Permission, permission.id)
  end

end
