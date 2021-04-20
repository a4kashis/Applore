import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsItem extends StatefulWidget {
  final docSnapshot;

  ProductsItem({this.docSnapshot});

  @override
  _ProductsItemState createState() => _ProductsItemState();
}

class _ProductsItemState extends State<ProductsItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.docSnapshot["title"]),
    );
  }
}
