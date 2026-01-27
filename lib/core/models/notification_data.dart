class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String type; // 'alert', 'task', 'achievement', 'community'
  final String icon;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
  });

  static List<NotificationItem> mockNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: 1,
        title: 'Water Level Critical',
        message: 'Groundwater level has dropped below 130 ft. Take action soon.',
        type: 'alert',
        icon: 'Icons.warning_rounded',
        timestamp: now,
        isRead: false,
      ),
      NotificationItem(
        id: 2,
        title: 'New Daily Task Available',
        message: 'Check pump valves for leaks - Earn 100 points',
        type: 'task',
        icon: 'Icons.assignment_rounded',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: 3,
        title: 'Achievement Unlocked!',
        message: 'You\'ve reached Level 6! Keep up the conservation efforts.',
        type: 'achievement',
        icon: 'Icons.emoji_events_rounded',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationItem(
        id: 4,
        title: 'Community Update',
        message: 'Rampur Village now has 2,500+ members. Join the movement!',
        type: 'community',
        icon: 'Icons.people_rounded',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: 5,
        title: 'Water Quality Alert',
        message: 'pH level slightly elevated. Regular monitoring recommended.',
        type: 'alert',
        icon: 'Icons.water_drop_rounded',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: 6,
        title: 'Task Completed',
        message: 'Great job! You\'ve completed 5 tasks this week. +500 points earned.',
        type: 'achievement',
        icon: 'Icons.check_circle_rounded',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationItem(
        id: 7,
        title: 'Rainfall Expected',
        message: '20-25mm of rainfall predicted in the next 3 days.',
        type: 'alert',
        icon: 'Icons.cloud_queue_rounded',
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
      NotificationItem(
        id: 8,
        title: 'Leaderboard Update',
        message: 'You\'ve moved up to rank 10! Keep earning points.',
        type: 'community',
        icon: 'Icons.trending_up_rounded',
        timestamp: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),
    ];
  }
}
