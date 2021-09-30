import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_food_cart_app/bloc/listStyieColorBloc.dart';
import 'package:the_food_cart_app/model/foodItem.dart';
import 'bloc/cartListBloc.dart';
class Cart extends StatelessWidget{
  final CartListBloc bloc=BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    List<FoodItem>foodItems;
    
    // TODO: implement build
   return StreamBuilder(
       stream: bloc.ListStream,
       builder: (context,snapshot){
     if(snapshot.data!=null){
       foodItems=snapshot.data;
       return Scaffold(
         body: SafeArea(
           child: Container(
             child: CartBody (foodItems),

           ),
         ),
         bottomNavigationBar:BottomNavigationBar(foodItems) ,
       );
     }else{
       return Container();
     }
   });
  }

}
class BottomNavigationBar extends StatelessWidget {
  final List<FoodItem>foodItems;

  BottomNavigationBar(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35,bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           totalAmount(foodItems),
          Divider(
            height: 1,
            color:  Colors.grey[700],

          ) ,
          persons(),
          nextButtonBar(),
        ],
      ),
    );
  }

  Container totalAmount(List<FoodItem> foodItems) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding:EdgeInsets.all(25) ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total",style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),),
          Text("\$${returnTotalAmount(foodItems)}",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),)
        ],
      ),
    );
  }

  Container persons() {
    return Container(
        margin: EdgeInsets.only(right: 10),
    padding:EdgeInsets.symmetric(vertical: 30) ,
    child: Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Persons",style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),),
          CustomPersonWidget()
        ])
    );
  }

  Container nextButtonBar() {
    return Container(
        margin: EdgeInsets.only(right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.yellow[800],
          borderRadius: BorderRadius.circular(15)

      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children:[
            Text(
              "15-20 min",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "Next",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ]
      ),
    );
  }
}

class CustomPersonWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomPersonWidget();
  }
}
class _CustomPersonWidget extends State<StatefulWidget> {

int noOfPersons=1;
double buttonWidth=30;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300],width: 2),
        borderRadius: BorderRadius.circular(10)
      ),
      padding:EdgeInsets.symmetric(vertical: 5) ,
width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [SizedBox(height: buttonWidth,width: buttonWidth,
        child: FlatButton(
          child: Text("-",style:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,

          ),),
          onPressed: (){setState(() {
            noOfPersons--;
          });},
        ),),
          Text(noOfPersons.toString(),style:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,

          ),),SizedBox(height: buttonWidth,width: buttonWidth,
            child: FlatButton(
              child: Text("+",style:TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,

              ),),
              onPressed: (){setState(() {
                noOfPersons++;
              });},
            ),),],
      ),
    );
  }
}


String returnTotalAmount(List<FoodItem> foodItems){
  double totalAmount=0;
  for (int i = 0; i < foodItems.length; i++) {
    totalAmount=totalAmount+foodItems[i].price*foodItems[i].quantity;
  }
  return totalAmount.toStringAsFixed(2);
}
class CartBody extends StatelessWidget {
  final List<FoodItem>foodItems;

  CartBody(this.foodItems);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.fromLTRB(35, 40, 25, 0),
      child:  Column(
        children: [
          CustomAppBar(),
          title(),
          Expanded(
              flex: 1,
              child: foodItems.length>0? foodItemsList(): noItemsContainer(),)
        ],
      ),
    );
  }

  Container noItemsContainer() {
    return Container(
      child: Center(
        child: Text("No more items in the cart",
        style: TextStyle(
          fontWeight:FontWeight.w600,
          color: Colors.grey[500],
          fontSize: 20,
        ),),
      ),
    );
  }

  ListView foodItemsList() {
    return ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (builder,index){
      return CartListItem(foodItem:foodItems[index]);
    }
    );
  }

}

class CartListItem extends StatelessWidget{
  final FoodItem foodItem;

  CartListItem({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Draggable(
      data: foodItem,
      maxSimultaneousDrags:1,
      child: DraggableChild(foodItem: foodItem,),
      feedback: DraggableChildFeedback(foodItem:foodItem,),
      childWhenDragging: foodItem.quantity>1?DraggableChild(foodItem: foodItem):Container(),
    );
  }
}
class DraggableChildFeedback extends StatelessWidget{
  final FoodItem foodItem;
  const DraggableChildFeedback({Key key, @required this.foodItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ColorBloc colorBloc=BlocProvider.getBloc<ColorBloc>();
    return Opacity(
      opacity: .7,

      child: Material(
        child: StreamBuilder(
          builder:  (context,snapshot){
            return Container(
              margin: EdgeInsets.only(bottom: 25),
              child: ItemContent(foodItem:foodItem),
              decoration: BoxDecoration(
                color: snapshot.data!=null?snapshot.data:Colors.white,
              ),
            );
          },

        ),
      ),
    );
  }
}
class DraggableChild extends StatelessWidget{
  final FoodItem foodItem;
  const DraggableChild({Key key, @required this.foodItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(foodItem:foodItem),
    );
  }
}

class ItemContent extends StatelessWidget{
  final FoodItem foodItem;


  ItemContent({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Container(
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [ClipRRect(
         borderRadius: BorderRadius.circular(5),
         child: Image.network(
           foodItem.imgUrl,
           fit: BoxFit.fill,
           height: 55,
           width: 80,
         ),
         ),
       RichText(text: TextSpan(
         style: TextStyle(
           fontWeight:FontWeight.w700,
           color: Colors.black,
           fontSize: 16,
         ),
         children: [
           TextSpan(text: foodItem.quantity.toString()),
           TextSpan(text:"X"),
           TextSpan(text: foodItem.title),

         ]
       ),
       ),
         Text("\$${foodItem.quantity * foodItem.price}", style: TextStyle(
    fontWeight:FontWeight.w400,
    color: Colors.grey[300],

         ))
       ],
     ),
   );
  }
}
Widget title(){
  return Padding(padding: EdgeInsets.symmetric(vertical: 35),
  child: Row(children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(
        "MY",style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 35,
      ),
      ),
        Text(
          "Order",style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 35,
        ),
        ),],
    )
  ],),
  );
}

class CustomAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Padding(padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: (){Navigator.pop(context);},
        child: Icon(CupertinoIcons.back,size: 30,),
      ),
      ),
       DragTargetWidget(),
      ],
    );
  }
}

class DragTargetWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DragTargetWidget();
  }
}
class _DragTargetWidget extends State<DragTargetWidget>{
  final CartListBloc listBloc=BlocProvider.getBloc<CartListBloc>();
  final ColorBloc colorBloc=BlocProvider.getBloc<ColorBloc>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DragTarget<FoodItem>(
        onWillAccept:(FoodItem foodItem){
          colorBloc.setColor(Colors.red);

          return true;
        },
        onAccept: (FoodItem foodItem){
          listBloc.removeFromList(foodItem);
          colorBloc.setColor(Colors.white);
        } ,
        onLeave:(FoodItem foodItem){ colorBloc.setColor(Colors.white);
        },
        builder: (context,incoming,rejected){
      return GestureDetector(
        child:Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            CupertinoIcons.delete,
            size: 35,

          ),
        ) ,
        onTap: (){},
      );
    }
    );
  }

}