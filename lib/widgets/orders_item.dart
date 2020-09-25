import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order_item.dart' as ord;

class OrdersItem extends StatefulWidget {
  final ord.OrderItem order;

  OrdersItem(this.order);

  @override
  _OrdersItemState createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded == true
          ? min(widget.order.products.length * 20.0 + 110, 200)
          : 110,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    '₹${widget.order.amount}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy   hh:mm')
                        .format(widget.order.datetime),
                    //DateFormat.yMMMMEEEEd().format(order.datetime),
                  ),
                  trailing: IconButton(
                      icon: (_expanded == true)
                          ? Icon(Icons.expand_less)
                          : Icon(Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          if (_expanded == false) {
                            _expanded = true;
                          } else {
                            _expanded = false;
                          }
                        });
                      }),
                ),
                // if (_expanded == true)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),
                  height: _expanded == true
                      ? min(widget.order.products.length * 20.0 + 10, 100)
                      : 0,
                  child: ListView(
                    children: widget.order.products
                        .map(
                          (p) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                p.title,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                '${p.quantity}  x  ₹${p.price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
