part of 'wishlist_bloc.dart';

sealed class WishlistState {
  const WishlistState();
}

final class WishlistInitial extends WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistSuccess extends WishlistState {}

final class WishlistFailure extends WishlistState {
  final String message;

  const WishlistFailure(this.message);
}

final class WishlistLoaded extends WishlistState {
  final List<WishlistEntity> wishlist;

  const WishlistLoaded(this.wishlist);
}
