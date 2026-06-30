abstract class DateFormatter {
  static String formatTime(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    final local = date.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  static String formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate)?.toLocal();
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(messageDay).inDays;

    if (diff == 0) return 'Сегодня';
    if (diff == 1) return 'Вчера';

    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  static bool isDifferentDay(String? prev, String? curr) {
    if (prev == null || curr == null) return true;
    final a = DateTime.tryParse(prev)?.toLocal();
    final b = DateTime.tryParse(curr)?.toLocal();
    if (a == null || b == null) return false;
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }
}
