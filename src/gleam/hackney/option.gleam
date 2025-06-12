import gleam/list

pub opaque type HackneyRequestOption {
  WithBody(Bool)
  MaxBody(Int)
  StreamTo(Int)
  FollowRedirect(Bool)
  MaxRedirect(Int)
  ForceRedirect(Bool)
  BasicAuth(#(String, String))
  Insecure(Bool)
  CheckoutTimeout(Int)
  ConnectTimeout(Int)
  RecvTimeout(Int)
  // TODO:
  // connect_options
  // ssl_options
  // async
  // path_encode_fun
  // cookie
  // proxy
}

// defaults taken from the hackney repo
pub fn new() -> List(HackneyRequestOption) {
  [
    WithBody(True),
    FollowRedirect(False),
    MaxRedirect(5),
    ForceRedirect(False),
    CheckoutTimeout(8000),
    ConnectTimeout(8000),
    RecvTimeout(5000),
  ]
}

pub fn set_with_body(
  options: List(HackneyRequestOption),
  value: Bool,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        WithBody(_) -> False
        _ -> True
      }
    })

  [WithBody(value), ..new_options]
}

pub fn set_max_body(
  options: List(HackneyRequestOption),
  value: Int,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        MaxBody(_) -> False
        _ -> True
      }
    })

  [MaxBody(value), ..new_options]
}

pub fn set_stream_to(
  options: List(HackneyRequestOption),
  value: Int,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        StreamTo(_) -> False
        _ -> True
      }
    })

  [StreamTo(value), ..new_options]
}

pub fn set_follow_redirect(
  options: List(HackneyRequestOption),
  value: Bool,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        FollowRedirect(_) -> False
        _ -> True
      }
    })

  [FollowRedirect(value), ..new_options]
}

pub fn set_max_redirect(
  options: List(HackneyRequestOption),
  value: Int,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        MaxRedirect(_) -> False
        _ -> True
      }
    })

  [MaxRedirect(value), ..new_options]
}

pub fn set_force_redirect(
  options: List(HackneyRequestOption),
  value: Bool,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        ForceRedirect(_) -> False
        _ -> True
      }
    })

  [ForceRedirect(value), ..new_options]
}

pub fn set_basic_auth(
  options: List(HackneyRequestOption),
  username: String,
  password: String,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        BasicAuth(_) -> False
        _ -> True
      }
    })

  [BasicAuth(#(username, password)), ..new_options]
}

pub fn set_insecure(
  options: List(HackneyRequestOption),
  value: Bool,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        Insecure(_) -> False
        _ -> True
      }
    })

  [Insecure(value), ..new_options]
}

pub fn set_checkout_timeout(
  options: List(HackneyRequestOption),
  value: Int,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        CheckoutTimeout(_) -> False
        _ -> True
      }
    })

  [CheckoutTimeout(value), ..new_options]
}

pub fn set_connect_timeout(
  options: List(HackneyRequestOption),
  value: Int,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        ConnectTimeout(_) -> False
        _ -> True
      }
    })

  [ConnectTimeout(value), ..new_options]
}

pub fn set_recv_timeout(
  options: List(HackneyRequestOption),
  value: Int,
) -> List(HackneyRequestOption) {
  let new_options =
    list.filter(options, fn(x) {
      case x {
        RecvTimeout(_) -> False
        _ -> True
      }
    })

  [RecvTimeout(value), ..new_options]
}
