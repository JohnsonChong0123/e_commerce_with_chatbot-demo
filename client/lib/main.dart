import 'features/presentation/cubit/chatbot/chatbot_cubit.dart';
import 'features/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../lib/core/configs/apis/keys.dart';
import 'core/cubits/app_user/app_user_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/data/models/cart/cart_model.dart';
import 'features/presentation/blocs/auth/auth_bloc.dart';
import 'features/presentation/blocs/order/order_bloc.dart';
import 'features/presentation/blocs/payment/payment_bloc.dart';
import 'features/presentation/blocs/profile/profile_bloc.dart';
import 'features/presentation/blocs/review/review_bloc.dart';
import 'features/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'features/presentation/cubit/cart/cart_cubit.dart';
import 'features/presentation/cubit/location/location_cubit.dart';
import 'features/presentation/cubit/navbar/navbar_cubit.dart';
import 'features/presentation/cubit/product/product_cubit.dart';
import 'features/presentation/cubit/profile/profile_cubit.dart';
import 'features/presentation/cubit/search/search_cubit.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartModelAdapter());
  Stripe.publishableKey = publishableKey;
  await initializeDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => sl<LocationCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => sl<ProductCubit>(),
      ),
      BlocProvider(
        create: (_) => NavbarCubit(),
      ),
      BlocProvider(
        create: (_) => SearchCubit(),
      ),
      BlocProvider(
        create: (_) => sl<WishlistBloc>(),
      ),
      BlocProvider(
        create: (_) => sl<ProfileBloc>(),
      ),
      BlocProvider(
        create: (_) => sl<ProfileCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<CartCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<PaymentBloc>(),
      ),
      BlocProvider(
        create: (_) => sl<OrderBloc>(),
      ),
      BlocProvider(
        create: (_) => sl<ReviewBloc>(),
      ),
      BlocProvider(
        create: (_) => sl<ChatBotCubit>(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
