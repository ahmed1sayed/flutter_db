import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:the_food_cart_app/bloc/provider.dart';
import 'package:the_food_cart_app/model/foodItem.dart';

class CartListBloc extends BlocBase{

  CartListBloc();

  var _listControler = BehaviorSubject<List<FoodItem>>.seeded([]);

  CartProvider  provider = CartProvider();
  //output
  // ignore: non_constant_identifier_names
  Stream<List<FoodItem>> get ListStream => _listControler.stream;

  //input
  // ignore: non_constant_identifier_names
  Sink<List<FoodItem>> get ListSink => _listControler.sink;

  addToList(FoodItem foodItem) {
    ListSink.add(provider.addToList(foodItem));
  }

  removeFromList (FoodItem foodItem){
    ListSink.add(provider.removeFromList(foodItem));
  }

  @override
  void dispose() {// will be called automatically
    _listControler.close();
    super.dispose();
  }
}