class TileModel {
  String? imagePath;
  bool? isSelected;
  bool? isRevealed;
  TileModel({this.imagePath, this.isSelected, this.isRevealed});
  void setImagePath(String imagePath) {
    this.imagePath = imagePath;
  }

  void setIsSelected(bool isSelected) {
    this.isSelected = isSelected;
  }

  void setIsRevealed(bool isRevealed) {
    this.isRevealed = isRevealed;
  }

  String? getImagePath() {
    return imagePath;
  }

  bool? getisSelected() {
    return isSelected;
  }

  bool? getisRevealed() {
    return isRevealed;
  }
}
