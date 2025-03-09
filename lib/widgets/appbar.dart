import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:chatting_1/views/home/chat_list_view.dart';
import 'package:chatting_1/views/home/friend_list_view.dart';
import 'package:chatting_1/views/home/friend_search_view.dart';
import 'package:chatting_1/views/home/notification_list_view.dart';
import 'package:chatting_1/views/home/profile_view.dart';

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    leading: const Icon(Icons.monitor_heart_rounded, color: Color(0xFFCB9C5A)),
    centerTitle: false,
    title: const Row(
      children: [
        Text(
          "AM!N",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    ),
    actions: [
      Tooltip(
        message: "Filter", // 아이콘에 툴팁 추가
        child: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
              size: 25,
            ),
            highlightColor: const Color.fromRGBO(203, 156, 90, 0.7),
            splashColor: const Color.fromRGBO(203, 156, 90, 0.7),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ),
      ),
    ],
  );
}

void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9, // 최대 크기
        initialChildSize: 0.7, // 초기 크기 (0.6 → 0.7로 변경)
        minChildSize: 0.4, // 최소 크기
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Text(
                    "What language do you want to learn?",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildFilterChip("Korean"),
                      _buildFilterChip("English"),
                      _buildFilterChip("Chinese"),
                      _buildFilterChip("Japanese"),
                      _buildFilterChip("French"),
                      _buildFilterChip("Spanish"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "What type of friend do you want to meet?",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildFilterChip("Language Exchange"),
                      _buildFilterChip("Workout Buddy"),
                      _buildFilterChip("Hobby Sharing"),
                      _buildFilterChip("Party Buddy"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Gender",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildFilterChip("Male"),
                      _buildFilterChip("Female"),
                      _buildFilterChip("I don't care"),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildFilterChip(String label) {
  return FilterChip(
    label: Text(label, style: const TextStyle(color: Colors.white)),
    backgroundColor: Colors.grey[800],
    selectedColor: const Color(0xFFCB9C5A),
    onSelected: (bool selected) {
      // Add logic for chip selection
    },
  );
}