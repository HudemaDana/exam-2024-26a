import 'package:flutter/material.dart';

import 'Sections/MainSection.dart';
import 'Sections/SecondSection.dart';
import 'Sections/ThirdSection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          CustomPage(title: 'Main Section', backgroundColor: Colors.black12, section: 'Main', page: MainSection()),
          CustomPage(title: 'Second Section', backgroundColor: Colors.orangeAccent, section: 'Second', page: SecondSection()),
          CustomPage(title: 'Third Section', backgroundColor: Colors.amberAccent, section: 'Third', page: ThirdSection()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (int page) {
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ad_units_sharp),
            label: 'Second',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Third',
          ),
        ],
      ),
    );
  }
}

class CustomPage extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final String section;
  final Widget page;

  const CustomPage({Key? key, required this.title, required this.backgroundColor, required this.section, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the specific page when the circle is tapped
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  section,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}