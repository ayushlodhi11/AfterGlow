defmodule AfterGlow.ApiActions do
  alias AfterGlow.ApiActions.ApiAction
  alias AfterGlow.ApiActions.ApiActionLogs
  alias AfterGlow.CacheWrapper.Repo
  import Ecto.Query

  def list_api_actions(ids) do
    from(
      aa in ApiAction,
      where: aa.id in ^ids
    )
    |> Repo.all()
  end

  def get_api_action!(id) do
    Repo.get!(ApiAction, id)
  end

  def create_api_action(attrs \\ %{}) do
    %ApiAction{}
    |> ApiAction.changeset(attrs)
    |> Repo.insert_with_cache()
  end

  def update_api_action(%ApiAction{} = api_action, attrs) do
    api_action
    |> ApiAction.changeset(attrs)
    |> Repo.update_with_cache()
  end

  def delete_api_action!(id) do
    api_action = get_api_action!(id)
    update_api_action(%ApiAction{} = api_action, %{hidden: true})
  end

  def send_request(id, variables, user) do
    api_action = get_api_action!(id)
    send_request(api_action, variables, api_action.open_in_new_tab, user)
  end

  def send_request(%ApiAction{} = api_action, variables, true, user) do
    url = api_action.url |> replace_variables(variables)

    %{status_code: 301, response_body: "redirect", response_headers: nil}
    |> log_args(url, "GET", nil, nil, user.id, variables, api_action.id)
    |> save_log

    %{redirect_url: url}
  end

  def send_request(%ApiAction{} = api_action, variables, false, user) do
    url = api_action.url |> replace_variables(variables)

    headers =
      api_action.headers
      |> Poison.encode!()
      |> replace_variables(variables)
      |> Poison.decode!()
      |> Enum.into([])

    body = api_action.body |> replace_variables(variables)
    method = api_action.method

    make_request(url, method, body || "", headers)
    |> parse_response
    |> log_args(url, method, body, headers, user.id, variables, api_action.id)
    |> save_log
  end

  def replace_variables(nil, _variables), do: nil

  def replace_variables(string, variables) do
    variables
    |> Enum.reduce(string, fn variable, string ->
      variable_name = variable["name"] |> String.trim()

      string
      |> String.replace(~r({{\W*#{variable_name}\W*}}), variable["value"] |> to_string() || "")
    end)
  end

  def make_request(url, method, body, headers) do
    case method |> to_string() do
      "GET" -> HTTPoison.get(url, headers)
      "POST" -> HTTPoison.post(url, body, headers)
      "PUT" -> HTTPoison.put(url, body, headers)
      "PATCH" -> HTTPoison.patch(url, body, headers)
      "DELETE" -> HTTPoison.delete(url, headers)
    end
  end

  def log_args(response, url, method, body, headers, user_id, variables, api_action_id) do
    response
    |> Map.merge(%{
      url: url,
      method: method,
      request_body: body,
      request_headers: (headers || []) |> Enum.into(%{}),
      user_id: user_id,
      variables: variables,
      api_action_id: api_action_id
    })
  end

  def save_log(log_args) do
    ApiActionLogs.save(log_args)
    log_args
  end

  def parse_response(response) do
    case response do
      {:ok, resp} ->
        %{
          status_code: resp.status_code,
          response_body: resp.body,
          response_headers: resp.headers |> Enum.into(%{})
        }

      {:error, resp} ->
        %{status_code: 0, response_body: resp.reason, response_headers: nil}
    end
  end
end
