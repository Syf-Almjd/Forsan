class UserContactModel {
  final String userID;
  final String name;
  final String email;
  final String phoneNumber;
  final String message;
  final DateTime timestamp;

  UserContactModel({
    required this.userID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.message,
    required this.timestamp,
  });

  // Optional: A method to convert the model to a map (e.g., for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Optional: A method to create the model from a map (e.g., when fetching from Firestore)
  factory UserContactModel.fromJson(Map<String, dynamic> map) {
    return UserContactModel(
      userID: map['userID'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      message: map['message'] ?? "",
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
