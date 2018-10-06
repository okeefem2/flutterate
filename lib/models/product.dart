import 'package:flutter/material.dart';
class Product {
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool favorited;

  Product({
    @required this.title, 
    @required this.description, 
    @required this.price, 
    this.imageUrl = 'assets/your_own_empty_heart.jpg',
    this.favorited = false
  });

  set imageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }
}