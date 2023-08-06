import 'user.dart';

class Provider extends User {
  int jobId;
  String jobName;
  String? jobDesc;
  int categoryId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Provider({
    required this.jobId,
    required this.jobName,
    this.jobDesc,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
    required int id,
    required String name,
    String? phone,
    String? email,
    required bool isProvider,
    required bool isBlocked,
    String? imageUrl,
    // AddressModel? address,
    required List<int> followersUsers,
    required List<int> followingUsers,
    required List<int> followersRequestsWait,
    required List<int> followRequestsSent,
  }) : super(
          id: id,
          name: name,
          phone: phone,
          email: email,

          isProvider: isProvider,
          isBlocked: isBlocked,
          imageUrl: imageUrl,
          // address: address,
          followersUsers: followersUsers,
          followingUsers: followingUsers,
          followersRequestsWait: followersRequestsWait,
          followRequestsSent: followRequestsSent,
        );
}
