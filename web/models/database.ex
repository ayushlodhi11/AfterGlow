defmodule AfterGlow.Database do
  use AfterGlow.Web, :model
  alias AfterGlow.Sql.DbConnection
  alias AfterGlow.Async
  alias AfterGlow.SchemaTasks
  alias AfterGlow.CacheWrapper.Repo

  schema "databases" do
    field(:name, :string)
    field(:db_type, :string)
    field(:config, :map)
    field(:last_accessed_at, Ecto.DateTime)
    field(:unique_identifier, Ecto.UUID)
    has_many(:tables, AfterGlow.Table, on_delete: :delete_all, on_replace: :delete)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :db_type, :config])
    |> validate_required([:name, :db_type, :config])
    |> touch_last_accessed_at
  end

  def insert(changeset) do
    response =
      case changeset.errors |> Enum.empty?() do
        true ->
          changeset = Ecto.Changeset.change(changeset, unique_identifier: Ecto.UUID.generate())

          case DbConnection.connection(changeset.changes) do
            {:ok, _} ->
              {:ok, data} = Repo.insert_with_cache(changeset)

            {{:error, error}} ->
              {:error, error}
          end

        false ->
          {:error, changeset}
      end

    # save schema in async
    Async.perform(&SchemaTasks.sync/1, [response |> elem(1)])
    response
  end

  def update(changeset) do
    response =
      case changeset.errors |> Enum.empty?() do
        true ->
          changeset = Ecto.Changeset.change(changeset, unique_identifier: Ecto.UUID.generate())

          {:ok, data} = Repo.update_with_cache(changeset)

          DbConnection.connection(
            data
            |> Map.from_struct()
            |> IO.inspect(label: "changes")
          )

          {:ok, data}

        false ->
          {:error, changeset}
      end

    # save schema in async
    Async.perform(&SchemaTasks.sync/1, [response |> elem(1)])
    response
  end

  def default_preloads do
    [:tables]
  end

  def cache_deletable_associations do
    default_preloads
  end

  defp touch_last_accessed_at(changeset) do
    Ecto.Changeset.change(changeset, last_accessed_at: Ecto.DateTime.utc())
  end
end
