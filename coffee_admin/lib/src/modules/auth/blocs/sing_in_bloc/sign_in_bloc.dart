import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this._userRepository) : super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(SignInSuccess());
      } catch (error) {
        emit(SignInFailure(_mapSignInError(error)));
      }
    });

    on<SignOutRequired>((event, emit) async {
      await _userRepository.logOut();
      emit(SignOutSuccess());
    });
  }

  final UserRepository _userRepository;

  String _mapSignInError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
        case 'invalid-email':
          return 'Email hoặc mật khẩu chưa đúng, hoặc tài khoản chưa được tạo trong Firebase Authentication.';
        case 'user-disabled':
          return 'Tài khoản Firebase Auth này đã bị vô hiệu hóa.';
        case 'network-request-failed':
          return 'Không kết nối được Firebase. Kiểm tra mạng và cấu hình Firebase.';
      }
      return 'Firebase Auth từ chối đăng nhập: ${error.code}.';
    }

    if (error is FirebaseException && error.code == 'permission-denied') {
      return 'Firestore từ chối đọc quyền admin. Hãy deploy firestore.rules và kiểm tra admins/{uid}.';
    }

    final message = error.toString().replaceFirst('Bad state: ', '');
    return message.isEmpty ? 'Đăng nhập thất bại.' : message;
  }
}
