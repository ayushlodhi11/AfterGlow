defmodule AfterGlow.Table do
  use AfterGlow.Web, :model
  alias AfterGlow.Repo
  alias AfterGlow.Column
  alias AfterGlow.ForeignKey

  schema "tables" do
    field(:name, :string)
    field(:readable_table_name, :string)
    field(:description)
    belongs_to(:database, AfterGlow.Database)
    has_many(:columns, Column, on_delete: :delete_all, on_replace: :delete)

    timestamps()
  end

  def primary_keys(table_id) do
    from(c in Column, where: c.primary_key == true and c.table_id == ^table_id) |> Repo.all()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :readable_table_name, :database_id, :description])
    |> validate_required([:name, :readable_table_name, :database_id])
  end

  def default_preloads do
    [:database, :columns]
  end

  def cache_deletable_associations do
    default_preloads()
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description])
  end

  def insert_foreign_key_columns_in_results(results, %__MODULE__{} = table) do
    fkeys =
      if table do
        table = table |> Repo.preload(:columns)

        column_ids =
          table.columns
          |> Enum.map(fn c -> c.id end)

        foreign_keys =
          from(fk in ForeignKey)
          |> where([fk], fk.column_id in ^column_ids)
          |> or_where([fk], fk.foreign_column_id in ^column_ids)
          |> Repo.all()
          |> Repo.preload(:column)
          |> Repo.preload(:foreign_column)
          |> Enum.map(fn fk ->
            if column_ids |> Enum.member?(fk.column.id) do
              [%{fk.column.name => fk.column.id}]
            else
              [%{fk.foreign_column.name => fk.foreign_column.id}]
            end
          end)
          |> List.flatten()
          |> List.flatten()
          |> Enum.uniq()
          |> Enum.reduce(%{}, fn x, acc -> acc |> Map.merge(x) end)

        primary_keys =
          primary_keys(table.id)
          |> Enum.map(fn col ->
            %{col.name => col.id}
          end)
          |> Enum.reduce(foreign_keys, fn x, acc -> acc |> Map.merge(x) end)
      end

    results
    |> Tuple.insert_at(
      1,
      results
      |> elem(1)
      |> Map.put("foreign_key_columns", fkeys)
    )
    |> Tuple.delete_at(2)
  end

  def insert_foreign_key_columns_in_results(results, table) do
    table = Repo.get(__MODULE__, table["id"])
    insert_foreign_key_columns_in_results(results, table)
  end
end
