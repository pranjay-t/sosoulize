enum ThemeMode {
  light,
  dark,
}

enum UserKarma {
  comment(1),
  textPost(2),
  linkPost(2),
  imagePost(3),
  awardPost(3),
  deletePost(-1);

  final int karma;
  const UserKarma(this.karma);
}