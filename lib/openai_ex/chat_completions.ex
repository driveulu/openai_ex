defmodule OpenaiEx.Chat.Completions do
  @moduledoc """
  This module provides an implementation of the OpenAI chat completions API. The API reference can be found at https://platform.openai.com/docs/api-reference/chat/completions.
  """
  @api_fields [
    :messages,
    :model,
    :frequency_penalty,
    :logit_bias,
    :logprobs,
    :max_tokens,
    :n,
    :presence_penalty,
    :response_format,
    :seed,
    :stop,
    :temperature,
    :top_p,
    :top_logprobs,
    :tools,
    :tool_choice,
    :user
  ]

  @doc """
  Creates a new chat completion request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the chat completion request.

  ## Returns

  A map containing the fields of the chat completion request.

  The `:model` and `:messages` fields are required. The `:messages` field should be a list of maps with the `OpenaiEx.ChatMessage` structure.

  Example usage:

      iex> _request = OpenaiEx.Chat.Completions.new(model: "davinci", messages: [OpenaiEx.ChatMessage.user("Hello, world!")])
      %{messages: [%{content: "Hello, world!", role: "user"}], model: "davinci"}

      iex> _request = OpenaiEx.Chat.Completions.new(%{model: "davinci", messages: [OpenaiEx.ChatMessage.user("Hello, world!")]})
      %{messages: [%{content: "Hello, world!", role: "user"}], model: "davinci"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: _, messages: _}) do
    args |> Map.take(@api_fields)
  end

  @ep_url "/chat/completions"

  @doc """
  Calls the chat completion 'create' endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `chat_completion`: The chat completion request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/chat/completions/create for more information.
  """
  def create(openai = %OpenaiEx{}, chat_completion = %{}, stream: true) do
    ep = Map.get(openai, :_ep_path_mapping).(@ep_url)

    openai
    |> OpenaiEx.HttpSse.post(ep,
      json: chat_completion |> Map.take(@api_fields) |> Map.put(:stream, true)
    )
  end

  def create(openai = %OpenaiEx{}, chat_completion = %{}) do
    ep = Map.get(openai, :_ep_path_mapping).(@ep_url)

    openai
    |> OpenaiEx.Http.post(ep, json: chat_completion |> Map.take(@api_fields))
  end
end
