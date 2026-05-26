import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'upload_picture_event.dart';
part 'upload_picture_state.dart';

class UploadPictureBloc extends Bloc<UploadPictureEvent, UploadPictureState> {
  UploadPictureBloc(this._coffeeRepo) : super(UploadPictureInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        final url = await _coffeeRepo.uploadCoffeeImage(event.file, event.name);
        emit(UploadPictureSuccess(url));
      } catch (error) {
        emit(UploadPictureFailure(_mapUploadError(error)));
      }
    });
  }

  final CoffeeRepo _coffeeRepo;

  String _mapUploadError(Object error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unauthorized':
          return 'Storage từ chối upload. Kiểm tra UID trong admins và storage.rules đã publish.';
        case 'canceled':
          return 'Upload ảnh đã bị hủy.';
        case 'quota-exceeded':
          return 'Firebase Storage đã vượt quota.';
        case 'retry-limit-exceeded':
          return 'Upload quá lâu. Kiểm tra mạng rồi thử lại.';
      }
      return 'Storage lỗi ${error.code}: ${error.message ?? 'không rõ nguyên nhân'}.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }
}
