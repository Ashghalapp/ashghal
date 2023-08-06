class User {
  int id;
  String name;
  String? phone;
  String? email;
  bool isProvider;
  bool isBlocked;
  String? imageUrl;
  // AddressModel? address;
  List<int> followersUsers;
  List<int> followingUsers;
  List<int> followersRequestsWait;
  List<int> followRequestsSent;

  User({
    required this.id,
    required this.name,
    this.phone,
    this.email,

    required this.isProvider,
    required this.isBlocked,
    required this.imageUrl,
    // this.address,
    required this.followersUsers,
    required this.followingUsers,
    required this.followersRequestsWait,
    required this.followRequestsSent,
  });
}