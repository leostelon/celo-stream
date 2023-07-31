import 'package:fantom/themes.dart';
import 'package:fantom/utils/stream.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StreamModal extends StatefulWidget {
  final Map token;
  const StreamModal({super.key, required this.token});

  @override
  State<StreamModal> createState() => _StreamModalState();
}

class _StreamModalState extends State<StreamModal> {
  bool loading = false;

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
              setState(() {
                loading = true;
              });
              await cancelStream(widget.token['receiver'], widget.token['id']);
              if (context.mounted) Navigator.of(context).pop();
              await Future.delayed(const Duration(seconds: 1));
              Get.snackbar("Successfully canceled stream.",
                  "It might take some time to reflect⏱️",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: primaryColor);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 48, 48),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: const Text(
                  "Cancel Stream",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                trailing: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(
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
