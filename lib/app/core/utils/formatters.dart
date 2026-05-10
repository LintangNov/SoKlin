import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Format angka ke format Rupiah: Rp 45.000
  static String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format tanggal ke "10 Jan 2026"
  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  /// Format tanggal lengkap ke "10 Januari 2026, 14:30"
  static String formatDateTimeFull(DateTime date) {
    return DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(date);
  }

  /// Ambil 6 karakter terakhir dari order ID
  static String shortOrderId(String orderId) {
    if (orderId.length <= 6) return orderId.toUpperCase();
    return orderId.substring(orderId.length - 6).toUpperCase();
  }

  /// Format durasi menit ke teks: "45 menit" atau "1 jam 30 menit"
  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes menit';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '$hours jam';
    return '$hours jam $remainingMinutes menit';
  }
}
