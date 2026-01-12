import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/entity/wishlist_entity.dart';
import '../../../domain/usecases/wishlist/add_to_wishlist.dart';
import '../../../domain/usecases/wishlist/clear_wishlist.dart';
import '../../../domain/usecases/wishlist/get_wishlist.dart';
import '../../../domain/usecases/wishlist/remove_wishlist.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final AddToWishlist _addToWishlist;
  final GetWishlist _getWishlist;
  final RemoveWishlist _removeWishlist;
  final ClearWishlist _clearWishlist;

  WishlistBloc({
    required AddToWishlist addToWishlist,
    required GetWishlist getWishlist,
    required RemoveWishlist removeWishlist,
    required ClearWishlist clearWhishlist,
  })  : _addToWishlist = addToWishlist,
        _getWishlist = getWishlist,
        _removeWishlist = removeWishlist,
        _clearWishlist = clearWhishlist,
        super(WishlistInitial()) {
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<GetWishlistEvent>(_onLoadWishlist);
    on<RemoveWishlistEvent>(_onRemoveWishlist);
    on<ClearWishlistEvent>(_onClearWishlist);
  }

  void _onAddToWishlist(
      AddToWishlistEvent event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    final res = await _addToWishlist(
      AddToWishlistParams(
        productId: event.productId,
        name: event.name,
        price: event.price,
        image: event.image,
        overview: event.overview,
      ),
    );
    res.fold(
      (l) => emit(WishlistFailure(l.message)),
      (r) => emit(WishlistSuccess()),
    );
  }

  void _onLoadWishlist(
      GetWishlistEvent event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    final res = await _getWishlist(NoParams());
    res.fold(
      (l) => emit(WishlistFailure(l.message)),
      (r) => emit(WishlistLoaded(r)),
    );
  }

  void _onRemoveWishlist(
      RemoveWishlistEvent event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    final res = await _removeWishlist(RemoveWishlistParams(
      productId: event.productId,
    ));
    res.fold(
      (l) => emit(WishlistFailure(l.message)),
      (r) => emit(WishlistSuccess()),
    );
  }

  void _onClearWishlist(
      ClearWishlistEvent event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    final res = await _clearWishlist(NoParams());
    res.fold(
      (l) => emit(WishlistFailure(l.message)),
      (r) => emit(WishlistSuccess()),
    );
  }
}
