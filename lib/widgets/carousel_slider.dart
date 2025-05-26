import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;

  final List<String> imageUrls = [
    "https://www.spized.com/media/75/f7/f8/1680187076/Fu%C3%9Fballfeld.jpg",
    "https://t3.ftcdn.net/jpg/09/28/78/84/360_F_928788438_TyuKTkDqrR3GolJsgbltMcAgOufUAFhu.jpg",
    "https://img.freepik.com/premium-photo/green-grass-soccer-stadium_30824-117.jpg",
    "https://img.freepik.com/premium-photo/green-grass-soccer-stadium_30824-117.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image Slider
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                spreadRadius: 1.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CarouselSlider(
              items: imageUrls.map((url) => _buildImage(url)).toList(),
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Dot Indicator with active width effect
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageUrls.asMap().entries.map((entry) {
            bool isActive = _currentIndex == entry.key;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: isActive ? 20.0 : 8.0,
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildImage(String url) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
