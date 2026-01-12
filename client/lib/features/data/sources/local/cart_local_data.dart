import 'package:hive/hive.dart';
import '../../../../core/common/utils/firebase_util.dart';
import '../../models/cart/cart_model.dart';

abstract interface class CartLocalData {
  Future<List<CartModel>> getCartItems();
  Future<void> addCartItem(CartModel item);
  Future<void> removeCartItem(String productId);
  Future<void> clearCart();
  Future<void> closeCartBox();
  Future<void> deleteCartBox();
}

class CartLocalDataImpl implements CartLocalData {
  String _cartBox(String userId) {
    return 'cartBox_$userId';
  }

  Future<Box<CartModel>> _openBox(String userId) async {
    return await Hive.openBox<CartModel>(_cartBox(userId));
  }

  @override
  Future<List<CartModel>> getCartItems() async {
    final box = await _openBox(currentUser!.uid);
    return box.values.toList();
  }

  @override
  Future<void> addCartItem(CartModel item) async {
    final box = await _openBox(currentUser!.uid);

    final existingKey = box.keys.firstWhere((key) {
      final existingItem = box.get(key);
      return existingItem?.productId == item.productId;
    }, orElse: () => null);

    if (existingKey != null) {
      final existingItem = box.get(existingKey)!;
      final updatedItem = existingItem.copyWith(
        quantity: (existingItem.quantity) + (item.quantity),
      );
      await box.put(existingKey, updatedItem);
    } else {
      await box.add(item);
    }
  }

  @override
  Future<void> removeCartItem(String productId) async {
    final box = await _openBox(currentUser!.uid);
    final key = box.keys.firstWhere((key) {
      final item = box.get(key);
      return item?.productId == productId;
    }, orElse: () => null);

    if (key != null) await box.delete(key);
  }

  @override
  Future<void> clearCart() async {
    final box = await _openBox(currentUser!.uid);
    await box.clear();
  }

  @override
  Future<void> closeCartBox() async {
    if (Hive.isBoxOpen(_cartBox(currentUser!.uid))) {
      final box = await Hive.openBox<CartModel>(_cartBox(currentUser!.uid));
      await box.close();
    }
  }

  @override
  Future<void> deleteCartBox() async {
    if (Hive.isBoxOpen(_cartBox(currentUser!.uid))) {
      final box = await Hive.openBox<CartModel>(_cartBox(currentUser!.uid));
      await box.deleteFromDisk();
    }
  }
}
