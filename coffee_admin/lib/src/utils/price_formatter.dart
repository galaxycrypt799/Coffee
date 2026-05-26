String formatVnd(num amount) {
  final rounded = amount.round().toString();
  final buffer = StringBuffer();

  for (var index = 0; index < rounded.length; index++) {
    final reverseIndex = rounded.length - index;
    buffer.write(rounded[index]);

    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${buffer.toString()}đ';
}
