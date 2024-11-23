class Account {
  String? id;
  final String accountUsername;
  final bool isVerified;
  final String verificationToken;
  final DateTime tokenExpiresAt;
  final String accountPassword;
  final int accountAuthority;
  final String? accountAvatar;
  final String personId;
  final bool isDeleted;
  final DateTime updateAt;
  final DateTime createAt;

  Account({
    this.id,
    required this.accountUsername,
    required this.isVerified,
    required this.verificationToken,
    required this.tokenExpiresAt,
    required this.accountPassword,
    required this.accountAuthority,
    this.accountAvatar,
    required this.personId,
    required this.isDeleted,
    required this.updateAt,
    required this.createAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      accountUsername: json['accountUsername'],
      isVerified: json['isVerified'],
      verificationToken: json['verificationToken'],
      tokenExpiresAt: DateTime.parse(json['tokenExpiresAt']),
      accountPassword: json['accountPassword'],
      accountAuthority: json['AccountAuthority'],
      accountAvatar: json['AccountAvatar'],
      personId: json['personId'],
      isDeleted: json['isDeleted'],
      updateAt: DateTime.parse(json['updateAt']),
      createAt: DateTime.parse(json['createAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountUsername': accountUsername,
      'isVerified': isVerified,
      'verificationToken': verificationToken,
      'tokenExpiresAt': tokenExpiresAt.toIso8601String(),
      'accountPassword': accountPassword,
      'AccountAuthority': accountAuthority,
      'AccountAvatar': accountAvatar,
      'personId': personId,
      'isDeleted': isDeleted,
      'updateAt': updateAt.toIso8601String(),
      'createAt': createAt.toIso8601String(),
    };
  }
}