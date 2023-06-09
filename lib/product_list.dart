import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/cart_model.dart';
import 'package:shopping_cart_app/cart_provider.dart';
import 'package:shopping_cart_app/cart_screen.dart';
import 'package:shopping_cart_app/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> prouctName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit'
  ];
  List<String> productUnit = [
    'KG',
    'KG',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Center(
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: ((context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  }),
                ),
                animationDuration: const Duration(milliseconds: 300),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: prouctName.length,
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
                              image:
                                  NetworkImage(productImage[index].toString())),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prouctName[index].toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${productUnit[index]} RS.${productPrice[index]}",
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
                                    onTap: () {
                                      dbHelper!
                                          .insert(Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName:
                                                  prouctName[index].toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1,
                                              unitTag:
                                                  productUnit[index].toString(),
                                              image: productImage[index]
                                                  .toString()))
                                          .then((value) {
                                        print('Product is added to cart');
                                        cart.addCounter();
                                        cart.addTotalPrice(double.parse(
                                            productPrice[index].toString()));
                                      }).onError((error, stackTrace) {
                                        print(error.toString());
                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Center(
                                        child: Text(
                                          'Add to Cart',
                                          style: TextStyle(color: Colors.white),
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
          ))
        ],
      ),
    );
  }
}
