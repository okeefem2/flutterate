import 'package:flutter/material.dart';
import 'dart:convert';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String imagePath;
  final bool favorited;
  final String userId;
  final String userEmail;
  final double locationLatitude;
  final double locationLongitude;
  final String locationAddress;

  Product({
    this.id = '',
    @required this.title, 
    @required this.description, 
    @required this.price, 
    this.favorited = false,
    @required this.userId,
    @required this.userEmail,
    this.imageUrl,
    this.imagePath, 
    this.locationLatitude,
    this.locationLongitude,
    this.locationAddress
  });

  Product.fromJson(Map<String, dynamic> json, String userId)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = double.parse(json['price']),
        imageUrl = json['imageUrl'],
        imagePath = json['imagePath'],
        favorited = json['favoritedUsers'] != null ?
                    (json['favoritedUsers'] as Map<String, dynamic>).containsKey(userId) : false,
        userId = json['userId'],
        userEmail = json['userEmail'],
        locationLatitude = json['locationLatitude'] != null ? double.parse(json['locationLatitude']) : null,
        locationLongitude = json['locationLongitude'] != null ? double.parse(json['locationLongitude']) : null,
        locationAddress = json['locationAddress'];

  Map<String, dynamic> toJson() => {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'userId': userId,
      'userEmail': userEmail,
      'price': price.toString(),
      'locationLatitude': locationLatitude.toString(),
      'locationLongitude': locationLongitude.toString(),
      'locationAddress': locationAddress,
    };
}