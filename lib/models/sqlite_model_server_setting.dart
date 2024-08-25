// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SQLiteModelServerSetting {
  final String server;
  final String username;
  final String password;
  final String databaseName;
  SQLiteModelServerSetting({
    required this.server,
    required this.username,
    required this.password,
    required this.databaseName,
  });

  SQLiteModelServerSetting copyWith({
    String? server,
    String? username,
    String? password,
    String? databaseName,
  }) {
    return SQLiteModelServerSetting(
      server: server ?? this.server,
      username: username ?? this.username,
      password: password ?? this.password,
      databaseName: databaseName ?? this.databaseName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'server': server,
      'username': username,
      'password': password,
      'databaseName': databaseName,
    };
  }

  factory SQLiteModelServerSetting.fromMap(Map<String, dynamic> map) {
    return SQLiteModelServerSetting(
      server: map['server'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      databaseName: map['databaseName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModelServerSetting.fromJson(String source) => SQLiteModelServerSetting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SQLiteModelServerSetting(server: $server, username: $username, password: $password, databaseName: $databaseName)';
  }

  @override
  bool operator ==(covariant SQLiteModelServerSetting other) {
    if (identical(this, other)) return true;
  
    return 
      other.server == server &&
      other.username == username &&
      other.password == password &&
      other.databaseName == databaseName;
  }

  @override
  int get hashCode {
    return server.hashCode ^
      username.hashCode ^
      password.hashCode ^
      databaseName.hashCode;
  }
}

