import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  bool _hasFingerPrintSupport = false;

  String _authorizedOrNot = 'Not Authorized';

  List<BiometricType> _availableBiometricType = List<BiometricType>();

  Future<void> _getBiometricSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) {
      return Text('Blah Blah');
    }
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    List<BiometricType> availableBiometricType = List<BiometricType>();
    try {
      availableBiometricType =
          await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    if (!mounted) {
      return Text('Blah Blah 2nd');
    }
    setState(() {
      _availableBiometricType = availableBiometricType;
    });
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: "Unlock", useErrorDialogs: true, stickyAuth: true);
    } catch (e) {
      print(e);
    }
    if (!mounted) {
      return Text('Blah Blah 3rd');
    }
    setState(() {
      _authorizedOrNot = authenticated ? 'Authorised' : 'Not Authorised';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getBiometricSupport();
    _getAvailableSupport();
    _authenticateMe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _authorizedOrNot == 'Not Authorised'
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Has FingerPrint Support: $_hasFingerPrintSupport'),
                  Text(
                      'List of BioMetric Support: ${_availableBiometricType.toString()}'),
                  Text('Yes: $_authorizedOrNot'),
                  TextButton(
                      onPressed: _authenticateMe, child: Text('Authorize now')),
                ],
              ),
            )
          : Text('Unlocked Hurray!'),
    );
  }
}
