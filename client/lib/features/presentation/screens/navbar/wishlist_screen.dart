import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/common/widgets/app_alert_dialog.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../blocs/wishlist/wishlist_bloc.dart';
import '../product/product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const WishlistScreen());

  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AppAlertDialog(
                  onYesPressed: () {
                    context.read<WishlistBloc>().add(ClearWishlistEvent());
                    showSnackBar(context, 'Wishlist cleared');
                    Navigator.of(context).pop();
                  },
                  onNoPressed: () {
                    Navigator.of(context).pop();
                  },
                  title: 'Clear Wishlist',
                  content: 'Are you sure clear the wishlist?',
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: Loader());
          } else if (state is WishlistLoaded) {
            if (state.wishlist.isEmpty) {
              return const Center(child: Text('No favorite item yet'));
            } else {
              return SlidableAutoCloseBehavior(
                child: ListView.builder(
                  itemCount: state.wishlist.length,
                  itemBuilder: (context, index) {
                    final item = state.wishlist[index];
                    return Slidable(
                      key: Key(item.productId.toString()),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              showDialog(
                                context: context,
                                builder: (context) => AppAlertDialog(
                                  onYesPressed: () {
                                    context.read<WishlistBloc>().add(
                                      RemoveWishlistEvent(
                                        productId: item.productId,
                                      ),
                                    );
                                    showSnackBar(
                                      context,
                                      '${item.name} removed from wishlist',
                                    );
                                    Navigator.of(context).pop();
                                    context.read<WishlistBloc>().add(
                                      GetWishlistEvent(),
                                    );
                                  },
                                  onNoPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Delete Item',
                                  content: 'Are you sure delete the item?',
                                ),
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: item),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: item.image.isNotEmpty
                                ? Image.network(
                                    item.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          title: Text(item.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('\$${item.productPrice}')],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          } else if (state is WishlistFailure) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
