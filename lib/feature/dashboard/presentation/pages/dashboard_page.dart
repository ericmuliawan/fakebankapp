import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/di/service_locator.dart';
import '../../../../common/utils/currency_formatter.dart';
import '../../../../feature/auth/domain/entities/profile.dart';
import '../../../../feature/auth/presentation/bloc/auth_bloc.dart';
import '../../../../feature/auth/presentation/bloc/auth_event.dart';
import '../../../../feature/history/domain/entities/transaction.dart';
import '../../../../feature/history/domain/repositories/history_repository.dart';
import '../../../../feature/history/presentation/bloc/history_bloc.dart';
import '../../../../feature/history/presentation/pages/history_page.dart';
import '../../../../feature/transfer/domain/repositories/transfer_repository.dart';
import '../../../../feature/transfer/presentation/bloc/transfer_bloc.dart';
import '../../../../feature/transfer/presentation/pages/transfer_page.dart';
import '../../../../uikit/token/index.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.bloc,
    required this.authBloc,
  });

  final DashboardBloc bloc;
  final AuthBloc authBloc;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(const DashboardOpened());
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature is coming soon'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColor.primary,
        ),
      );
  }

  Future<void> _onQuickAction(String feature) async {
    switch (feature) {
      case 'Transfer':
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TransferPage(
              bloc: TransferBloc(repository: getIt<ITransferRepository>()),
            ),
          ),
        );
      case 'History':
        await _openHistory();
      default:
        _showComingSoon(feature);
    }
    if (mounted) {
      widget.bloc.add(const DashboardOpened());
    }
  }

  Future<void> _openHistory() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HistoryPage(
          bloc: HistoryBloc(repository: getIt<IHistoryRepository>()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.primaryDark,
          body: SafeArea(
            child: switch (state) {
              DashboardInitial() ||
              DashboardLoading() =>
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              DashboardError(:final message) => _DashboardErrorView(
                  message: message,
                  onRetry: () => widget.bloc.add(const DashboardOpened()),
                ),
              DashboardLoaded(:final profile, :final recentTransactions) =>
                _DashboardContent(
                  profile: profile,
                  recentTransactions: recentTransactions,
                  onLogout: () => widget.authBloc.add(const LogoutRequested()),
                  onQuickAction: _onQuickAction,
                  onOpenHistory: _openHistory,
                ),
            },
          ),
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.profile,
    required this.recentTransactions,
    required this.onLogout,
    required this.onQuickAction,
    required this.onOpenHistory,
  });

  final Profile profile;
  final List<Transaction> recentTransactions;
  final VoidCallback onLogout;
  final ValueChanged<String> onQuickAction;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.primaryDark, AppColor.primary, AppColor.primaryLight],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Header(
              profile: profile,
              onLogout: onLogout,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing24,
                AppSpacing.spacing20,
                0,
              ),
              child: _BalanceCard(profile: profile),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing20),
              child: _QuickActions(onTap: onQuickAction),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                0,
                AppSpacing.spacing20,
                AppSpacing.spacing12,
              ),
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  height: 1.3,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              0,
              AppSpacing.spacing20,
              AppSpacing.spacing32,
            ),
            sliver: SliverToBoxAdapter(
              child: _RecentActivity(
                transactions: recentTransactions,
                onViewAll: onOpenHistory,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile, required this.onLogout});

  final Profile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing20,
        AppSpacing.spacing16,
        AppSpacing.spacing20,
        0,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColor.accent,
            child: Text(
              profile.initials,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good day,',
                  style: AppTextStyle.bodyLarge.apply(color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.firstName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          _HeaderAction(
            icon: Icons.notifications_none,
            onTap: () {},
          ),
          const SizedBox(width: AppSpacing.spacing10),
          _HeaderAction(icon: Icons.logout, onTap: onLogout),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.profile});

  final Profile profile;

  void _copyAccountNumber(BuildContext context) {
    Clipboard.setData(ClipboardData(text: profile.accountNumber));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Account number copied'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColor.primary,
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.accent, AppColor.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppRadius.radius20),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryDark.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: AppTextStyle.bodyLarge.apply(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.spacing6),
          Text(
            CurrencyFormatter.idr(profile.balance),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 30,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing20),
          Divider(color: Colors.white.withValues(alpha: 0.20), height: 1),
          const SizedBox(height: AppSpacing.spacing16),
          Row(
            children: [
              Icon(
                Icons.credit_card,
                color: Colors.white.withValues(alpha: 0.85),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.spacing8),
              Text(
                'Account Number',
                style: AppTextStyle.bodyMedium.apply(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                'FakeBank Digital',
                style: AppTextStyle.bodyMedium.apply(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing8),
          Row(
            children: [
              Expanded(
                child: Text(
                  profile.accountNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Material(
                color: Colors.white.withValues(alpha: 0.15),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _copyAccountNumber(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.copy, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.swap_horiz, 'Transfer'),
      (Icons.add_circle_outline, 'Top Up'),
      (Icons.qr_code_2, 'QR Pay'),
      (Icons.receipt_long, 'History'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.radius20),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryDark.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final (icon, label) in actions)
            Expanded(
              child: _QuickAction(
                icon: icon,
                label: label,
                onTap: () => onTap(label),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.primary, size: 26),
          ),
          const SizedBox(height: AppSpacing.spacing8),
          Text(
            label,
            style: AppTextStyle.labelMedium.apply(color: AppColor.neutral),
          ),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({
    required this.transactions,
    required this.onViewAll,
  });

  final List<Transaction> transactions;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.radius20),
        ),
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
              style: AppTextStyle.bodyMedium.apply(
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.radius20),
      ),
      child: Column(
        children: [
          for (var i = 0; i < transactions.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                indent: AppSpacing.spacing20,
                endIndent: AppSpacing.spacing20,
                color: AppColor.neutralAlt,
              ),
            _RecentActivityItem(transaction: transactions[i]),
          ],
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onViewAll,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing14),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.radius20),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View all history',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 20 / 14,
                    ),
                  ),
                  SizedBox(width: AppSpacing.spacing6),
                  Icon(
                    Icons.chevron_right,
                    color: AppColor.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityItem extends StatelessWidget {
  const _RecentActivityItem({required this.transaction});

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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing20,
        vertical: AppSpacing.spacing14,
      ),
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

class _DashboardErrorView extends StatelessWidget {
  const _DashboardErrorView({required this.message, required this.onRetry});

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
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.spacing16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyLarge.apply(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.white,
                foregroundColor: AppColor.primary,
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