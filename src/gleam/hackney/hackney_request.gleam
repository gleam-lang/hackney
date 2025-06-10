import gleam/http/request.{type Request}
import gleam/list

pub type HackneyRequest(body) {
  HackneyRequest(request: Request(body), options: List(HackneyRequestOption))
}

pub type HackneyRequestOption {
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

pub fn new_request(req: Request(a)) -> HackneyRequest(a) {
  HackneyRequest(req, default_options())
}

pub fn with_body(req: HackneyRequest(a), value: Bool) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        WithBody(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [WithBody(value), ..new_options])
}

pub fn max_body(req: HackneyRequest(a), value: Int) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        MaxBody(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [MaxBody(value), ..new_options])
}

pub fn stream_to(req: HackneyRequest(a), value: Int) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        StreamTo(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [StreamTo(value), ..new_options])
}

pub fn follow_redirect(req: HackneyRequest(a), value: Bool) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        FollowRedirect(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [FollowRedirect(value), ..new_options])
}

pub fn max_redirect(req: HackneyRequest(a), value: Int) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        MaxRedirect(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [MaxRedirect(value), ..new_options])
}

pub fn force_redirect(req: HackneyRequest(a), value: Bool) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        ForceRedirect(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [ForceRedirect(value), ..new_options])
}

pub fn basic_auth(
  req: HackneyRequest(a),
  username: String,
  password: String,
) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        BasicAuth(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [
    BasicAuth(#(username, password)),
    ..new_options
  ])
}

pub fn insecure(req: HackneyRequest(a), value: Bool) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        Insecure(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [Insecure(value), ..new_options])
}

pub fn checkout_timeout(req: HackneyRequest(a), value: Int) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        CheckoutTimeout(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [CheckoutTimeout(value), ..new_options])
}

pub fn connect_timeout(req: HackneyRequest(a), value: Int) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        ConnectTimeout(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [ConnectTimeout(value), ..new_options])
}

pub fn recv_timeout(req: HackneyRequest(a), value: Int) -> HackneyRequest(a) {
  let new_options =
    list.filter(req.options, fn(x) {
      case x {
        RecvTimeout(_) -> False
        _ -> True
      }
    })

  HackneyRequest(..req, options: [RecvTimeout(value), ..new_options])
}

// defaults taken from the hackney repo
pub fn default_options() -> List(HackneyRequestOption) {
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
