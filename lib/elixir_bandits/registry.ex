defmodule ElixirBandits.Registry do
  use GenServer
  alias ElixirBandits.Accounts.User

  @users_table :users
  @scores_table :scores

  def start_link(opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      [],
      opts
    )
  end

  def get_user(username) do
    case GenServer.call(__MODULE__, {:get, username}) do
      [] -> {:not_found}
      [{_user, password_hash}] -> {:found, password_hash}
    end
  end

  def insert_user(%User{} = user) do
    GenServer.call(__MODULE__, {:set, user})
  end

  def get_score(session_id) do
    case GenServer.call(__MODULE__, {:get_score, session_id}) do
      [] -> {:not_found}
      [{_session_id, score}] -> {:found, score}
    end
  end

  def insert_score(session_id, {_bandit, _payoff} = score) do
    GenServer.call(__MODULE__, {:insert_score, session_id, score})
  end

  # GenServer callbacks

  def init([]) do
    true = Process.register(self(), __MODULE__)
    :ets.new(@users_table, [:named_table, :set, :private])
    :ets.new(@scores_table, [:named_table, :set, :private])

    {:ok, %{}}
  end

  def handle_call({:get, user}, _from, state) do
    results = :ets.lookup(@users_table, user)
    {:reply, results, state}
  end

  def handle_call({:get_score, session_id}, _from, state) do
    results = :ets.lookup(@scores_table, session_id)
    {:reply, results, state}
  end

  def handle_call({:insert_score, session_id, score}, _from, state) do
    scores =
      if :ets.insert_new(@scores_table, {session_id, [score]}) do
        [score]
      else
        [{session_id, current_scores}] = :ets.lookup(@scores_table, session_id)
        new_scores = [score | current_scores]
        true = :ets.insert(@scores_table, {session_id, new_scores})
        new_scores
      end

    {:reply, {:ok, session_id, scores}, state}
  end

  def handle_call({:set, user}, _from, state) do
    true = :ets.insert(@users_table, {user.username, user.password_hash})
    {:reply, {:ok, user}, state}
  end
end
