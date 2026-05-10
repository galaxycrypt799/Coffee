// ignore_for_file: deprecated_member_use

import 'package:coffee_app/screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'package:coffee_app/screens/orders/cubit/order_history_cubit.dart';
import 'package:coffee_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_app/utils/price_formatter.dart' as pf;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPaymentMethod = 'cash';
  String _selectedDeliveryOption = 'delivery';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        elevation: 0,
      ),
      body: BlocConsumer<OrderHistoryCubit, OrderHistoryState>(
        listener: (context, orderState) {
          if (orderState.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(orderState.errorMessage!)),
            );
            context.read<OrderHistoryCubit>().clearFeedback();
          }
        },
        builder: (context, orderState) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
          final cart = (state is CartLoaded)
              ? state.cart
              : (state is CartUpdated)
                  ? state.cart
                  : null;

          if (cart == null || cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 56),
                  const SizedBox(height: 16),
                  const Text('Giỏ hàng trống'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Địa chỉ giao hàng
                _buildSectionTitle(context, 'Địa chỉ giao hàng'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Họ và tên',
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _phoneController,
                  hintText: 'Số điện thoại',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _addressController,
                  hintText: 'Địa chỉ giao hàng',
                  icon: Icons.location_on,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Tùy chọn giao hàng
                _buildSectionTitle(context, 'Hình thức giao hàng'),
                const SizedBox(height: 12),
                _buildDeliveryOption('delivery', 'Giao hàng', 'Giao tận nơi trong 30-45 phút'),
                const SizedBox(height: 8),
                _buildDeliveryOption('pickup', 'Lấy tại quán', 'Lấy tại quán trong 15 phút'),
                const SizedBox(height: 24),

                // Phương thức thanh toán
                _buildSectionTitle(context, 'Phương thức thanh toán'),
                const SizedBox(height: 12),
                _buildPaymentMethod('cash', 'Thanh toán tiền mặt', Icons.money),
                const SizedBox(height: 8),
                _buildPaymentMethod('card', 'Thanh toán bằng thẻ', Icons.credit_card),
                const SizedBox(height: 8),
                _buildPaymentMethod('online', 'Chuyển khoản ngân hàng', Icons.account_balance),
                const SizedBox(height: 24),

                // Ghi chú đơn hàng
                _buildSectionTitle(context, 'Ghi chú cho cửa hàng'),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _notesController,
                  hintText: 'Ghi chú (ví dụ: không đường, ít lạnh...)',
                  icon: Icons.note,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Đơn hàng của bạn
                _buildSectionTitle(context, 'Đơn hàng của bạn'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ...cart.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.name} x${item.quantity}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(pf.formatPrice(item.subtotal)),
                              ],
                            ),
                          );
                        }),
                        Divider(color: Colors.grey[300]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tạm tính:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(pf.formatPrice(cart.totalPrice)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phí vận chuyển:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(pf.formatPrice(_selectedDeliveryOption == 'pickup' ? 0 : 20000)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: Colors.grey[300]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tổng cộng:',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                pf.formatPrice(
                                  cart.totalPrice +
                                      (_selectedDeliveryOption == 'pickup' ? 0 : 20000),
                                ),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.brown[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nút thanh toán
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: orderState.isSubmitting
                        ? null
                        : () async {
                            if (!_validateForm()) {
                              return;
                            }

                            final user = context
                                .read<AuthenticationBloc>()
                                .state
                                .user;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Không tìm thấy tài khoản đăng nhập.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final shippingFee =
                                _selectedDeliveryOption == 'pickup'
                                    ? 0
                                    : 20000;

                            final isSuccess = await context
                                .read<OrderHistoryCubit>()
                                .placeOrder(
                                  user: user,
                                  cart: cart,
                                  customerName: _nameController.text.trim(),
                                  customerPhone: _phoneController.text.trim(),
                                  totalPrice: cart.totalPrice + shippingFee,
                                  paymentMethod: _selectedPaymentMethod,
                                  deliveryAddress: _selectedDeliveryOption ==
                                          'pickup'
                                      ? 'Pickup tại quầy'
                                      : _addressController.text.trim(),
                                  notes: _notesController.text.trim().isEmpty
                                      ? null
                                      : _notesController.text.trim(),
                                );

                            if (!context.mounted || !isSuccess) {
                              return;
                            }

                            _showSuccessDialog(
                              context,
                              cart,
                              cart.totalPrice + shippingFee,
                            );
                          },
                    child: orderState.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Xác nhận đơn hàng'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
          );
        },
      ),
    );
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return false;
    }

    if (_selectedDeliveryOption != 'pickup' && _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng')),
      );
      return false;
    }

    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại không hợp lệ')),
      );
      return false;
    }

    return true;
  }

  void _showSuccessDialog(BuildContext context, dynamic cart, double totalPrice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đặt hàng thành công!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã đơn hàng: #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tổng tiền: ${pf.formatPrice(totalPrice)}',
              ),
              const SizedBox(height: 8),
              Text(
                'Phương thức: ${_getPaymentMethodLabel()}',
              ),
              const SizedBox(height: 16),
              Text(
                _selectedDeliveryOption == 'pickup'
                    ? 'Cảm ơn bạn! Vui lòng đến lấy hàng trong 15 phút'
                    : 'Cảm ơn bạn! Chúng tôi sẽ giao hàng trong 30-45 phút',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(const ClearCartEvent());
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/orders',
                  (route) => route.settings.name == '/',
                );
              },
              child: const Text('Xem lịch sử đơn'),
            ),
          ],
        );
      },
    );
  }

  String _getPaymentMethodLabel() {
    switch (_selectedPaymentMethod) {
      case 'cash':
        return 'Tiền mặt';
      case 'card':
        return 'Thẻ tín dụng';
      case 'online':
        return 'Chuyển khoản ngân hàng';
      default:
        return 'Không rõ';
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: maxLines == 1 ? 1 : null,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(String value, String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedDeliveryOption,
        onChanged: (newValue) {
          setState(() => _selectedDeliveryOption = newValue!);
        },
      ),
      onTap: () {
        setState(() => _selectedDeliveryOption = value);
      },
    );
  }

  Widget _buildPaymentMethod(String value, String title, IconData icon) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (newValue) {
          setState(() => _selectedPaymentMethod = newValue!);
        },
      ),
      trailing: Icon(icon),
      onTap: () {
        setState(() => _selectedPaymentMethod = value);
      },
    );
  }
}
