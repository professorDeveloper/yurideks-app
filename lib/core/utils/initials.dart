abstract final class Initials {
  static String? of(String? name) {
    final String? value = name?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    final List<String> parts = value.split(RegExp(r'\s+'));
    final String first = parts.first.substring(0, 1);
    final String second = parts.length > 1 ? parts[1].substring(0, 1) : '';
    return (first + second).toUpperCase();
  }
}
