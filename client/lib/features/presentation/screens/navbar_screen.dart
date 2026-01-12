import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chatbot/chatbot_screen.dart';
import 'navbar/cart_screen.dart';
import 'navbar/home_screen.dart';
import 'navbar/account_screen.dart';
import 'navbar/wishlist_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/navbar/navbar_cubit.dart';

class NavBarScreen extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => NavBarScreen());

  NavBarScreen({super.key});
  final List<Widget> _pages = [
    const HomeScreen(),
    const CartScreen(),
    const WishlistScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: _pages[state],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: state == 2 ? Colors.red : AppColor.green,
            unselectedItemColor: AppColor.placeholder,
            selectedLabelStyle: TextStyle(
              color: state == 2 ? Colors.red : AppColor.green,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            showUnselectedLabels: false,
            showSelectedLabels: true,
            currentIndex: state,
            onTap: (index) {
              context.read<NavbarCubit>().update(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: AppColor.placeholder, size: 25),
                activeIcon: Icon(Icons.home, color: AppColor.green, size: 25),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                  color: AppColor.placeholder,
                  size: 25,
                ),
                activeIcon: Icon(
                  Icons.shopping_cart,
                  color: AppColor.green,
                  size: 25,
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: AppColor.placeholder,
                  size: 25,
                ),
                activeIcon: Icon(Icons.favorite, color: Colors.red, size: 25),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_box,
                  color: AppColor.placeholder,
                  size: 25,
                ),
                activeIcon: Icon(
                  Icons.account_box,
                  color: AppColor.green,
                  size: 25,
                ),
                label: 'Account',
              ),
            ],
          ),
          floatingActionButton: state == 1
              ? null
              : FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColor.green,
                  onPressed: () {
                    Navigator.push(context, ChatBotScreen.route());
                  },
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}
