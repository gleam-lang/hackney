import gleam/bit_array
import gleam/bytes_tree.{type BytesTree}
import gleam/dynamic.{type Dynamic}
import gleam/hackney/option.{type HackneyRequestOption}
import gleam/http.{type Method}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response, Response}
import gleam/list
import gleam/result
import gleam/string
import gleam/uri

pub type Error {
  InvalidUtf8Response
  // TODO: refine error type
  Other(Dynamic)
}

@external(erlang, "gleam_hackney_ffi", "send")
fn ffi_send(
  a: Method,
  b: String,
  c: List(http.Header),
  d: BytesTree,
  e: List(HackneyRequestOption),
) -> Result(Response(BitArray), Error)

// TODO: test
pub fn send_bits(
  request: Request(BytesTree),
) -> Result(Response(BitArray), Error) {
  use response <- result.then(
    request
    |> request.to_uri
    |> uri.to_string
    |> ffi_send(request.method, _, request.headers, request.body, option.new()),
  )
  let headers = list.map(response.headers, normalise_header)
  Ok(Response(..response, headers: headers))
}

pub fn send_bits_with_options(
  request: Request(BytesTree),
  options: List(HackneyRequestOption),
) -> Result(Response(BitArray), Error) {
  use response <- result.then(
    request
    |> request.to_uri
    |> uri.to_string
    |> ffi_send(request.method, _, request.headers, request.body, options),
  )
  let headers = list.map(response.headers, normalise_header)
  Ok(Response(..response, headers: headers))
}

pub fn send(req: Request(String)) -> Result(Response(String), Error) {
  use resp <- result.then(
    req
    |> request.map(bytes_tree.from_string)
    |> send_bits,
  )

  case bit_array.to_string(resp.body) {
    Ok(body) -> Ok(response.set_body(resp, body))
    Error(_) -> Error(InvalidUtf8Response)
  }
}

pub fn send_with_options(
  req: Request(String),
  options: List(HackneyRequestOption),
) -> Result(Response(String), Error) {
  let bytes = request.map(req, bytes_tree.from_string)

  use resp <- result.then(send_bits_with_options(bytes, options))

  case bit_array.to_string(resp.body) {
    Ok(body) -> Ok(response.set_body(resp, body))
    Error(_) -> Error(InvalidUtf8Response)
  }
}

fn normalise_header(header: http.Header) -> http.Header {
  #(string.lowercase(header.0), header.1)
}
