import 'package:flutter/material.dart';
import 'dart:convert';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool favorited;
  final String userId;
  final String userEmail;

  Product({
    this.id = '',
    @required this.title, 
    @required this.description, 
    @required this.price, 
    this.imageUrl = 'assets/your_own_empty_heart.jpg',
    this.favorited = false,
    @required this.userId,
    @required this.userEmail
  });

  Product.fromJson(Map<String, dynamic> json, String userId)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = double.parse(json['price']),
        imageUrl = json['imageUrl'],
        favorited = json['favoritedUsers'] != null ?
                    (json['favoritedUsers'] as Map<String, dynamic>).containsKey(userId) : false,
        userId = json['userId'],
        userEmail = json['userEmail'];

  Map<String, dynamic> toJson() => {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'userId': userId,
      'userEmail': userEmail,
      'price': price.toString()
    };
}