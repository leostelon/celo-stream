import 'package:fantom/components/balance_modal.dart';
import 'package:flutter/material.dart';

class BalanceModalSend extends StatelessWidget {
  final Map token;
  const BalanceModalSend({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 27, 27, 27),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              String add = await showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  context: context,
                  builder: (_) {
                    return BalanceModal(token: token);
                  });
              print(add);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 48, 48),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                title: Text(
                  "Create Stream",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
