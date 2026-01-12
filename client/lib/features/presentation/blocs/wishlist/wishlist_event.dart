part of 'wishlist_bloc.dart';

sealed class WishlistEvent {
  const WishlistEvent();
}

final class AddToWishlistEvent extends WishlistEvent {
  final String productId;
  final String name;
  final double price;
  final String image;
  final String overview;

  const AddToWishlistEvent({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.overview,
  });
}

final class GetWishlistEvent extends WishlistEvent {}

final class RemoveWishlistEvent extends WishlistEvent {
  final String productId;

  const RemoveWishlistEvent({required this.productId});
}

final class ClearWishlistEvent extends WishlistEvent {}