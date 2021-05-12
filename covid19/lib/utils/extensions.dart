extension DateTimeUtils on DateTime {
  String simplify() {
    int lastColon = this.toString().lastIndexOf(':');
    return this.toString().substring(0, lastColon);
  }

  String getDateDifference() {
    Duration duration = DateTime.now().difference(this);
    String difference;
    if (duration.inDays > 7) {
      difference = this.toString();
    } else {
      if (duration.inDays > 0) {
        difference =
            "${duration.inDays} day${duration.inDays > 1 ? "s" : ""} ago";
      } else if (duration.inHours > 0) {
        difference =
            "${duration.inHours} hour${duration.inHours > 1 ? "s" : ""} ago";
      } else if (duration.inMinutes > 0) {
        difference =
            "${duration.inMinutes} minute${duration.inMinutes > 1 ? "s" : ""} ago";
      } else if (duration.inSeconds > 0) {
        difference =
            "${duration.inSeconds} second${duration.inSeconds > 1 ? "s" : ""} ago";
      } else {
        difference = this.toString();
      }
    }
    return difference;
  }
}
