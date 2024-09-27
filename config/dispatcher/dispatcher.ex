defmodule Dispatcher do
  use Matcher

  define_accept_types [
    html: ["text/html", "application/xhtml+html"],
    json: ["application/json", "application/vnd.api+json"],
    upload: ["multipart/form-data"],
    sparql: [ "application/sparql-results+json" ],
    any: [ "*/*" ],
  ]

  define_layers [ :api, :frontend, :not_found]

  options "/*path", _ do
    conn
    |> Plug.Conn.put_resp_header( "access-control-allow-headers", "content-type,accept" )
    |> Plug.Conn.put_resp_header( "access-control-allow-methods", "*" )
    |> send_resp( 200, "{ \"message\": \"ok\" }" )
  end

  ###############
  # SPARQL
  ###############
  match "/sparql", %{ layer: :api, accept: %{ sparql: true } } do
    forward conn, [], "http://db:8890/sparql"
  end

  ###############################################################
  # login specific
  ###############################################################
  match "/m2msessions/*path", %{ accept: %{any: true}, layer: :api} do
    Proxy.forward conn, path, "http://m2m/sessions/"
  end

   ###############################################################
  # errors
  ###############################################################
  match "/*_path", %{ accept: %{any: true}, layer: :not_found} do
    send_resp( conn, 404, "{\"error\": {\"code\": 404}")
  end


end
