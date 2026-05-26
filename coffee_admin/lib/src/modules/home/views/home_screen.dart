import 'package:coffee_admin/src/utils/price_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../operations/views/revenue_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<RevenueBloc, RevenueState>(
          builder: (context, state) {
            if (state is RevenueLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is RevenueSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildQuickStats(context, state),
                  const SizedBox(height: 20),
                  _buildCharts(context, state),
                  const SizedBox(height: 20),
                  _buildInsightPanels(context, state),
                ],
              );
            }

            if (state is RevenueFailure) {
              return _emptyPanel(
                context,
                title: 'Không thể tải dashboard',
                message: 'Kiểm tra quyền đọc orders và kết nối Firebase.',
              );
            }

            return _emptyPanel(
              context,
              title: 'Coffee Admin',
              message: 'Dashboard đang chờ dữ liệu đơn hàng.',
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng quan hệ thống',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Doanh thu, đơn hàng và món bán chạy',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {
            context
                .read<RevenueBloc>()
                .add(const GetRevenueRequested(forceRefresh: true));
          },
          tooltip: 'Tải lại',
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, RevenueSuccess state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1180
            ? 5
            : constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 560
                    ? 2
                    : 1;
        const gap = 14.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            _statCard(
              context,
              width: width,
              title: 'Hôm nay',
              value: formatVnd(state.today),
              icon: Icons.today_rounded,
              color: Colors.orange,
            ),
            _statCard(
              context,
              width: width,
              title: 'Tháng này',
              value: formatVnd(state.month),
              icon: Icons.calendar_month_rounded,
              color: Colors.blue,
            ),
            _statCard(
              context,
              width: width,
              title: 'Năm nay',
              value: formatVnd(state.year),
              icon: Icons.query_stats_rounded,
              color: Colors.indigo,
            ),
            _statCard(
              context,
              width: width,
              title: 'Đơn hoàn tất',
              value: state.completedOrders.toString(),
              icon: Icons.check_circle_rounded,
              color: Colors.green,
            ),
            _statCard(
              context,
              width: width,
              title: 'Tổng đơn',
              value: state.totalOrders.toString(),
              icon: Icons.receipt_long_rounded,
              color: Colors.deepPurple,
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
    BuildContext context, {
    required double width,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts(BuildContext context, RevenueSuccess state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        final chartWidth =
            isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: chartWidth,
              child: _chartPanel(
                context,
                title: 'Doanh thu 7 ngày',
                child: _buildRevenueChart(
                  state.weeklyRevenue,
                  const ['T-6', 'T-5', 'T-4', 'T-3', 'T-2', 'T-1', 'Nay'],
                  Colors.brown,
                ),
              ),
            ),
            SizedBox(
              width: chartWidth,
              child: _chartPanel(
                context,
                title: 'Doanh thu theo tháng',
                child: _buildRevenueChart(
                  state.monthlyRevenue,
                  const [
                    'T1',
                    'T2',
                    'T3',
                    'T4',
                    'T5',
                    'T6',
                    'T7',
                    'T8',
                    'T9',
                    'T10',
                    'T11',
                    'T12',
                  ],
                  Colors.indigo,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _chartPanel(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(
    List<int> sourceData,
    List<String> labels,
    Color color,
  ) {
    final data = sourceData.isEmpty
        ? List<int>.filled(labels.length, 0)
        : sourceData.take(labels.length).toList(growable: false);
    final maxValue =
        data.fold<int>(0, (max, value) => value > max ? value : max);
    final barWidth = labels.length > 7 ? 10.0 : 18.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxValue == 0 ? 1 : maxValue * 1.2).toDouble(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                formatVnd(rod.toY),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    labels[index],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data[index].toDouble(),
                color: color,
                width: barWidth,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInsightPanels(BuildContext context, RevenueSuccess state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final width =
            isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: width,
              child: _topItemsPanel(context, state.topItems),
            ),
            SizedBox(
              width: width,
              child: _statusPanel(context, state.statusCounts),
            ),
          ],
        );
      },
    );
  }

  Widget _topItemsPanel(BuildContext context, List<TopSellingItem> items) {
    final maxQuantity = items.fold<int>(
      0,
      (max, item) => item.quantity > max ? item.quantity : max,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Món bán chạy',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const Text('Chưa có đơn hoàn tất để thống kê.')
          else
            ...items.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _topItemRow(
                      context,
                      rank: entry.key + 1,
                      item: entry.value,
                      maxQuantity: maxQuantity,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _topItemRow(
    BuildContext context, {
    required int rank,
    required TopSellingItem item,
    required int maxQuantity,
  }) {
    final progress = maxQuantity == 0
        ? 0.0
        : (item.quantity / maxQuantity).clamp(0.0, 1.0).toDouble();

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF2C1B16),
          child: Text(
            rank.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text('${item.quantity} ly'),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFFD8A66A)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatVnd(item.revenue),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusPanel(BuildContext context, Map<String, int> statusCounts) {
    final entries = _orderedStatusEntries(statusCounts);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trạng thái đơn hàng',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          if (entries.isEmpty)
            const Text('Chưa có đơn hàng.')
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: entries
                  .map(
                    (entry) => _statusChip(
                      context,
                      status: entry.key,
                      count: entry.value,
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }

  List<MapEntry<String, int>> _orderedStatusEntries(Map<String, int> counts) {
    const order = <String>[
      'pending',
      'confirmed',
      'preparing',
      'ready',
      'delivered',
      'completed',
      'cancelled',
    ];

    final ordered = <MapEntry<String, int>>[];
    for (final status in order) {
      final count = counts[status];
      if (count != null && count > 0) {
        ordered.add(MapEntry(status, count));
      }
    }

    for (final entry in counts.entries) {
      if (!order.contains(entry.key) && entry.value > 0) {
        ordered.add(entry);
      }
    }
    return ordered;
  }

  Widget _statusChip(
    BuildContext context, {
    required String status,
    required int count,
  }) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Text(
            '${_statusLabel(status)}: $count',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.deepPurple;
      case 'ready':
        return Colors.teal;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ';
      case 'confirmed':
        return 'Đã nhận';
      case 'preparing':
        return 'Đang pha';
      case 'ready':
        return 'Sẵn sàng';
      case 'delivered':
        return 'Đã giao';
      case 'completed':
        return 'Hoàn tất';
      case 'cancelled':
        return 'Huỷ';
      default:
        return status;
    }
  }

  Widget _emptyPanel(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.dashboard_customize_rounded, size: 42),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
