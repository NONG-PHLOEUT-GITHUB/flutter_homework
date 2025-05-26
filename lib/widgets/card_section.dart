import 'package:flutter/material.dart';
class CardSection extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String time;
  final String rating;
  final String reviews;
  final String price;
  final String slots;

  const CardSection({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.time,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.slots,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.timelapse_outlined, size: 16, color: Colors.grey),
                      Text(
                        time,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Row(
                  //   children: [
                  //     const Icon(Icons.star, size: 16, color: Colors.orange),
                  //     Text('$rating $reviews'),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(slots),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
