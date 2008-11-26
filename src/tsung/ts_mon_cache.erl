%%%  This program is free software; you can redistribute it and/or modify
%%%  it under the terms of the GNU General Public License as published by
%%%  the Free Software Foundation; either version 2 of the License, or
%%%  (at your option) any later version.
%%%
%%%  This program is distributed in the hope that it will be useful,
%%%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%%%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%%  GNU General Public License for more details.
%%%
%%%  You should have received a copy of the GNU General Public License
%%%  along with this program; if not, write to the Free Software
%%%  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
%%%
%%%  In addition, as a special exception, you have the permission to
%%%  link the code of this program with any library released under
%%%  the EPL license and distribute linked combinations including
%%%  the two.

%%%-------------------------------------------------------------------
%%% File    : ts_session_cache.erl
%%% Author  : Nicolas Niclausse <nniclausse@niclux.org>
%%% Description : cache sessions request from ts_config_server
%%%
%%% Created :  2 Dec 2003 by Nicolas Niclausse <nicolas@niclux.org>
%%%-------------------------------------------------------------------


-module(ts_mon_cache).

-behaviour(gen_server).
%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% External exports
-export([start/0, add/1, add_match/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).


-record(state, {
          stats=[],  % cache stats msgs
          match=[]   % cache match logs
         }).

-define(DUMP_STATS_INTERVAL, 500). % in milliseconds

-include("ts_profile.hrl").

%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start() ->
    ?LOG("Starting~n",?INFO),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%--------------------------------------------------------------------
%% Function: add/1
%% Description: Add stats data. Will be accumulated sent periodically
%%              to ts_mon
%%--------------------------------------------------------------------
add(Data) ->
    gen_server:cast(?MODULE, {add, Data}).

%% @spec add_match(Data::list(),{UserId::integer(),SessionId::integer(),RequestId::integer(),
%%                  TimeStamp::tuple()}) -> ok
add_match(Data,{UserId,SessionId,RequestId,TimeStamp}) ->
    gen_server:cast(?MODULE, {add_match, Data, {UserId,SessionId,RequestId,TimeStamp}}).

%%====================================================================
%% Server functions
%%====================================================================

%%--------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%%--------------------------------------------------------------------
init([]) ->
    erlang:start_timer(?DUMP_STATS_INTERVAL, self(), dump_stats ),
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_cast({add, Data}, State=#state{stats=List}) when is_list(Data) ->
    {noreply, State#state{stats = lists:append(Data, List)} };
handle_cast({add, Data}, State=#state{stats=List}) when is_tuple(Data) ->
    {noreply, State#state{stats = lists:append([Data], List)} };
handle_cast({add_match, Data=[First|_Tail],{UserId,SessionId,RequestId,TimeStamp}},
            State=#state{stats=List, match=MatchList})->
    NewMatchList=lists:append([{UserId,SessionId,RequestId,TimeStamp,First}], MatchList),
    {noreply, State#state{stats = lists:append(Data, List), match = NewMatchList}};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_info({timeout, _Ref, dump_stats}, State = #state{stats =[]}) ->
    erlang:start_timer(?DUMP_STATS_INTERVAL, self(), dump_stats ),
    {noreply, State};

handle_info({timeout, _Ref, dump_stats}, State =#state{stats= Stats, match=MatchList}) ->
    ts_stats_mon:add(Stats),
    ts_match_logger:add(MatchList),
    erlang:start_timer(?DUMP_STATS_INTERVAL, self(), dump_stats ),
    {noreply, State#state{stats=[],match=[]}};

handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%%--------------------------------------------------------------------
terminate(Reason, _State) ->
    ?LOGF("Die ! (~p)~n",[Reason],?ERR),
    ok.

%%--------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
