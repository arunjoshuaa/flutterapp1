import 'dart:ui';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:app3/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/majesticons.dart';
import 'package:iconify_flutter/icons/ri.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex=0;
  var pages=[
HomeScreen(),
    Text('Categories Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),  
    Text('Deal Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)), 
    Text('Cart Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)), 
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)), 



  ];
  var color=Colors.grey[800];
 void onItemTapped(int index) {  
    setState(() {  
      selectedIndex = index;  
      color=color==Colors.red?Colors.grey:Colors.red;
      print("$color");
    });  
  }  


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
 
  bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    
    selectedItemColor: Colors.red[800],
    currentIndex: selectedIndex,
    onTap: onItemTapped,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Iconify(Ri.home_2_line,size: 30,color: selectedIndex == 0 ? Colors.red : Colors.grey,),
        label: 'Home',
      ),
       BottomNavigationBarItem(
        icon:Iconify(Majesticons.applications_line,size: 30,color: selectedIndex == 1 ? Colors.red : Colors.grey ), // widget
      label: 'Categories',
      ),
       BottomNavigationBarItem(
        icon: Image.asset("lib/assets/images/deals_icon.jpg",height: 30,width: 30,),
        label: 'Deal',
      ),
       BottomNavigationBarItem(
        icon: Image.asset("lib/assets/images/cart_icon.jpg",height: 30,width: 30,),
        label: 'Cart',
      ),
       BottomNavigationBarItem(
        icon:Iconify(Uil.user,size: 30,color: selectedIndex == 4 ? Colors.red : Colors.grey),
        label: 'Profile',
      ),
    ],
  ),
  body: Center(child: pages.elementAt(selectedIndex),),
);
  }
}