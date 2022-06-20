import 'package:app_firebase_example/models/models.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);
  final Products product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 300,
        decoration: _CardBorders(),
        child: Stack(alignment: Alignment.bottomLeft, children: [
          _BackgroundImage(path: product.picture),
          _ProductDetails(id: product.id, name: product.name),
          Positioned(top: 0, right: 0, child: _PriceTag(price: product.price.toString())),
          if (!product.available) const Positioned(top: 0, left: 0, child: _Available()),
        ]),
      ),
    );
  }

  BoxDecoration _CardBorders() =>
      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
        BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 7)),
      ]);
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    Key? key,
    required this.path,
  }) : super(key: key);
  final String? path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: path == null
            ? const Image(fit: BoxFit.cover, image: AssetImage('assets/no-image.png'))
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(path!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  final String? id;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        decoration: _TittleBoxDecoration(),
        width: double.infinity,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 5),
            Text(id.toString(),
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
          ]),
        ),
      ),
    );
  }

  BoxDecoration _TittleBoxDecoration() => const BoxDecoration(
      color: Colors.amberAccent,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ));
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({
    Key? key,
    required this.price,
  }) : super(key: key);
  final String? price;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
      width: 100,
      height: 70,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Text('$price€', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _Available extends StatelessWidget {
  const _Available({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Text('No available', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
