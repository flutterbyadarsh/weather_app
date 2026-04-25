import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additional_info.dart';
import 'package:weather_app/Secret_Api_Id.dart';
import 'Weather_Forecast_Item.dart';
import 'package:http/http.dart' as http;
// statefullwidget
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
// main class
class _WeatherScreenState extends State<WeatherScreen> {
 //uri = uniform resource identifier(biggest)
  @override
  void initState(){
    super.initState(); /// all at the top
    weatherFuture = getCurrentWeather();
  }

  late Future<Map<String, dynamic>> weatherFuture;
     Future<Map<String, dynamic >> getCurrentWeather() async {
     try {
       String cityName = 'London';
       final res = await http.get(
         Uri.parse(
           'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'

         ),
       );
      final data = jsonDecode(res.body);
      // print(data);
       //temp = (data['main']['temp']);
       //print( data['main']['pressure']);
      if(data['cod']!="200") {
        throw "Error fetching weather";
      }
       return data;
     }
     catch (e) {
       throw e.toString();
     }
    // print(res.body);
     }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      // title
     title: const Text("Weather App",
       style: TextStyle(fontSize:20,
         fontWeight:FontWeight.bold,
       ),
     ),
      centerTitle: true,
      actions: [
        IconButton( onPressed: () {
         // local state managemanet
          setState(() {
            weatherFuture = getCurrentWeather();
          });
         // print('refresh');
        },
          icon: const Icon(Icons.refresh),

        ),
      ],
    ),
      // future data capture
      body: FutureBuilder(
       future: weatherFuture,
       builder: (context, snapshot) {
         print(snapshot);
         // connection and loading  check
          if(snapshot.connectionState == ConnectionState.waiting)
            return  const Center(child: CircularProgressIndicator.adaptive()
            );
          // error check
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),
            );
          }

          // data fetech kar rha hai api se
         //final data = snapshot.data!;
         if (!snapshot.hasData) {
           return Center(child: Text("No data"));
         }
         final data = snapshot.data!;

         final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky =  currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
         final currentHumidity = currentWeatherData['main']['humidity'];

         return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Main Cart : done
              SizedBox (
                width:double.infinity,
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                  ),
                  child : ClipRRect(
                     borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX:10,sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('$currentTemp K' ,style: TextStyle(
                              fontSize:32, fontWeight: FontWeight.bold,
                            ),
                            ),
                           ///Icons
                            const SizedBox(height:16),
                            Icon(currentSky == 'Clouds' || currentSky == 'Rain'?
                                Icons.cloud : Icons.sunny , size:65),
                            Text(currentSky,
                                style:TextStyle(
                                  fontSize: 20,
                                ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        
                ),
              ),
              //forecast
        
              const SizedBox(height:20),
              const Text('Hourly Forecast',
              style: TextStyle(fontSize:24,
              fontWeight:FontWeight.bold),
              ),
              const SizedBox(height:16),
              /*
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for(int i=0; i<=5;i++)
                      //left4.53

                    ForecastItem(
                        icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds' || data['list'][i+1]['weather'][0]['main'] == 'Rain'? Icons.cloud : Icons.sunny,
                        temperature: data['list'][i+1]['main']['temp'].toString(),
                        final time = DataTime.parse(ForecastItem['dt_txt'])
                        return ForecastItem(time: data['list'][i+1]['dt_txt'].toString(),),


                    /*
                    ForecastItem(icon:Icons.sunny, temperature: '301.22', time: '00:00'),
                    ForecastItem(icon:Icons.cloud, temperature: '201.22', time: '18:00',),
                    ForecastItem(icon:Icons.sunny, temperature: '202.22', time: '08:30',),
                    ForecastItem(icon:Icons.cloud, temperature: '251.20', time: '20:08',),
                    ForecastItem(icon:Icons.cloud, temperature: '221.23', time: '17:30',),

                     */
                    ),

                  ],
                ),
              ),

               */
              //lazy loading

              SizedBox(height:125,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                itemCount: 6,
                itemBuilder:(context, index) {
                  final hourlyForecast = data['list'][index + 1];
                  final hourlySky = data['list'][index+1]['weather'][0]['main'];
                  final hourlyTemp =  hourlyForecast['main']['temp'].toString();
                  final time = DateTime.parse(hourlyForecast['dt_txt']);
                  return ForecastItem(
                      time: DateFormat.j().format(time),
                      temperature: hourlyTemp,
                      icon:hourlySky == 'Clouds' || hourlySky == 'Rain'? Icons.cloud : Icons.sunny,);
                },
                ),
              ),
              /// Weather forecast card
              const SizedBox(height:20),
              const Text('Additional Informational ',
                style: TextStyle(fontSize:26,
                    fontWeight:FontWeight.bold,
                ),
              ),
             const SizedBox(height :10),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children:[
                 AdditionalInfo_Item(
                   icon:Icons.water_drop,
                   label: "Humidity",
                   value: currentHumidity.toString(),
                 ),
                 AdditionalInfo_Item(
                   icon:Icons.air,
                   label: "Wind Speed",
                   value: currentWindSpeed.toString(),
                 ),
                 AdditionalInfo_Item(
                   icon:Icons.beach_access,
                   label: "Pressure",
                   value: currentPressure.toString(),
                 ),
               ],
             ),
        
        
        
        
            ],
        
          ),
         
        );
        },
        
      ),
       
    );
  }
}

