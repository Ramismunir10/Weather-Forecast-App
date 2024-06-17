import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/services/weather_services.dart';
import 'package:weather_forecast_app/utils/app_icons.dart';
import 'package:weather_forecast_app/widget/weather_data_tile.dart';
import 'package:weather_forecast_app/utils/app_images.dart';

class WeatherPageState extends StatefulWidget {
  const WeatherPageState({super.key});

  @override
  State<WeatherPageState> createState() => _WeatherPageStateState();
}

class _WeatherPageStateState extends State<WeatherPageState> {
  final TextEditingController _controller = TextEditingController();
  String _bgImg = AppImages.clear;
  String _iconImg = AppIcons.Clear;
  String _cityName = '';
  String _temperature = '';
  String _tempMax = '';
  String _tempMin = '';
  String _sunrise = '';
  String _sunset = '';
  String _main = '';
  String _presure = '';
  String _humidity = '';
  String _visibility = '';
  String _windSpeed = '';

  getData(String cityName) async {
    final weatherService = WeatherService();
    var weatherData;
    if (cityName == '') {
      weatherData = await weatherService.fetchWeather();
    } else {
      weatherData = await weatherService.getWeather(cityName);
    }

    debugPrint(weatherData.toString());
    setState(() {
      _cityName = weatherData['name'];
      _temperature = weatherData['main']['temp'].toStringAsFixed(1);
      _main = weatherData['weather'][0]['main'];
      _tempMax = weatherData['main']['temp_max'].toStringAsFixed(1);
      _tempMin = weatherData['main']['temp_min'].toStringAsFixed(1);
      _sunrise = DateFormat('hh::mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunrise'] * 1000));
      _sunset = DateFormat('hh::mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunset'] * 1000));
      _presure = weatherData['main']['pressure'].toString();
      _humidity = weatherData['main']['humidity'].toString();
      _visibility = weatherData['visibility'].toString();
      _windSpeed = weatherData['wind']['speed'].toString();
      if (_main == 'Clear') {
        _bgImg = AppImages.clear;
        _iconImg = AppIcons.Clear;
      } else if (_main == 'Clouds') {
        _bgImg = AppImages.cloudy;
        _iconImg = AppIcons.Cloudy;
      } else if (_main == 'Rain') {
        _bgImg = AppImages.rain;
        _iconImg = AppIcons.Rain;
      } else if (_main == 'Fog') {
        _bgImg = AppImages.haze;
        _iconImg = AppIcons.Haze;
      } else if (_main == 'Thunderstorm') {
        _bgImg = AppImages.thunderstorm;
        _iconImg = AppIcons.Thunderstorm;
      } else {
        _bgImg = AppImages.haze;
        _iconImg = AppIcons.Haze;
      }
    });
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      getData('');
    }
    getData('');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _bgImg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: _controller,
                    onChanged: (value) {
                      getData(value);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.black26,
                      hintText: 'Enter City Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      Text(
                        _cityName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '$_temperature°c',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 90,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        _main,
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w500),
                      ),
                      Image.asset(
                        _iconImg,
                        height: 80,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_upward),
                      Text(
                        "$_tempMax°c",
                        style: TextStyle(
                            fontSize: 22, fontStyle: FontStyle.italic),
                      ),
                      Icon(Icons.arrow_downward),
                      Text("$_tempMin°c",
                          style: TextStyle(
                              fontSize: 22, fontStyle: FontStyle.italic))
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          WeatherDataTile(
                              index1: "Sunrise",
                              index2: "Sunset",
                              value1: _sunrise,
                              value2: _sunset),
                          SizedBox(
                            height: 15,
                          ),
                          WeatherDataTile(
                              index1: "Humidity",
                              index2: "Visibility",
                              value1: _humidity,
                              value2: _visibility),
                          SizedBox(
                            height: 15,
                          ),
                          WeatherDataTile(
                              index1: "Presure",
                              index2: "Wind Speed",
                              value1: _presure,
                              value2: _windSpeed),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
