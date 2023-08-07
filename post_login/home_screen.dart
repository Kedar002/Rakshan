import 'dart:convert';
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/models/GetHomeModelNested.dart';
import 'package:Rakshan/screens/post_login/hospitalItem.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/homeclasscontroller.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? valueServiceProviderType;
  String? valueService;
  String? searchString = '';
  bool setValue = true;
  bool enable = true;
  List clientType = [];
  String? valueServiceProvideId;
  String? valueServiceProvideName;
  List documentTypes = [];
  List documentTypes1 = [];
  List serviceType = [];
  String? valueServiceName1;
  final search = TextEditingController();
  final _controller = ScrollController();
  int page = 0;

  ////////////////////
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostsPerRequest = 10;
  late List<HospitalData> hospitalData;
  final int _nextPageTrigger = 1;

  @override
  void initState() {
    _pageNumber = 1;
    hospitalData = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    getHomeApi(false);
    super.initState();
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'An error occurred.',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  getHomeApi(false);
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
        ],
      ),
    );
  }

  Future<void> getHomeApi(bool reload) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userToken = prefs.getString('data');
      final header = {'Authorization': 'Bearer $userToken'};
      if (reload) {
        _pageNumber = 1;
      }
      String url =
          '$BASE_URL/api/Service/GetAllservicesList?ClientId=0&ServiceId=0&ProviderId=0&Search=$searchString&CityId=0&StateId=0&PageNumber=$_pageNumber';
      print("url$url");
      var res = await http.get(Uri.parse(url), headers: header);
      debugPrint(res.body);
      var data = jsonDecode(res.body.toString());
      List<HospitalData> hospitals;
      if (res.statusCode == 200) {
        if (reload) {
          hospitalData = [];
        }
        hospitals = (data['data'] as List)
            .map<HospitalData>((e) => HospitalData.fromJson(e))
            .toList();
        print("data of hospital$hospitalData");
        setState(() {
          _isLastPage = hospitalData.length < _numberOfPostsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          hospitalData.addAll(hospitals);
        });
      } else {
        setState(() {
          hospitalData = [];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      print("error --> $e");
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarIndividual(
        title: 'Hospitals & Services',
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: search,
                    onChanged: (value) {
                      if (search.text.length > 3) {
                        setState(() {
                          searchString = search.text;
                          getHomeApi(true);
                        });
                      } else {
                        getHomeApi(false);
                      }
                    },
                    decoration: ktextfieldDecoration(
                        'Name, city, service & speciality'),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: buildPostsView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostsView() {
    if (hospitalData.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(child: errorDialog(size: 20));
      }
    }
    return ListView.builder(
        itemCount: hospitalData.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == hospitalData.length - _nextPageTrigger) {
            if (hospitalData.length < 2) {
              final HospitalData post = hospitalData[index];
              return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: HospitalItem(post));
            }
            getHomeApi(false);
          }
          if (index == hospitalData.length) {
            if (_error) {
              return Center(child: errorDialog(size: 15));
            } else {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }
          final HospitalData post = hospitalData[index];
          return Padding(
              padding: const EdgeInsets.all(0.0), child: HospitalItem(post));
        });
  }
}

class VerticalHeight extends StatelessWidget {
  const VerticalHeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}
