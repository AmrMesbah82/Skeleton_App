sealed class AccountStatusState {}

final class AccountStatusInitial extends AccountStatusState {}

final class AccountStatusLoaded extends AccountStatusState {}

final class AccountStatusLoading extends AccountStatusState {}

final class AccountStatusError extends AccountStatusState {
  final String message;
  AccountStatusError(this.message);
}