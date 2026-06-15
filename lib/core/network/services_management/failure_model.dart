abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class FeatureFailure extends Failure {
  FeatureFailure(String errMessage) : super(errMessage);
}

class FirebaseFailure extends Failure {
  FirebaseFailure(String errMessage) : super(errMessage);
}

class ValidationError extends Failure {
  ValidationError(String errMessage) : super(errMessage);
}
