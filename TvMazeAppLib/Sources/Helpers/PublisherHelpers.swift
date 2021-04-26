import Combine
import Dispatch

extension Publisher where Failure == Never {

  public func handleUIChanges<O: AnyObject>(
    on object: O, with handler: @escaping (O) -> (Output) -> Void
  )
    -> AnyCancellable
  {
    receive(on: DispatchQueue.main)
      .sink { [weak object] output in
        guard let object = object else {
          return
        }

        let apply = handler(object)
        apply(output)
      }
  }
}

extension Publisher {
  public func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    map(Result.success)
      .catch { Just(.failure($0)) }
      .eraseToAnyPublisher()
  }
}
