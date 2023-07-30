import 'package:fantom/screens/erc20.dart';
import 'package:fantom/screens/list.dart';
import 'package:fantom/screens/transactions.dart';
import 'package:flutter/material.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});
  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int index = 0;
  List<Widget> screens = const [
    ListScreen(),
    ERC20(),
    // ERC721(),
    TransactionsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 27, 27, 27),
          currentIndex: index,
          onTap: (int ind) {
            setState(() {
              index = ind;
            });
          },
          elevation: 4,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          unselectedIconTheme: IconThemeData(color: Colors.grey[600], size: 32),
          selectedIconTheme: const IconThemeData(size: 32),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                index == 0 ? Icons.home : Icons.home_outlined,
              ),
            ),
            BottomNavigationBarItem(
              label: 'ERC20',
              icon: Icon(
                index == 1
                    ? Icons.monetization_on
                    : Icons.monetization_on_outlined,
              ),
            ),
            // BottomNavigationBarItem(
            //   label: 'NFTS',
            //   icon: Icon(
            //     index == 2 ? Icons.window_rounded : Icons.window_outlined,
            //   ),
            // ),
            BottomNavigationBarItem(
              label: 'History',
              icon: Icon(
                index == 2 ? Icons.receipt_long : Icons.receipt_long_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
