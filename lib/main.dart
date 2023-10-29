import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/components/drawer_list_builder.dart';
import 'package:vartarevarta_magazine/firebase_options.dart';
import 'package:vartarevarta_magazine/screens/about_us.dart';
import 'package:vartarevarta_magazine/screens/our_team.dart';
import 'package:vartarevarta_magazine/services/drawer_wrapper.dart';
import 'package:vartarevarta_magazine/services/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VaReVa Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'VaReVa Mobile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_money_sharp),
            tooltip: "Subscribe",
          )
        ],
        centerTitle: true,
        backgroundColor: const Color.fromARGB(161, 161, 136, 127),
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerWrapper(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutWidget(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: const Text('Our Team'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OurTeamWidget(),
                  ),
                );
              },
            ),
            const Divider(),
            const DrawerListWidget(),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _fApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something is wrong");
            } else if (snapshot.hasData) {
              return const WrapperWidget();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
