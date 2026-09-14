import 'dart:convert';

abstract class ReverbAppEvent {
  const ReverbAppEvent({required this.type, this.channelName, this.createdAt});

  final String type;
  final String? channelName;
  final DateTime? createdAt;

  static ReverbAppEvent? fromRaw({
    String? channelName,
    required dynamic rawData,
  }) {
    final root = asMap(rawData);
    if (root == null) {
      return null;
    }

    final payload = asMap(root['payload']);
    final type = payload?['type']?.toString();

    if (type == null || payload == null) return null;

    return ReverbGenericEvent(
      type: type,
      channelName: channelName,
      createdAt: parseDateTime(payload['created_at']),
      data: payload['data'],
    );
  }

  static Map<String, dynamic>? asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  static DateTime? parseDateTime(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }
}

class ReverbGenericEvent extends ReverbAppEvent {
  const ReverbGenericEvent({
    required super.type,
    this.data,
    super.channelName,
    super.createdAt,
  });

  final dynamic data;
}
