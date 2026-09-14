import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/currency_formatter.dart';
import '../../../../uikit/button/primary_button.dart';
import '../../../../uikit/token/index.dart';
import '../../../../uikit/widget/textfield/index.dart';
import '../bloc/transfer_bloc.dart';
import '../bloc/transfer_event.dart';
import '../bloc/transfer_state.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key, required this.bloc});

  final TransferBloc bloc;

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _amountValue => int.tryParse(_amountController.text) ?? 0;

  bool _canSubmit() {
    return _accountController.text.trim().length >= 6 &&
        _amountValue > 0;
  }

  void _onSubmit() {
    widget.bloc.add(
      TransferSubmitted(
        recipientAccount: _accountController.text.trim(),
        amount: _amountValue,
        notes: _notesController.text.trim(),
      ),
    );
  }

  void _onFieldsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      body: SafeArea(
        child: BlocBuilder<TransferBloc, TransferState>(
          bloc: widget.bloc,
          builder: (context, state) {
            if (state is TransferSuccess) {
              return _TransferSuccessView(state: state);
            }
            return _TransferFormView(
              accountController: _accountController,
              amountController: _amountController,
              notesController: _notesController,
              amountValue: _amountValue,
              isSubmitting: state is TransferSubmitting,
              errorMessage: state is TransferError ? state.message : null,
              canSubmit: _canSubmit(),
              onSubmit: _onSubmit,
              onBack: () => Navigator.of(context).pop(),
              onFieldsChanged: _onFieldsChanged,
            );
          },
        ),
      ),
    );
  }
}

class _TransferFormView extends StatelessWidget {
  const _TransferFormView({
    required this.accountController,
    required this.amountController,
    required this.notesController,
    required this.amountValue,
    required this.isSubmitting,
    required this.errorMessage,
    required this.canSubmit,
    required this.onSubmit,
    required this.onBack,
    required this.onFieldsChanged,
  });

  final TextEditingController accountController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final int amountValue;
  final bool isSubmitting;
  final String? errorMessage;
  final bool canSubmit;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final VoidCallback onFieldsChanged;

  String get _amountPreview =>
      amountValue > 0 ? CurrencyFormatter.idr(amountValue.toDouble()) : '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TransferHeader(title: 'Transfer', onBack: onBack),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.radius28),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.spacing24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FieldLabel('Recipient Account'),
                      const SizedBox(height: AppSpacing.spacing8),
                      OutlinedTextField(
                        controller: accountController,
                        hintText: 'Account number',
                        prefixIcon: Icons.account_balance_wallet_outlined,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onTextChanged: (_) => onFieldsChanged(),
                      ),
                      const SizedBox(height: AppSpacing.spacing20),
                      _FieldLabel('Amount'),
                      const SizedBox(height: AppSpacing.spacing8),
                      OutlinedTextField(
                        controller: amountController,
                        hintText: '0',
                        prefixIcon: Icons.paid_outlined,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onTextChanged: (_) => onFieldsChanged(),
                      ),
                      if (_amountPreview.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.spacing8),
                        Text(
                          _amountPreview,
                          style: AppTextStyle.labelMedium.apply(
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.spacing20),
                      _FieldLabel('Notes (optional)'),
                      const SizedBox(height: AppSpacing.spacing8),
                      OutlinedTextField(
                        controller: notesController,
                        hintText: 'e.g. Lunch',
                        prefixIcon: Icons.notes,
                        textInputAction: TextInputAction.done,
                        onTextChanged: (_) => onFieldsChanged(),
                      ),
                      const SizedBox(height: AppSpacing.spacing24),
                      if (errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.spacing12),
                          decoration: BoxDecoration(
                            color: AppColor.redNotif,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius8,
                            ),
                          ),
                          child: Text(
                            errorMessage!,
                            style: AppTextStyle.bodyMedium.apply(
                              color: AppColor.error,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing16),
                      ],
                      PrimaryButton(
                        buttonText: 'Transfer Now',
                        isEnabled: canSubmit && !isSubmitting,
                        onPressed: canSubmit && !isSubmitting ? onSubmit : () {},
                      ),
                      const SizedBox(height: AppSpacing.spacing12),
                      Text(
                        'Transfers are processed securely and instantly.',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bodyMedium.apply(
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSubmitting)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.white.withValues(alpha: 0.6),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyle.labelMedium.apply(color: AppColor.neutral),
    );
  }
}

class _TransferHeader extends StatelessWidget {
  const _TransferHeader({required this.title, required this.onBack});

  final String title;
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
          Text(
            title,
            style: const TextStyle(
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

class _TransferSuccessView extends StatelessWidget {
  const _TransferSuccessView({required this.state});

  final TransferSuccess state;

  String get _maskedAccount {
    final account = state.recipientAccount;
    if (account.length <= 4) return account;
    return '•••• ${account.substring(account.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.primaryDark,
            AppColor.primary,
            AppColor.primaryLight,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.spacing16),
            Align(
              alignment: Alignment.centerLeft,
              child: _TransferHeader(
                title: 'Transfer',
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
            const Spacer(),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColor.trustPilotGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.trustPilotGreen.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            const Text(
              'Transfer Successful',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 24,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing6),
            Text(
              CurrencyFormatter.idr(state.amount.toDouble()),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 32,
                height: 1.1,
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.spacing20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppRadius.radius20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SuccessRow(label: 'To', value: _maskedAccount),
                  const SizedBox(height: AppSpacing.spacing12),
                  _SuccessRow(
                    label: 'Notes',
                    value: state.notes.isEmpty ? '—' : state.notes,
                  ),
                  const SizedBox(height: AppSpacing.spacing12),
                  _SuccessRow(label: 'Reference', value: state.response.referenceNo),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            PrimaryButton(
              buttonText: 'Done',
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: AppSpacing.spacing16),
          ],
        ),
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  const _SuccessRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: AppTextStyle.bodyMedium.apply(color: Colors.white70),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.labelButtonRegular.apply(color: Colors.white),
          ),
        ),
      ],
    );
  }
}