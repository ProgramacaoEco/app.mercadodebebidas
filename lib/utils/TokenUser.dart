// ignore_for_file: file_names

class TokenUser {
  String? tokenUser;

  setToken(token) async {
    this.tokenUser = token;
  }

  getToken() {
    return this.tokenUser.toString();
  }
}
