import gleam/hackney
import gleam/http.{Get, Head, Options}
import gleam/http/request
import gleam/http/response
import gleam/list
import gleeunit
import gleam/io

pub fn main() {
  // Run the tests
  gleeunit.main()
}

pub fn request_test() {
  let req =
    request.new()
    |> request.set_method(Get)
    |> request.set_host("test-api.service.hmrc.gov.uk")
    |> request.set_path("/hello/world")
    |> request.prepend_header("accept", "application/vnd.hmrc.1.0+json")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("application/json") = response.get_header(resp, "content-type")
  assert "{\"message\":\"Hello World\"}" = resp.body
}

pub fn get_request_discards_body_test() {
  let req =
    request.new()
    |> request.set_method(Get)
    |> request.set_host("api.github.com")
    |> request.set_path("/zen")
    |> request.set_body("This gets dropped")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("text/plain;charset=utf-8") =
    response.get_header(resp, "content-type")
  assert True = resp.body != ""
}

pub fn head_request_discards_body_test() {
  let req =
    request.new()
    |> request.set_method(Head)
    |> request.set_host("postman-echo.com")
    |> request.set_path("/get")
    |> request.set_body("This gets dropped")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("application/json; charset=utf-8") =
    response.get_header(resp, "content-type")
  assert "" = resp.body
}

pub fn options_request_discards_body_test() {
  let req =
    request.new()
    |> request.set_method(Options)
    |> request.set_host("postman-echo.com")
    |> request.set_path("/get")
    |> request.set_body("This gets dropped")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("text/html; charset=utf-8") =
    response.get_header(resp, "content-type")
  assert "GET,HEAD,PUT,POST,DELETE,PATCH" = resp.body
}
