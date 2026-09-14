class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats a double into Indonesian Rupiah, e.g. `Rp 1.000.000`.
  /// Omits the decimal part when it is zero (e.g. `Rp 1.000.000` not `Rp 1.000.000,00`).
  static String idr(double amount) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final hasSign = parts[0].startsWith('-');
    final abs = hasSign ? parts[0].substring(1) : parts[0];
    final fraction = parts[1];

    final buffer = StringBuffer();
    for (var i = 0; i < abs.length; i++) {
      buffer.write(abs[i]);
      final remaining = abs.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }

    final grouped = buffer.toString();
    final value = fraction == '00'
        ? grouped
        : '$grouped,$fraction';

    return 'Rp${hasSign ? '-' : ' '}$value';
  }
}