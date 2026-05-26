import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(this._userRepository) : super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(SignInSuccess());
      } catch (e) {
        emit(SignInFailure(_mapAuthError(e)));
      }
    });

    on<SignOutRequired>((event, emit) async {
      await _userRepository.logOut();
      emit(SignOutSuccess());
    });
  }

  String _mapAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
        case 'invalid-email':
          return 'Email hoặc mật khẩu chưa đúng.';
        case 'user-disabled':
          return 'Tài khoản này đã bị vô hiệu hóa trên Firebase Auth.';
        case 'network-request-failed':
          return 'Không thể kết nối mạng để đăng nhập Firebase.';
      }
    }

    final message = error.toString().replaceFirst('Bad state: ', '');
    return message.isEmpty ? 'Đăng nhập thất bại.' : message;
  }
}
