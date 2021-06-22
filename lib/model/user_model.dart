class User {
  String username;
  String email;
  String fullName;
  String authToken;
  String avatar;
  int ball;
  int id;

  User({this.username, this.email, this.fullName, this.authToken, this.avatar, this.ball, this.id});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        username: responseData['username'],
        email: responseData['email'],
        fullName: responseData['fullname'],
        authToken: responseData['auth_token'],
        avatar: responseData['avatar'],
        ball: responseData['ball'],
        id: responseData['id'] ?? 0
    );
  }
}
