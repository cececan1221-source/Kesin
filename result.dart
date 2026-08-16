sealed class Result<T> {
  const Result();
  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;
  T? get valueOrNull => switch (this) {
        Ok(:final value) => value,
        Err() => null,
      };
  String? get errorOrNull => switch (this) {
        Ok() => null,
        Err(:final message) => message,
      };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.message);
  final String message;
}
