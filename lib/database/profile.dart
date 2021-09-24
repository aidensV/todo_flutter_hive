import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 1, adapterName: "ProfileAdapter")
class Profile {
  @HiveField(0)
  String name;

  Profile({required this.name});
}
