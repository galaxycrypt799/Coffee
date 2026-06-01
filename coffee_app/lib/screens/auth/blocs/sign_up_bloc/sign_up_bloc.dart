import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        MyUser myUser =
            await _userRepository.signUp(event.user, event.password);
        await _userRepository.setUserData(myUser);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure(_mapAuthError(e)));
      }
    });
  }

  String _mapAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Email này đã tồn tại.';
        case 'invalid-email':
          return 'Email chưa đúng định dạng.';
        case 'weak-password':
          return 'Mật khẩu còn yếu, hãy tăng độ mạnh.';
        case 'network-request-failed':
          return 'Không thể kết nối mạng để tạo tài khoản.';
      }
    }

    final message = error.toString().replaceFirst('Bad state: ', '');
    return message.isEmpty ? 'Tạo tài khoản thất bại.' : message;
  }
}
