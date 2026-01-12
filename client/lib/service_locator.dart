import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'core/cubits/app_user/app_user_cubit.dart';
import 'features/data/repositories/cart_repository_impl.dart';
import 'features/data/repositories/chatbot_repository_impl.dart';
import 'features/data/sources/remote/chatbot_remote_data.dart';
import 'features/data/sources/remote/review_remote_data.dart';
import 'features/data/sources/remote/user_remote_data.dart';
import 'features/data/sources/remote/payment_remote_data.dart';
import 'features/domain/repository/cart_repository.dart';
import 'features/domain/repository/chatbot_repository.dart';
import 'features/domain/repository/review_repository.dart';
import 'features/domain/repository/user_repository.dart';
import 'features/domain/usecases/bot/send_bot_message.dart';
import 'features/domain/usecases/cart/add_to_cart.dart';
import 'features/domain/usecases/cart/calculate_cart_summary.dart';
import 'features/domain/usecases/cart/get_cart.dart';
import 'features/domain/usecases/cart/remove_item.dart';
import 'features/domain/usecases/location/get_address_latlng.dart';
import 'features/domain/usecases/location/get_current_location.dart';
import 'features/domain/usecases/order/add_order.dart';
import 'features/domain/usecases/product/all_product.dart';
import 'features/domain/usecases/user/facebook_login.dart';
import 'features/domain/usecases/user/forget_password.dart';
import 'features/domain/usecases/user/get_user_profile.dart';
import 'features/domain/usecases/user/update_address.dart';
import 'features/domain/usecases/user/user_login.dart';
import 'features/domain/usecases/user/user_signup.dart';
import 'features/domain/usecases/user/update_user.dart';
import 'features/domain/usecases/wishlist/add_to_wishlist.dart';
import 'features/presentation/blocs/auth/auth_bloc.dart';
import 'features/presentation/blocs/order/order_bloc.dart';
import 'features/presentation/cubit/chatbot/chatbot_cubit.dart';
import 'features/presentation/cubit/location/location_cubit.dart';
import 'features/presentation/cubit/product/product_cubit.dart';
import 'features/presentation/blocs/profile/profile_bloc.dart';
import 'features/presentation/blocs/payment/payment_bloc.dart';

import 'features/data/repositories/location_repository_impl.dart';
import 'features/data/repositories/order_repository_impl.dart';
import 'features/data/repositories/review_repository_impl.dart';
import 'features/data/repositories/user_repository_impl.dart';
import 'features/data/repositories/product_repository_impl.dart';
import 'features/data/repositories/payment_repository_impl.dart';
import 'features/data/repositories/wishlist_repository_impl.dart';
import 'features/data/sources/local/cart_local_data.dart';
import 'features/data/sources/remote/location_remote_data.dart';
import 'features/data/sources/remote/order_remote_data.dart';
import 'features/data/sources/remote/product_remote_data.dart';
import 'features/data/sources/remote/wishlist_remote_data.dart';
import 'features/domain/repository/location_repository.dart';
import 'features/domain/repository/order_repository.dart';
import 'features/domain/repository/product_repository.dart';
import 'features/domain/repository/payment_repository.dart';
import 'features/domain/repository/wishlist_repository.dart';
import 'features/domain/usecases/cart/clear_cart.dart';
import 'features/domain/usecases/location/get_user_location.dart';
import 'features/domain/usecases/order/clear_order.dart';
import 'features/domain/usecases/order/get_order.dart';
import 'features/domain/usecases/order/remove_order.dart';
import 'features/domain/usecases/review/add_review.dart';
import 'features/domain/usecases/review/get_review.dart';
import 'features/domain/usecases/user/change_password.dart';
import 'features/domain/usecases/user/current_user.dart';

import 'features/domain/usecases/user/delete_user.dart';
import 'features/domain/usecases/user/google_login.dart';
import 'features/domain/usecases/user/update_wallet.dart';
import 'features/domain/usecases/user/user_signout.dart';
import 'features/domain/usecases/payment/payment_usecase.dart';
import 'features/domain/usecases/wishlist/clear_wishlist.dart';
import 'features/domain/usecases/wishlist/get_wishlist.dart';
import 'features/domain/usecases/wishlist/remove_wishlist.dart';
import 'features/presentation/blocs/review/review_bloc.dart';
import 'features/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'features/presentation/cubit/cart/cart_cubit.dart';
import 'features/presentation/cubit/profile/profile_cubit.dart';
import '../../lib/firebase_options.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _initAuth();

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  sl
    ..registerFactory<UserRemoteData>(() => UserRemoteDataImpl())
    ..registerFactory<UserRepository>(() => UserRepositoryImpl(sl(), sl()))
    ..registerFactory(() => UserSignUp(sl()))
    ..registerFactory(() => UserLogin(sl()))
    ..registerFactory(() => GoogleLogin(sl()))
    ..registerFactory(() => FacebookLogin(sl()))
    ..registerFactory(() => CurrentUser(sl()))
    ..registerFactory(() => ForgetPassword(sl()))
    ..registerFactory(() => GetUserProfile(sl()))
    ..registerFactory(() => UpdateUser(sl()))
    ..registerFactory(() => UserSignOut(sl()))
    ..registerFactory(() => UpdateUserAddress(sl()))
    ..registerFactory(() => DeleteUser(sl()))
    ..registerFactory(() => UpdateUserWallet(sl()))
    ..registerFactory(() => ChangePassword(sl()))
    ..registerLazySingleton(
      () => ProfileBloc(
        updateUserWallet: sl(),
        updateUser: sl(),
        updateUserAddress: sl(),
        changePassword: sl(),
      ),
    )
    ..registerLazySingleton(() => ProfileCubit(getUserProfile: sl()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: sl(),
        userLogin: sl(),
        currentUser: sl(),
        appUserCubit: sl(),
        googleLogin: sl(),
        facebookLogin: sl(),
        updateUser: sl(),
        signOut: sl(),
        forgetPassword: sl(),
        deleteUser: sl(),
      ),
    );

  sl
    ..registerFactory<ProductRemoteData>(() => ProductRemoteDataImpl())
    ..registerFactory<ProductRepository>(() => ProductRepositoryImpl(sl()))
    ..registerFactory(() => AllProduct(sl()))
    ..registerLazySingleton(() => ProductCubit(allProductUseCase: sl()));

  sl
    ..registerFactory<PaymentRemoteData>(() => PaymentRemoteDataImpl())
    ..registerFactory<PaymentRepository>(() => PaymentRepositoryImpl(sl()))
    ..registerFactory(() => PaymentUsecase(sl()))
    ..registerLazySingleton(() => PaymentBloc(paymentUsecase: sl()));

  sl
    ..registerFactory<CartLocalData>(() => CartLocalDataImpl())
    ..registerFactory<CartRepository>(() => CartRepositoryImpl(sl()))
    ..registerFactory(() => GetCart(sl()))
    ..registerFactory(() => AddToCart(sl()))
    ..registerFactory(() => RemoveFromCart(sl()))
    ..registerFactory(() => ClearCart(sl()))
    ..registerFactory(() => CalculateCartSummary())
    ..registerLazySingleton(() => CartCubit(sl(), sl(), sl(), sl(), sl()));

  sl
    ..registerFactory<WishlistRemoteData>(() => WishlistRemoteDataImpl())
    ..registerFactory<WishlistRepository>(() => WishlistRepositoryImpl(sl()))
    ..registerFactory(() => AddToWishlist(sl()))
    ..registerFactory(() => GetWishlist(sl()))
    ..registerFactory(() => RemoveWishlist(sl()))
    ..registerFactory(() => ClearWishlist(sl()))
    ..registerLazySingleton(
      () => WishlistBloc(
        addToWishlist: sl(),
        getWishlist: sl(),
        removeWishlist: sl(),
        clearWhishlist: sl(),
      ),
    );

  sl
    ..registerFactory<LocationRemoteData>(() => LocationRemoteDataImpl())
    ..registerFactory<LocationRepository>(() => LocationRepositoryImpl(sl()))
    ..registerFactory(() => GetCurrentLocation(sl()))
    ..registerFactory(() => GetAddressFromLatLng(sl()))
    ..registerFactory(() => GetUserLocation(sl()))
    ..registerLazySingleton(
      () => LocationCubit(
        getCurrentLocation: sl(),
        getAddressFromLatLng: sl(),
        getUserLocation: sl(),
      ),
    );

  sl
    ..registerFactory<OrderRemoteData>(() => OrderRemoteDataImpl())
    ..registerFactory<OrderRepository>(() => OrderRepositoryImpl(sl()))
    ..registerFactory(() => AddOrder(sl()))
    ..registerFactory(() => GetOrder(sl()))
    ..registerFactory(() => RemoveOrder(sl()))
    ..registerFactory(() => ClearOrder(sl()))
    ..registerLazySingleton(
      () => OrderBloc(
        addOrder: sl(),
        getOrder: sl(),
        removeOrder: sl(),
        clearOrder: sl(),
      ),
    );

  sl
    ..registerFactory<ReviewRemoteData>(() => ReviewRemoteDataImpl())
    ..registerFactory<ReviewRepository>(() => ReviewRepositoryImpl(sl()))
    ..registerFactory(() => AddReview(sl()))
    ..registerFactory(() => GetReviews(sl()))
    ..registerLazySingleton(
      () => ReviewBloc(getReviews: sl(), addReview: sl()),
    );

  sl
    ..registerFactory<ChatBotRemoteData>(() => ChatBotRemoteDataImpl(sl()))
    ..registerFactory<ChatBotRepository>(() => ChatBotRepositoryImpl(sl()))
    ..registerFactory(() => SendBotMessage(sl()))
    ..registerLazySingleton(() => ChatBotCubit(sl()));
}
