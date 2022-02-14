abstract class ApiResult<T> {}

class Success<T> extends ApiResult<T> {
  final T value;
  Success(this.value);
}

class Error<T> extends ApiResult<T> {
  final Exception exception;
  Error(this.exception);
}
