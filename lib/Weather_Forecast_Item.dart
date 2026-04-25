import 'package:flutter/material.dart';
/// function of forecast
class ForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;


  const ForecastItem({
    super.key,
    required this.icon,
    required this.temperature,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 110,
        //child: Padding(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            //const SizedBox(height:8),
            Text(time, style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Icon(icon,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
               temperature ),
            const SizedBox(height: 8),
          ],

        ),
      ),
    );
  }
}
