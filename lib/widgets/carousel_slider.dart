import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;

  final List<String> _imagePaths = [
    'assets/images/ads1.webp',
    'assets/images/ads2.png',
    'assets/images/ads3.png',
    'assets/images/ads4.webp',
  ];

  final double _sliderHeight = 150.0;
  final double _dotSize = 8.0;
  final double _activeDotWidth = 20.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCarousel(),
        const SizedBox(height: 8),
        _buildDotIndicators(),
      ],
    );
  }

  Widget _buildCarousel() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CarouselSlider(
          items: _imagePaths.map((path) => _buildImage(path)).toList(),
          options: CarouselOptions(
            height: _sliderHeight,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _imagePaths.asMap().entries.map((entry) {
        bool isActive = _currentIndex == entry.key;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: _dotSize,
          width: isActive ? _activeDotWidth : _dotSize,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImage(String assetPath) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
