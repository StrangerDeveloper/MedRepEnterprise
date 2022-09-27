class ProfileAvatars {
  static const paNAME = "name";
  static const paURL = "url";

  String? name, url;

  ProfileAvatars({this.name, this.url});

  factory ProfileAvatars.fromMap(Map<String, dynamic> map) {
    return ProfileAvatars(name: map[paNAME], url: map[paURL]);
  }

  Map<String, dynamic> toJson() => {paNAME: name, paURL: url};
}
