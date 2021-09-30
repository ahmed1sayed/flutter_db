import 'package:the_food_cart_app/model/foodItem.dart';


class CartProvider {

  List<FoodItem> foodItems = [];

  List<FoodItem> addToList(FoodItem foodItem) {
    bool isPresent = false;
    if (foodItems.length > 0) {
      for (int i = 0; i < foodItems.length; i++) {
        if (foodItems[i].id == foodItem.id) {
          increseItemQuntity(foodItem);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }
      if (!isPresent) {
        foodItems.add(foodItem);
      }

      } else {
        foodItems.add(foodItem);

    }
    return foodItems;
  }
void increseItemQuntity(FoodItem foodItem)=>foodItem.incrementQuantity();
  void decreseItemQuntity(FoodItem foodItem)=>foodItem.decrementQuantity();

  List<FoodItem> removeFromList(FoodItem foodItem) {
    if(foodItem.quantity>1){decreseItemQuntity(foodItem);
    }else{  foodItems.remove(foodItem);}

    return foodItems;
  }
}
