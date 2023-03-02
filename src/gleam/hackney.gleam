import gleam/result

import gleam/dynamic.{Dynamic}
import gleam/http.{Method}
import gleam/http/request.{Request}
import gleam/http/response.{Response}
import gleam/bit_string
import gleam/bit_builder.{BitBuilder}
import gleam/string
import gleam/list
import gleam/uri

pub type Error {
  InvalidUtf8Response
  // TODO: refine error type
  Other(Dynamic)
}

external fn ffi_send(
  Method,
  String,
  List(http.Header),
  BitBuilder,
) -> Result(Response(BitString), Error) =
  "gleam_hackney_ffi" "send"

// TODO: test
pub fn send_bits(
  request: Request(BitBuilder),
) -> Result(Response(BitString), Error) {
  use response <- result.then(
    request
    |> request.to_uri
    |> uri.to_string
    |> ffi_send(request.method, _, request.headers, request.body),
  )
  let headers = list.map(response.headers, normalise_header)
  Ok(Response(..response, headers: headers))
}

pub fn send(req: Request(String)) -> Result(Response(String), Error) {
  use resp <- result.then(
    req
    |> request.map(bit_builder.from_string)
    |> send_bits,
  )

  case bit_string.to_string(resp.body) {
    Ok(body) -> Ok(response.set_body(resp, body))
    Error(_) -> Error(InvalidUtf8Response)
  }
}

fn normalise_header(header: http.Header) -> http.Header {
  #(string.lowercase(header.0), header.1)
}
