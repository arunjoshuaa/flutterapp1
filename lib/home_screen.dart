import 'dart:convert';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl =
      'http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice';
  List bannerUrls = [];
  List categorydata = [];
  List offerdata = [];

  var category = [
    "http://devapiv4.dealsdray.com/icons/cat_mobile.png",
    "http://devapiv4.dealsdray.com/icons/cat_lap.png",
    "http://devapiv4.dealsdray.com/icons/cat_camera.png",
    "http://devapiv4.dealsdray.com/icons/cat_led.png"
  ];

  Future fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      final banners = data['data']['banner_one'] as List;
      final categories = data['data']['category'] as List;
      final offers = data['data']['categories_listing'] as List;

      setState(() {
        // Extract banner URLs
        bannerUrls =
            banners.map((banner) => banner['banner'] as String).toList();
        categorydata = categories.map((category) {
          return {
            'label': category['label'] as String,
            'icon': category['icon'] as String,
          };
        }).toList();

        offerdata = offers.map((categories_listing) {
          return {
            'icon': categories_listing['icon'] as String,
            'offer': categories_listing['offer'] as String,
            'label': categories_listing['label'] as String
          };
        }).toList();
      });
    } else {
      // Handle error scenario (e.g., throw an exception)
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.grey,
        iconTheme: IconThemeData(size: 30),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.68,
                child: SearchBar(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade300),
                    hintText: "Search here",
                    leading: Image.asset(
                      'lib/assets/images/searchbar_logo.jpg',
                      height: 40,
                      width: 40,
                    ),
                    trailing: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Handle search action here
                        },
                      ),
                    ],
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // Adjust the radius as needed
                        );
                      },
                    ),
                    elevation: MaterialStateProperty.all(0.0))),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.notifications_none)
          ],
        ),
      ),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
                height: 200,
                child: CarouselSlider(
                  items: bannerUrls.map((imageUrl) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Error loading image',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),

                  //Slider Container properties
                  options: CarouselOptions(
                    height: 180.0,
                    //     enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.9,
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8186F1),
                    Color(0xFF555ACE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "KYC Pending",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "     You need to provide the required\ndocument for your account activation",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    // Text("document for your account activation",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Click Here",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 500,
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categorydata.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 35, top: 20, bottom: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              categorydata[index]['icon']), //NetworkImage
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(categorydata[index]['label']),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.59,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF63B0CC),
                    Color(0xFF77C1CC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 10),
                    child: Row(
                      children: [
                        Text(
                          "EXCLUSIVE OFFER FOR YOU",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(width: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: offerdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 400,
                            width: 200,
                            color: Colors.white,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 100),
                                child: Chip(
                                  label: Text(
                                    '${offerdata[index]['offer']} Off',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  backgroundColor: Colors
                                      .green, // Customize the background color
                                  shape: RoundedRectangleBorder(
                                    // Customize the shape
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 0,
                                  ),
                                ),
                              ),
                              Container(
                                height: 170,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        offerdata[index]['icon'],
                                        scale: 5,
                                      ),
                                      fit: BoxFit.fill),
                                ),

                                //          child: Text("data")
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 10),
                                child: Text(
                                  offerdata[index]['label'],
                                  style: TextStyle(),
                                ),
                              )
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        width: 110,
        height: 50,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(60), // Adjust the radius as needed
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Iconify(
                Ion.chatbubble_working,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Chat',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          mini: false,
          elevation: 20,
          backgroundColor: Colors.red[800],
        ),
      ),
    );
  }
}
