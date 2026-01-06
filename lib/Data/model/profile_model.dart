enum ProfileTrailingType {
  arrow,
  switchButton,
  none,
}

class ProfileModel {
  const ProfileModel(this.id, this.title, this.subtitle, this.image, this.trailingType);

  final int id;
  final String title;
  final String subtitle;
  final String image;
  final ProfileTrailingType trailingType;
}