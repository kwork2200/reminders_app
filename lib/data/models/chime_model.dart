class Chime {
  final String id;
  final String name;
  final int hour;
  final int minute;
  final bool isPM;
  final Set<int> days; // 0=Sun, 1=Mon, ..., 6=Sat
  final bool soundEnabled;
  final String chimeSound;
  final String vibration;
  final bool speakTime;
  final bool announceBeforeChime;
  final String announceTime;
  final bool voiceNote;
  final bool isEnabled;
  final DateTime createdAt;

  Chime({
    required this.id,
    required this.name,
    required this.hour,
    required this.minute,
    required this.isPM,
    required this.days,
    required this.soundEnabled,
    required this.chimeSound,
    required this.vibration,
    required this.speakTime,
    required this.announceBeforeChime,
    required this.announceTime,
    required this.voiceNote,
    this.isEnabled = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hour': hour,
      'minute': minute,
      'isPM': isPM,
      'days': days.toList(),
      'soundEnabled': soundEnabled,
      'chimeSound': chimeSound,
      'vibration': vibration,
      'speakTime': speakTime,
      'announceBeforeChime': announceBeforeChime,
      'announceTime': announceTime,
      'voiceNote': voiceNote,
      'isEnabled': isEnabled,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory Chime.fromJson(Map<String, dynamic> json) {
    return Chime(
      id: json['id'],
      name: json['name'],
      hour: json['hour'],
      minute: json['minute'],
      isPM: json['isPM'],
      days: Set<int>.from(json['days']),
      soundEnabled: json['soundEnabled'],
      chimeSound: json['chimeSound'],
      vibration: json['vibration'],
      speakTime: json['speakTime'],
      announceBeforeChime: json['announceBeforeChime'],
      announceTime: json['announceTime'],
      voiceNote: json['voiceNote'],
      isEnabled: json['isEnabled'] ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  // Create a copy with updated values
  Chime copyWith({
    String? id,
    String? name,
    int? hour,
    int? minute,
    bool? isPM,
    Set<int>? days,
    bool? soundEnabled,
    String? chimeSound,
    String? vibration,
    bool? speakTime,
    bool? announceBeforeChime,
    String? announceTime,
    bool? voiceNote,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return Chime(
      id: id ?? this.id,
      name: name ?? this.name,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isPM: isPM ?? this.isPM,
      days: days ?? this.days,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      chimeSound: chimeSound ?? this.chimeSound,
      vibration: vibration ?? this.vibration,
      speakTime: speakTime ?? this.speakTime,
      announceBeforeChime: announceBeforeChime ?? this.announceBeforeChime,
      announceTime: announceTime ?? this.announceTime,
      voiceNote: voiceNote ?? this.voiceNote,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get formatted time string
  String get formattedTime {
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = isPM ? 'PM' : 'AM';
    return '$h:${minute.toString().padLeft(2, '0')} $period';
  }

  // Get formatted days string
  String get formattedDays {
    if (days.length == 7) return 'Everyday';
    if (days.length == 5 && !days.contains(0) && !days.contains(6)) return 'Weekdays';
    if (days.length == 2 && days.contains(0) && days.contains(6)) return 'Weekends';
    
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final sortedDays = days.toList()..sort();
    return sortedDays.map((day) => dayNames[day]).join(', ');
  }
}
