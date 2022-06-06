class User {
  final String username;
  final String email;
  final int id;
  final bool? isActive;
  // ignore: non_constant_identifier_names
  final List<dynamic> authorized_devices;

  User(this.username, this.email, this.id, this.isActive, this.authorized_devices);

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        isActive = json['isActive'],
        authorized_devices = json['authorized_devices'],
        id = json['id'] ;

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'authorized_devices' : authorized_devices,
    'id' : id,
    'isActive' : isActive,
  };
}