import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/currency_formatter.dart';
import '../../../../uikit/token/index.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.bloc});

  final HistoryBloc bloc;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(const HistoryRequested());
  }

  void _refresh() => widget.bloc.add(const HistoryRequested());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HistoryHeader(
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.radius28),
                  ),
                ),
                child: BlocBuilder<HistoryBloc, HistoryState>(
                  bloc: widget.bloc,
                  builder: (context, state) {
                    switch (state) {
                      case HistoryInitial():
                      case HistoryLoading():
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        );
                      case HistoryError(:final message):
                        return _HistoryErrorView(
                          message: message,
                          onRetry: _refresh,
                        );
                      case HistoryLoaded(:final transactions):
                        if (transactions.isEmpty) {
                          return const _HistoryEmptyView();
                        }
                        return RefreshIndicator(
                          color: AppColor.primary,
                          onRefresh: () async => _refresh(),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.spacing20,
                              vertical: AppSpacing.spacing20,
                            ),
                            itemCount: transactions.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              color: AppColor.neutralAlt,
                            ),
                            itemBuilder: (context, index) {
                              return _HistoryItem(
                                transaction: transactions[index],
                              );
                            },
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing8,
        AppSpacing.spacing8,
        AppSpacing.spacing8,
        AppSpacing.spacing20,
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.10),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing12),
          const Text(
            'History',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.transaction});

  final Transaction transaction;

  String get _formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final local = transaction.transactionDate.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '${local.day} ${months[local.month - 1]} ${local.year}, $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: transaction.isTransfer
                  ? AppColor.primarySoft
                  : AppColor.blueagbFour,
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.isTransfer
                  ? Icons.swap_horiz
                  : Icons.receipt_long_outlined,
              color: AppColor.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.typeLabel,
                  style: AppTextStyle.labelLarge.apply(color: AppColor.neutral),
                ),
                const SizedBox(height: 2),
                Text(
                  _formattedDate,
                  style: AppTextStyle.bodySmall.apply(
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.spacing12),
          Text(
            '${transaction.isTransfer ? '-' : ''}${CurrencyFormatter.idr(transaction.amount)}',
            style: AppTextStyle.labelLarge.apply(
              color: transaction.isTransfer
                  ? AppColor.textSecondary
                  : AppColor.trustPilotGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryEmptyView extends StatelessWidget {
  const _HistoryEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColor.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: AppColor.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            Text(
              'No transactions yet',
              style: AppTextStyle.labelLarge,
            ),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              'Your money moves will appear here',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium.apply(
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryErrorView extends StatelessWidget {
  const _HistoryErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColor.textSecondary,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.spacing16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyLarge.apply(color: AppColor.neutral),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing24,
                  vertical: AppSpacing.spacing10,
                ),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}