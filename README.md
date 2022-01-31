# Hackney

<a href="https://github.com/gleam-lang/hackney/releases"><img src="https://img.shields.io/github/release/gleam-lang/hackney" alt="GitHub release"></a>
<a href="https://discord.gg/Fm8Pwmy"><img src="https://img.shields.io/discord/768594524158427167?color=blue" alt="Discord chat"></a>
![CI](https://github.com/gleam-lang/hackney/workflows/test/badge.svg?branch=main)

Bindings to Erlang's `hackney` HTTP client.

```rust
import gleam/hackney
import gleam/http.{Get}
import gleam/http/request
import gleeunit/should

pub fn main() {
  // Prepare a HTTP request record
  let req = request.new()
    |> request.set_method(Get)
    |> request.set_host("test-api.service.hmrc.gov.uk")
    |> request.set_path("/hello/world")
    |> request.prepend_header("accept", "application/vnd.hmrc.1.0+json")

  // Send the HTTP request to the server
  try resp = hackney.send(req)

  // We get a response record back
  resp.status
  |> should.equal(200)

  resp
  |> http.get_resp_header("content-type")
  |> should.equal(Ok("application/json"))

  resp.body
  |> should.equal("{\"message\":\"Hello World\"}")

  Ok(resp)
}
```

## Installation

```shell
gleam add gleam_hackney
```
