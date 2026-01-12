import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../domain/entity/product_view_entity.dart';
import '../../blocs/wishlist/wishlist_bloc.dart';
import '../../cubit/cart/cart_cubit.dart';
import '../../cubit/product/product_cubit.dart';
import '../../cubit/search/search_cubit.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeScreen());
  const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<SearchCubit>().search("");
//     context.read<ProductCubit>().loadProduct();
//     context.read<CartCubit>().loadCart();
//     context.read<WishlistBloc>().add(GetWishlistEvent());
//   }

  @override
  Widget build(BuildContext context) {
    context.read<SearchCubit>().search("");
    context.read<ProductCubit>().loadProduct();
    context.read<CartCubit>().loadCart();
    context.read<WishlistBloc>().add(GetWishlistEvent());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            if (state is AppUserLoggedIn) {
              final firstName = state.user.firstName;
              return Text(
                firstName.isNotEmpty
                    ? "Welcome, $firstName"
                    : "Welcome, friend",
                style: Theme.of(context).textTheme.headlineLarge,
              );
            }
            return Text(
              "Welcome",
              style: Theme.of(context).textTheme.headlineLarge,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                  ),
                  child: BlocBuilder<SearchCubit, String>(
                    builder: (context, state) {
                      return SearchBar(
                        textStyle: WidgetStatePropertyAll(
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        elevation: const WidgetStatePropertyAll(3.0),
                        hintText: "Search",
                        hintStyle: WidgetStatePropertyAll(
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        leading: const Icon(
                          Icons.search,
                          color: AppColor.secondary,
                        ),
                        onChanged: (val) {
                          context.read<SearchCubit>().search(val);
                        },
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Loader();
              } else if (state is ProductSuccess) {
                return BlocBuilder<SearchCubit, String>(
                  builder: (context, searchQuery) {
                    final filteredProducts = state.products
                        .where(
                          (product) => product.name.toUpperCase().startsWith(
                            searchQuery.toUpperCase(),
                          ),
                        )
                        .toList();
                    if (filteredProducts.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }
                    return Expanded(
                      child: ProductGrid(filteredProducts: filteredProducts),
                    );
                  },
                );
              } else if (state is ProductFailure) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}

class ProductGrid extends StatefulWidget {
  final List<ProductViewEntity> filteredProducts;

  const ProductGrid({required this.filteredProducts, super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<ProductCubit>().loadProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          itemCount: widget.filteredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = widget.filteredProducts[index];
            return ProductCard(product: product);
          },
        ),
      ),
    );
  }
}
