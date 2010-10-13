%%%-------------------------------------------------------------------
%%% File    : rd_sup.erl
%%% Author  : Martin J. Logan <martin@gdubya.botomayo>
%%% @doc The super.
%%%-------------------------------------------------------------------
-module(rd_sup).

-behaviour(supervisor).
%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
         start_link/1
        ]).

%%--------------------------------------------------------------------
%% Internal exports
%%--------------------------------------------------------------------
-export([
         init/1
        ]).

%%--------------------------------------------------------------------
%% Macros
%%--------------------------------------------------------------------
-define(SERVER, ?MODULE).
-define(HEART, heart).

%%--------------------------------------------------------------------
%% Records
%%--------------------------------------------------------------------

%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% @doc Starts the supervisor.
%% @spec start_link(StartArgs) -> {ok, Pid}
%% @end
%%--------------------------------------------------------------------
start_link(_) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Server functions
%%====================================================================
%%--------------------------------------------------------------------
%% @hidden
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}   
%%--------------------------------------------------------------------
init([]) ->
    RestartStrategy    = one_for_one,
    MaxRestarts        = 1000,
    MaxTimeBetRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxTimeBetRestarts},

    % Create the storage for the local parameters; i.e. LocalTypes 
    % and TargetTypes.
    rd_store:new_LPS(),

    ChildSpecs = 
        [ 
          {rd_core,
           {rd_core, start_link, []},
           permanent,
           1000,
           worker,
           [rd_core]},
          {rd_heartbeat,
           {rd_heartbeat, start_link, []},
           transient,
           brutal_kill,
           worker,
           [rd_heartbeat]}
         ],

    {ok, {SupFlags, ChildSpecs}}.





