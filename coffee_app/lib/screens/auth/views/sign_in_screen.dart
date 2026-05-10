import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:coffee_app/components/my_text_field.dart';
import 'package:coffee_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    required this.usesFirebase,
    super.key,
  });

  final bool usesFirebase;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool signInRequired = false;
  bool obscurePassword = true;
  String? errorMsg;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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

  void _fillDemoAccount() {
    emailController.text = 'demo@drinkhub.app';
    passwordController.text = 'DrinkHub@123';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
            errorMsg = null;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
            errorMsg = null;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            errorMsg = state.message;
          });
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModeNote(
              usesFirebase: widget.usesFirebase,
              onUseDemo: widget.usesFirebase ? null : _fillDemoAccount,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE8D7C3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chào bạn quay lại',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.usesFirebase
                          ? 'Đăng nhập bằng tài khoản bạn đã đăng ký.'
                          : '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập mật khẩu';
                        }
                        if (!_isValidPassword(value)) {
                          return 'Mật khẩu phải đủ 8 ký tự, gồm hoa, thường, số và ký tự đặc biệt';
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
                    if (errorMsg != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF2EF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF0C4BA)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFF8D3A23),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                errorMsg!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF8D3A23),
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: signInRequired
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  context.read<SignInBloc>().add(
                                        SignInRequired(
                                          emailController.text.trim(),
                                          passwordController.text,
                                        ),
                                      );
                                }
                              },
                        child: signInRequired
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
                                    ? 'Vào app bằng Firebase'
                                    : 'Vào bản demo',
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tip: dùng Ctrl + K / Cmd + K để tìm lại tài khoản demo nhanh hơn.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeNote extends StatelessWidget {
  const _ModeNote({
    required this.usesFirebase,
    this.onUseDemo,
  });

  final bool usesFirebase;
  final VoidCallback? onUseDemo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D7C3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              usesFirebase ? Icons.cloud_outlined : Icons.auto_awesome_rounded,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usesFirebase ? 'Đang dùng Firebase Auth' : 'Tài khoản demo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  usesFirebase
                      ? 'Email và mật khẩu sẽ xác thực trực tiếp với Firebase.'
                      : 'Email: demo@drinkhub.app\nMật khẩu: DrinkHub@123',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                      ),
                ),
                if (onUseDemo != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onUseDemo,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Điền sẵn tài khoản demo'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
