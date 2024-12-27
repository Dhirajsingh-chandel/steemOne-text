import 'package:test_1/user_model.dart';

class UserController {
  List<User> userList = [];

  List<User> allUsers = [
    User("Dhiraj", "dhiraj@gmail.com", "123456778", "Adity"),
    User("Pratap", "pratap@gmail.com", "123456778", "Manish"),
    User("Krushna", "krush@gmail.com", "123456778", "avi"),
  ];

  UserController() {
    userList = List.from(allUsers);
  }

  void searchUsers(String? query) {
    try {
      if (query == null || query.isEmpty) {
        userList = allUsers;
      } else {
        userList = allUsers
            .where((user) =>
            user.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }catch(e){
      print("filterUsers $e");
    }
  }
}
