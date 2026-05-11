import 'package:coffee_app/components/my_text_field.dart';
import 'package:coffee_app/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    required this.usesFirebase,
    super.key,
  });

  final bool usesFirebase;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool signUpRequired = false;
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  String? errorMsg;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  bool _isValidPassword(String value) {
    return RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>\/?"[{\]}\|^]).{8,}$',
    ).hasMatch(value);
  }

  void _updatePasswordHints(String value) {
    setState(() {
      containsUpperCase = value.contains(RegExp(r'[A-Z]'));
      containsLowerCase = value.contains(RegExp(r'[a-z]'));
      containsNumber = value.contains(RegExp(r'[0-9]'));
      containsSpecialChar =
          value.contains(RegExp(r'[!@#\$&*~`)\%\-(_+=;:,.<>\/?"[{\]}\|^]'));
      contains8Length = value.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
            errorMsg = null;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
            errorMsg = null;
          });
        } else if (state is SignUpFailure) {
          setState(() {
            signUpRequired = false;
            errorMsg = state.message;
          });
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo tài khoản mới',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.usesFirebase
                    ? 'Tài khoản sẽ lưu ở Firebase Auth và collection users để bạn tiếp tục mở rộng app.'
                    : 'Tài khoản sẽ lưu local để bạn test flow ngay cả khi chưa cấu hình Firebase.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: nameController,
                hintText: 'Họ tên',
                obscureText: false,
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(Icons.person_outline_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nhập họ tên';
                  }
                  if (value.trim().length > 30) {
                    return 'Tên quá dài';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nhập email';
                  }
                  if (!_isValidEmail(value.trim())) {
                    return 'Email chưa đúng định dạng';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              MyTextField(
                controller: passwordController,
                hintText: 'Mật khẩu',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                textInputAction: TextInputAction.done,
                onChanged: _updatePasswordHints,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nhập mật khẩu';
                  }
                  if (!_isValidPassword(value)) {
                    return 'Mật khẩu chưa đạt đủ điều kiện';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _RuleChip(label: '1 chữ hoa', passed: containsUpperCase),
                  _RuleChip(label: '1 chữ thường', passed: containsLowerCase),
                  _RuleChip(label: '1 số', passed: containsNumber),
                  _RuleChip(
                      label: '1 ký tự đặc biệt', passed: containsSpecialChar),
                  _RuleChip(label: '8+ ký tự', passed: contains8Length),
                ],
              ),
              if (errorMsg != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2EF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0C4BA)),
                  ),
                  child: Text(
                    errorMsg!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF8D3A23),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: signUpRequired
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            final myUser = MyUser(
                              userId: '',
                              email: emailController.text.trim(),
                              name: nameController.text.trim(),
                              hasActiveCart: false,
                            );

                            context.read<SignUpBloc>().add(
                                  SignUpRequired(
                                    myUser,
                                    passwordController.text,
                                  ),
                                );
                          }
                        },
                  child: signUpRequired
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.usesFirebase
                              ? 'Tạo tài khoản '
                              : 'Tạo tài khoản ',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleChip extends StatelessWidget {
  const _RuleChip({
    required this.label,
    required this.passed,
  });

  final String label;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        passed ? const Color(0xFFDFF2E6) : Colors.white.withValues(alpha: 0.95);
    final foregroundColor = passed
        ? const Color(0xFF2A6A3E)
        : Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: passed ? const Color(0xFFB6DFC4) : const Color(0xFFE8D7C3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            passed ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 16,
            color: foregroundColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
