import gleam/hackney
import gleam/hackney/option
import gleam/http.{Get, Head, Options}
import gleam/http/request
import gleam/http/response
import gleeunit
import qcheck_gleeunit_utils/test_spec

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

  let assert Ok(resp) = hackney.send(req)
  let assert 200 = resp.status
  let assert Ok("application/json") = response.get_header(resp, "content-type")
  let assert "{\"message\":\"Hello World\"}" = resp.body

  let options = option.new()

  let assert Ok(resp) = hackney.send_with_options(req, options)
  let assert 200 = resp.status
  let assert Ok("application/json") = response.get_header(resp, "content-type")
  let assert "{\"message\":\"Hello World\"}" = resp.body
}

pub fn get_request_discards_body_test() {
  let req =
    request.new()
    |> request.set_method(Get)
    |> request.set_host("api.github.com")
    |> request.set_path("/zen")
    |> request.set_body("This gets dropped")

  let assert Ok(resp) = hackney.send(req)
  let assert 200 = resp.status
  let assert Ok("text/plain;charset=utf-8") =
    response.get_header(resp, "content-type")
  let assert True = resp.body != ""

  let options = option.new()

  let assert Ok(resp) = hackney.send_with_options(req, options)
  let assert 200 = resp.status
  let assert Ok("text/plain;charset=utf-8") =
    response.get_header(resp, "content-type")
  let assert True = resp.body != ""
}

pub fn head_request_discards_body_test() {
  let req =
    request.new()
    |> request.set_method(Head)
    |> request.set_host("postman-echo.com")
    |> request.set_path("/get")
    |> request.set_body("This gets dropped")

  let assert Ok(resp) = hackney.send(req)
  let assert 200 = resp.status
  let assert Ok("application/json; charset=utf-8") =
    response.get_header(resp, "content-type")
  let assert "" = resp.body

  let options = option.new()

  let assert Ok(resp) = hackney.send_with_options(req, options)
  let assert 200 = resp.status
  let assert Ok("application/json; charset=utf-8") =
    response.get_header(resp, "content-type")
  let assert "" = resp.body
}

pub fn options_request_discards_body_test() {
  let req =
    request.new()
    |> request.set_method(Options)
    |> request.set_host("postman-echo.com")
    |> request.set_path("/get")
    |> request.set_body("This gets dropped")

  let assert Ok(resp) = hackney.send(req)
  let assert 200 = resp.status
  let assert Ok("text/html; charset=utf-8") =
    response.get_header(resp, "content-type")
  let assert "GET,HEAD,PUT,POST,DELETE,PATCH" = resp.body

  let options = option.new()

  let assert Ok(resp) = hackney.send_with_options(req, options)
  let assert 200 = resp.status
  let assert Ok("text/html; charset=utf-8") =
    response.get_header(resp, "content-type")
  let assert "GET,HEAD,PUT,POST,DELETE,PATCH" = resp.body
}

pub fn request_fails_on_long_response_test_() {
  test_spec.make(fn() {
    let req =
      request.new()
      |> request.set_method(Get)
      |> request.set_host("postman-echo.com")
      |> request.set_path("/delay/5")

    let resp = hackney.send(req)
    let assert Error(_) = resp
  })
}

pub fn request_succeeds_on_long_response_test_() {
  test_spec.make(fn() {
    let req =
      request.new()
      |> request.set_method(Get)
      |> request.set_host("postman-echo.com")
      |> request.set_path("/delay/5")

    let options = option.new() |> option.set_recv_timeout(10_000)

    let assert Ok(resp) = hackney.send_with_options(req, options)
    let assert 200 = resp.status
  })
}
