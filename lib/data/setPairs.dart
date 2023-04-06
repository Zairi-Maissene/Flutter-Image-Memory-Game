import 'package:memogame/model/Tile.dart';

var pairs = getPairs();
var selectedTileIndex = 0;
var selectedImagePath = '';
var selectedImages = 0;
int currentPlayer = 0;
var solved = 0;
List<TileModel> getPairs() {
  var mypairs = <TileModel>[];
  TileModel tileModel = TileModel(
      imagePath: 'assets/image.jpg', isSelected: true, isRevealed: false);
  mypairs.add(tileModel);
  tileModel = TileModel(
      imagePath: 'assets/flash_img.png', isSelected: true, isRevealed: false);
  mypairs.add(tileModel);
  tileModel = TileModel(
      imagePath: 'assets/flash_img.png', isSelected: true, isRevealed: false);
  mypairs.add(tileModel);
  tileModel = TileModel(
      imagePath: 'assets/image.jpg', isSelected: true, isRevealed: false);
  mypairs.add(tileModel);
  tileModel = TileModel(
      imagePath: 'assets/image2.jpg', isSelected: true, isRevealed: false);
  mypairs.add(tileModel);
  tileModel = TileModel(
      imagePath: 'assets/image2.jpg', isSelected: true, isRevealed: false);
  mypairs.add(tileModel);
  return mypairs;
}
