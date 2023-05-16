import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/cart_provider.dart';
import 'package:shopping_cart_app/db_helper.dart';

import 'cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              animationDuration: const Duration(milliseconds: 300),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Column(children: [
        FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                    width: 100,
                                    height: 100,
                                    image: NetworkImage(snapshot
                                        .data![index].image
                                        .toString())),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data![index].productName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                dbHelper!.delete(
                                                    snapshot.data![index].id!);
                                                cart.removeCounter();
                                                cart.removeTotalPrice(
                                                    double.parse(snapshot
                                                        .data![index]
                                                        .productPrice
                                                        .toString()));
                                              },
                                              child: const Icon(Icons.delete))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${snapshot.data![index].unitTag.toString()} RS.${snapshot.data![index].productPrice.toString()}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      int quantity = snapshot
                                                          .data![index]
                                                          .quantity!;
                                                      int price = snapshot
                                                          .data![index]
                                                          .initialPrice!;
                                                      quantity--;
                                                      int? newPrice =
                                                          price * quantity;

                                                      if (quantity > 0) {
                                                        dbHelper!
                                                            .updateQuantity(Cart(
                                                                id: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id,
                                                                productId:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                productName:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .productName
                                                                        .toString(),
                                                                initialPrice:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice,
                                                                productPrice:
                                                                    newPrice,
                                                                quantity:
                                                                    quantity,
                                                                unitTag: snapshot
                                                                    .data![
                                                                        index]
                                                                    .unitTag
                                                                    .toString(),
                                                                image: snapshot
                                                                    .data![
                                                                        index]
                                                                    .image))
                                                            .then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .initialPrice!
                                                                  .toString()));
                                                        }).onError((error,
                                                                stackTrace) {
                                                          print(
                                                              error.toString());
                                                        });
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data![index].quantity
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      int quantity = snapshot
                                                          .data![index]
                                                          .quantity!;
                                                      int price = snapshot
                                                          .data![index]
                                                          .initialPrice!;
                                                      quantity++;
                                                      int? newPrice =
                                                          price * quantity;
                                                      dbHelper!
                                                          .updateQuantity(Cart(
                                                              id: snapshot
                                                                  .data![index]
                                                                  .id,
                                                              productId: snapshot
                                                                  .data![index]
                                                                  .id
                                                                  .toString(),
                                                              productName: snapshot
                                                                  .data![index]
                                                                  .productName
                                                                  .toString(),
                                                              initialPrice: snapshot
                                                                  .data![index]
                                                                  .initialPrice,
                                                              productPrice:
                                                                  newPrice,
                                                              quantity:
                                                                  quantity,
                                                              unitTag: snapshot
                                                                  .data![index]
                                                                  .unitTag
                                                                  .toString(),
                                                              image: snapshot
                                                                  .data![index]
                                                                  .image))
                                                          .then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .initialPrice!
                                                                .toString()));
                                                      }).onError((error,
                                                              stackTrace) {
                                                        print(error.toString());
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
              }
              return const Text('');
            }),
        Consumer<CartProvider>(builder: (context, value, child) {
          return Visibility(
            visible: value.getTotalPrice(0.0).toStringAsFixed(2) == "0.00"
                ? false
                : true,
            child: Column(
              children: [
                ReusableWidget(
                  title: 'Sub Total',
                  value: r'PKR ' + value.getTotalPrice(0.0).toStringAsFixed(2),
                )
              ],
            ),
          );
        })
      ]),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
