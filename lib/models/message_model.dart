class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final String timestamp;
  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Message copyWith({
    String? senderId,
    String? receiverId,
    String? message,
    String? timestamp,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as String,
    );
  }

  @override
  String toString() {
    return 'Message(senderId: $senderId, receiverId: $receiverId, message: $message, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;
  
    return 
      other.senderId == senderId &&
      other.receiverId == receiverId &&
      other.message == message &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
      receiverId.hashCode ^
      message.hashCode ^
      timestamp.hashCode;
  }
}
