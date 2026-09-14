import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/currency_formatter.dart';
import '../../../../uikit/button/primary_button.dart';
import '../../../../uikit/token/index.dart';
import '../../../../uikit/widget/textfield/index.dart';
import '../bloc/topup_bloc.dart';
import '../bloc/topup_event.dart';
import '../bloc/topup_state.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key, required this.bloc});

  final TopUpBloc bloc;

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _amountController = TextEditingController();

  static const _presets = [50000, 100000, 250000, 500000, 1000000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _amountValue => int.tryParse(_amountController.text) ?? 0;

  bool get _canSubmit => _amountValue > 0;

  void _onSubmit() {
    widget.bloc.add(TopUpSubmitted(amount: _amountValue));
  }

  void _onFieldsChanged() => setState(() {});

  void _applyPreset(int amount) {
    _amountController.text = '$amount';
    _onFieldsChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      body: SafeArea(
        child: BlocBuilder<TopUpBloc, TopUpState>(
          bloc: widget.bloc,
          builder: (context, state) {
            if (state is TopUpSuccess) {
              return _TopUpSuccessView(state: state);
            }
            return _TopUpFormView(
              amountController: _amountController,
              amountValue: _amountValue,
              presets: _presets,
              isSubmitting: state is TopUpSubmitting,
              errorMessage: state is TopUpError ? state.message : null,
              canSubmit: _canSubmit,
              onPresetTap: _applyPreset,
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

class _TopUpFormView extends StatelessWidget {
  const _TopUpFormView({
    required this.amountController,
    required this.amountValue,
    required this.presets,
    required this.isSubmitting,
    required this.errorMessage,
    required this.canSubmit,
    required this.onPresetTap,
    required this.onSubmit,
    required this.onBack,
    required this.onFieldsChanged,
  });

  final TextEditingController amountController;
  final int amountValue;
  final List<int> presets;
  final bool isSubmitting;
  final String? errorMessage;
  final bool canSubmit;
  final ValueChanged<int> onPresetTap;
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
        _TopUpHeader(onBack: onBack),
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
                      Text(
                        'Top up your balance to keep your money moving.',
                        style: AppTextStyle.bodyLarge.apply(
                          color: AppColor.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacing20),
                      const _FieldLabel('Amount'),
                      const SizedBox(height: AppSpacing.spacing8),
                      OutlinedTextField(
                        controller: amountController,
                        hintText: '0',
                        prefixIcon: Icons.paid_outlined,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
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
                      Wrap(
                        spacing: AppSpacing.spacing10,
                        runSpacing: AppSpacing.spacing10,
                        children: [
                          for (final preset in presets)
                            _PresetChip(
                              label:
                                  'Rp ${(preset / 1000).toStringAsFixed(0)}rb',
                              isActive: amountValue == preset,
                              onTap: () => onPresetTap(preset),
                            ),
                        ],
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
                        buttonText: 'Top Up Now',
                        isEnabled: canSubmit && !isSubmitting,
                        onPressed: canSubmit && !isSubmitting
                            ? onSubmit
                            : () {},
                      ),
                      const SizedBox(height: AppSpacing.spacing12),
                      Text(
                        'Funds are added to your balance instantly.',
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

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing14,
          vertical: AppSpacing.spacing10,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColor.primary : AppColor.primarySoft,
          borderRadius: BorderRadius.circular(AppRadius.radius12),
        ),
        child: Text(
          label,
          style: AppTextStyle.labelMedium.apply(
            color: isActive ? Colors.white : AppColor.primary,
          ),
        ),
      ),
    );
  }
}

class _TopUpSuccessView extends StatelessWidget {
  const _TopUpSuccessView({required this.state});

  final TopUpSuccess state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spacing28),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.spacing24),
          Container(
            width: 88,
            height: 88,
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
            'Top Up Successful',
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
                _SuccessRow(
                  label: 'Reference No.',
                  value: state.response.referenceNo.isEmpty
                      ? '—'
                      : state.response.referenceNo,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spacing24),
          PrimaryButton(
            buttonText: 'Done',
            isEnabled: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
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
        Text(
          label,
          style: AppTextStyle.bodyMedium.apply(color: Colors.white70),
        ),
        const SizedBox(width: AppSpacing.spacing12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopUpHeader extends StatelessWidget {
  const _TopUpHeader({required this.onBack});

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
            'Top Up',
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
