import gleam/hackney
import gleam/http.{Get, Head, Options}
import gleam/list
import gleeunit
import gleam/io

pub fn main() {
  // Run the tests
  gleeunit.main()
}

pub fn request_test() {
  let req =
    http.default_req()
    |> http.set_method(Get)
    |> http.set_host("test-api.service.hmrc.gov.uk")
    |> http.set_path("/hello/world")
    |> http.prepend_req_header("accept", "application/vnd.hmrc.1.0+json")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("application/json") = http.get_resp_header(resp, "content-type")
  assert "{\"message\":\"Hello World\"}" = resp.body
}

pub fn get_request_discards_body_test() {
  let req =
    http.default_req()
    |> http.set_method(Get)
    |> http.set_host("api.github.com")
    |> http.set_path("/zen")
    |> http.set_req_body("This gets dropped")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("text/plain;charset=utf-8") =
    http.get_resp_header(resp, "content-type")
  assert True = resp.body != ""
}

pub fn head_request_discards_body_test() {
  let req =
    http.default_req()
    |> http.set_method(Head)
    |> http.set_host("postman-echo.com")
    |> http.set_path("/get")
    |> http.set_req_body("This gets dropped")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("application/json; charset=utf-8") =
    http.get_resp_header(resp, "content-type")
  assert "" = resp.body
}

pub fn options_request_discards_body_test() {
  let req =
    http.default_req()
    |> http.set_method(Options)
    |> http.set_host("postman-echo.com")
    |> http.set_path("/get")
    |> http.set_req_body("This gets dropped")

  assert Ok(resp) = hackney.send(req)
  assert 200 = resp.status
  assert Ok("text/html; charset=utf-8") =
    http.get_resp_header(resp, "content-type")
  assert "GET,HEAD,PUT,POST,DELETE,PATCH" = resp.body
}
