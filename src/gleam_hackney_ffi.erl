-module(gleam_hackney_ffi).

-export([send/5]).

send(Method, Url, Headers, Body, Timeout) ->
    Options = [{with_body, true}, {recv_timeout, Timeout}],
    case hackney:request(Method, Url, Headers, Body, Options) of
        {ok, Status, ResponseHeaders, ResponseBody} -> 
            {ok, {response, Status, ResponseHeaders, ResponseBody}};

        {ok, Status, ResponseHeaders} -> 
            {ok, {response, Status, ResponseHeaders, <<>>}};

        {error, Error} -> 
            {error, {other, Error}}
    end.
