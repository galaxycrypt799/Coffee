import 'package:coffee_admin/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_admin/src/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

import '../blocs/users_list_bloc/users_list_bloc.dart';
import 'order.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: BlocBuilder<UsersListBloc, UsersListState>(
        builder: (context, state) {
          if (state is UsersListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersListFailure) {
            return _FailureView(
              message: state.error,
              onRetry: () {
                context.read<UsersListBloc>().add(const FetchUsersRequested());
              },
            );
          }

          if (state is UsersListSuccess) {
            final users = _filterUsers(state.users);
            final currentUserId =
                context.read<AuthenticationBloc>().state.user?.userId ?? '';

            return RefreshIndicator(
              onRefresh: () async {
                context.read<UsersListBloc>().add(const FetchUsersRequested());
              },
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _Header(
                    searchController: _searchController,
                    onSearchChanged: (value) {
                      setState(() => _query = value.trim().toLowerCase());
                    },
                    onRefresh: () {
                      context
                          .read<UsersListBloc>()
                          .add(const FetchUsersRequested());
                    },
                  ),
                  const SizedBox(height: 20),
                  _SummaryRow(state: state),
                  const SizedBox(height: 20),
                  if (users.isEmpty)
                    const _EmptyUsers()
                  else
                    _UsersTable(
                      users: users,
                      state: state,
                      currentUserId: currentUserId,
                      onEdit: (user) => _showEditUserDialog(context, user),
                      onDetails: (user) => _showUserDetails(
                        context,
                        user,
                        state.userOrders[user.userId] ?? const <Order>[],
                        state.adminUserIds.contains(user.userId),
                      ),
                      onRoleChanged: (user, isAdmin) => _confirmRoleChange(
                        context,
                        user,
                        isAdmin,
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(child: Text('Đang tải danh sách người dùng...'));
        },
      ),
    );
  }

  List<MyUser> _filterUsers(List<MyUser> users) {
    if (_query.isEmpty) {
      return users;
    }

    return users.where((user) {
      final haystack =
          '${user.name} ${user.email} ${user.userId}'.toLowerCase();
      return haystack.contains(_query);
    }).toList(growable: false);
  }

  Future<void> _showEditUserDialog(BuildContext context, MyUser user) async {
    final nameController = TextEditingController(text: user.name);
    var selectedRank = _rankLabels.containsKey(user.membershipRank)
        ? user.membershipRank
        : 'bronze';
    var hasActiveCart = user.hasActiveCart;

    final updatedUser = await showDialog<MyUser>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Cập nhật người dùng'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên hiển thị',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedRank,
                      decoration: const InputDecoration(
                        labelText: 'Hạng thành viên',
                        border: OutlineInputBorder(),
                      ),
                      items: _rankLabels.entries
                          .map(
                            (entry) => DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setDialogState(() => selectedRank = value);
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: hasActiveCart,
                      title: const Text('Đang có giỏ hàng hoạt động'),
                      onChanged: (value) {
                        setDialogState(() => hasActiveCart = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Hủy'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      return;
                    }
                    Navigator.pop(
                      dialogContext,
                      user.copyWith(
                        name: name,
                        membershipRank: selectedRank,
                        hasActiveCart: hasActiveCart,
                      ),
                    );
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();

    if (updatedUser == null || !context.mounted) {
      return;
    }

    context.read<UsersListBloc>().add(UpdateUserRequested(updatedUser));
  }

  Future<void> _confirmRoleChange(
    BuildContext context,
    MyUser user,
    bool isAdmin,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isAdmin ? 'Cấp quyền admin?' : 'Gỡ quyền admin?'),
        content: Text(
          isAdmin
              ? 'Tài khoản ${user.email} sẽ có quyền quản trị hệ thống.'
              : 'Tài khoản ${user.email} sẽ không thể truy cập admin app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    context.read<UsersListBloc>().add(
          SetUserAdminRoleRequested(
            userId: user.userId,
            isAdmin: isAdmin,
          ),
        );
  }

  void _showUserDetails(
    BuildContext context,
    MyUser user,
    List<Order> orders,
    bool isAdmin,
  ) {
    final totalSpent = _effectiveTotalSpent(user, orders);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(user.name),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Email', value: user.email),
                _DetailRow(label: 'UID', value: user.userId),
                _DetailRow(label: 'Vai trò', value: isAdmin ? 'Admin' : 'User'),
                _DetailRow(
                  label: 'Hạng',
                  value:
                      _rankLabels[user.membershipRank] ?? user.membershipRank,
                ),
                _DetailRow(label: 'Số đơn', value: orders.length.toString()),
                _DetailRow(label: 'Tổng chi', value: formatVnd(totalSpent)),
                const SizedBox(height: 18),
                Text(
                  'Đơn hàng gần đây',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                if (orders.isEmpty)
                  const Text('Chưa có đơn hàng.')
                else
                  ...orders.take(8).map(_OrderPreview.new),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.searchController,
    required this.onSearchChanged,
    required this.onRefresh,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final searchField = SizedBox(
          width: isWide ? 360 : double.infinity,
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Tìm theo tên, email hoặc UID',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        );

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quản lý người dùng',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cập nhật hồ sơ, xem lịch sử đơn và quản lý quyền admin.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 14),
              searchField,
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton.filledTonal(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: title),
            searchField,
            const SizedBox(width: 10),
            IconButton.filledTonal(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.state});

  final UsersListSuccess state;

  @override
  Widget build(BuildContext context) {
    final totalOrders = state.userOrders.values.fold<int>(
      0,
      (sum, orders) => sum + orders.length,
    );
    final totalSpent = state.users.fold<double>(
      0,
      (sum, user) =>
          sum +
          _effectiveTotalSpent(
            user,
            state.userOrders[user.userId] ?? const <Order>[],
          ),
    );

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _SummaryCard(label: 'Users', value: state.users.length.toString()),
        _SummaryCard(
            label: 'Admins', value: state.adminUserIds.length.toString()),
        _SummaryCard(label: 'Orders', value: totalOrders.toString()),
        _SummaryCard(label: 'Total spent', value: formatVnd(totalSpent)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7D3BD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _UsersTable extends StatelessWidget {
  const _UsersTable({
    required this.users,
    required this.state,
    required this.currentUserId,
    required this.onEdit,
    required this.onDetails,
    required this.onRoleChanged,
  });

  final List<MyUser> users;
  final UsersListSuccess state;
  final String currentUserId;
  final ValueChanged<MyUser> onEdit;
  final ValueChanged<MyUser> onDetails;
  final void Function(MyUser user, bool isAdmin) onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Người dùng')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Đơn')),
          DataColumn(label: Text('Tổng chi')),
          DataColumn(label: Text('Hạng')),
          DataColumn(label: Text('Admin')),
          DataColumn(label: Text('Thao tác')),
        ],
        rows: users.map((user) {
          final orders = state.userOrders[user.userId] ?? const <Order>[];
          final totalSpent = _effectiveTotalSpent(user, orders);
          final isAdmin = state.adminUserIds.contains(user.userId);
          final isCurrentUser = user.userId == currentUserId;

          return DataRow(
            cells: [
              DataCell(Text(user.name)),
              DataCell(Text(user.email)),
              DataCell(Text(orders.length.toString())),
              DataCell(Text(formatVnd(totalSpent))),
              DataCell(_MembershipBadge(rank: user.membershipRank)),
              DataCell(
                Switch(
                  value: isAdmin,
                  onChanged: isCurrentUser
                      ? null
                      : (value) => onRoleChanged(user, value),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Chi tiết',
                      onPressed: () => onDetails(user),
                      icon: const Icon(Icons.visibility_outlined),
                    ),
                    IconButton(
                      tooltip: 'Sửa',
                      onPressed: () => onEdit(user),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _MembershipBadge extends StatelessWidget {
  const _MembershipBadge({required this.rank});

  final String rank;

  @override
  Widget build(BuildContext context) {
    final color = switch (rank) {
      'silver' => Colors.blueGrey,
      'gold' => Colors.amber.shade700,
      'platinum' => Colors.indigo,
      _ => Colors.brown,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _rankLabels[rank] ?? 'Bronze',
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _OrderPreview extends StatelessWidget {
  const _OrderPreview(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE7D3BD)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn #${_shortId(order.id)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatVnd(order.totalPrice)),
              const SizedBox(height: 4),
              Text(order.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Không thể tải người dùng',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(message),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Thử lại'),
        ),
        const SizedBox(height: 18),
        const Text(
          'Kiểm tra Firestore rules và đảm bảo UID hiện tại có document trong collection admins.',
        ),
      ],
    );
  }
}

class _EmptyUsers extends StatelessWidget {
  const _EmptyUsers();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7D3BD)),
      ),
      child: const Text('Không tìm thấy người dùng phù hợp.'),
    );
  }
}

double _effectiveTotalSpent(MyUser user, List<Order> orders) {
  final orderTotal = orders.fold<double>(
    0,
    (sum, order) => sum + order.totalPrice,
  );
  return orderTotal > user.totalSpent ? orderTotal : user.totalSpent;
}

String _shortId(String value) {
  if (value.length <= 8) {
    return value;
  }
  return value.substring(0, 8);
}

const Map<String, String> _rankLabels = {
  'bronze': 'Bronze',
  'silver': 'Silver',
  'gold': 'Gold',
  'platinum': 'Platinum',
};
