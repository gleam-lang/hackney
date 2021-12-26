import gleam/dynamic.{Dynamic}
import gleam/http.{Method, Request, Response}
import gleam/bit_string
import gleam/bit_builder.{BitBuilder}
import gleam/result
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
  try response =
    request
    |> http.req_to_uri
    |> uri.to_string
    |> ffi_send(request.method, _, request.headers, request.body)
  let headers = list.map(response.headers, normalise_header)
  Ok(Response(..response, headers: headers))
}

pub fn send(req: Request(String)) -> Result(Response(String), Error) {
  try resp =
    req
    |> http.map_req_body(bit_builder.from_string)
    |> send_bits

  case bit_string.to_string(resp.body) {
    Ok(body) -> Ok(http.set_resp_body(resp, body))
    Error(_) -> Error(InvalidUtf8Response)
  }
}

fn normalise_header(header: http.Header) -> http.Header {
  #(string.lowercase(header.0), header.1)
}
