public func with<A>(_ object: A, apply: (inout A) -> Void) -> A {
  var copy = object
  apply(&copy)
  return copy
}
