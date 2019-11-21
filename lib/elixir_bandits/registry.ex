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

  def exists?(%User{} = user) do
    GenServer.call(__MODULE__, {:exists, @users_table, user.username})
  end

  def exists?(session_id) do
    GenServer.call(__MODULE__, {:exists, @scores_table, session_id})
  end

  def get_user(username) do
    case GenServer.call(__MODULE__, {:get, username}) do
      [] -> {:not_found}
      [{^username, password_hash}] -> {:found, password_hash}
    end
  end

  def insert_user(%User{} = user) do
    GenServer.call(__MODULE__, {:insert_user, user})
  end

  def get_score(session_id) do
    case GenServer.call(__MODULE__, {:get_score, session_id}) do
      [] -> {:not_found}
      [{^session_id, score}] -> {:found, score}
    end
  end

  def insert_score(session_id, {_bandit, _payoff} = score) do
    GenServer.cast(__MODULE__, {:insert_score, session_id, score})
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

  def handle_cast({:insert_score, session_id, score}, state) do
    if :ets.insert_new(@scores_table, {session_id, [score]}) do
      :ok
    else
      [{session_id, current_scores}] = :ets.lookup(@scores_table, session_id)
      new_scores = [score | current_scores]
      true = :ets.insert(@scores_table, {session_id, new_scores})
    end

    {:noreply, state}
  end

  def handle_call({:insert_user, user}, _from, state) do
    :ets.insert_new(@users_table, {user.username, user.password_hash})
    {:reply, {:ok, user}, state}
  end

  def handle_call({:exists, table, key}, _from, state) do
    {:reply, :ets.member(table, key), state}
  end
end
