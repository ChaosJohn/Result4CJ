package Result4CJ

public enum Result<T> {
    | Success(T)
    | Failure(Exception)

    public static func success(value: T): Result<T> {
        return Success(value)
    }

    public static func failure(exception: Exception): Result<T> {
        return Failure(exception)
    }

    public static func of(input: ?T): Result<T> {
        return match (input) {
            case Some(value) => Success(value)
            case None => Failure(NoneValueException("Value is None"))
        }
    }

    public static func of(fn: () -> ?T): Result<T> {
        return try {
            of(fn())
        } catch (e: Exception) {
            Failure(e)
        } catch (e: Error) {
            Failure(Exception("Error: ${e.message}"))
        }
    }

    public func isSuccess(): Bool {
        return match (this) {
            case Success(_) => true
            case Failure(_) => false
        }
    }

    public func isFailure(): Bool {
        return match (this) {
            case Success(_) => false
            case Failure(_) => true
        }
    }

    public func onSuccess(fn: (T) -> Unit): Result<T> {
        match (this) {
            case Success(value) => fn(value)
            case Failure(_) => ()
        }
        return this
    }

    public func onFailure(fn: (Exception) -> Unit): Result<T> {
        match (this) {
            case Success(_) => ()
            case Failure(e) => fn(e)
        }
        return this
    }

    public func map<U>(transform: (T) -> U): Result<U> {
        return try {
          match (this) {
              case Success(value) => Success(transform(value))
              case Failure(e) => Failure(e)
          }
        } catch (e: Exception) {
            Failure(e)
        } catch (e: Error) {
            Failure(Exception("Error: ${e.message}"))
        }
    }

    public func flatMap<U>(transform: (T) -> Result<U>): Result<U> {
        return try {
          match (this) {
              case Success(value) => transform(value)
              case Failure(e) => Failure(e)
          }
        } catch (e: Exception) {
            Failure(e)
        } catch (e: Error) {
            Failure(Exception("Error: ${e.message}"))
        }
    }
}
