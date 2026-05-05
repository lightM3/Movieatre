extension DateTimeFormatting on DateTime {
  String toTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 7) {
      final months = [
        'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 
        'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
      ];
      return '$day ${months[month - 1]} ${year != now.year ? year : ''}'.trim();
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} gün önce';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
}
