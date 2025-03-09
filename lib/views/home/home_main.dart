import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:chatting_1/views/home/friend_list_view.dart';
import 'package:chatting_1/views/home/friend_search_view.dart';
import 'package:chatting_1/views/home/notification_list_view.dart';
import 'package:chatting_1/views/home/profile_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:chatting_1/views/chat/chat_gate.dart';
import 'package:chatting_1/utils/route.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final List<Widget> _navigationItem = [
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(PhosphorIconsRegular.chatsTeardrop, color: Color(0xFFFCFCFC), size: 25), // 아이콘
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(PhosphorIconsRegular.users, color: Color(0xFFFCFCFC), size: 25),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.public, color: Color(0xFFFCFCFC), size: 25),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(PhosphorIconsRegular.bellRinging, color: Color(0xFFFCFCFC), size: 25),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(PhosphorIconsRegular.userGear, color: Color(0xFFFCFCFC), size: 25),
      ],
    ),
  ];

  final List<Widget> screens = [
    const ChatGate(),
    const FriendGate(),
    const FriendSearchView(),
    const NotificationListView(),
    ProfileView(),
  ];

  int selectedIndex = 2; // 기본 선택 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: screens[selectedIndex], // 선택된 인덱스에 맞는 페이지 표시
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF262626), // 네비게이션 바 배경색
        buttonBackgroundColor: const Color(0xFF3A86FF), // 선택된 버튼 배경색
        backgroundColor: Colors.white, // 네비게이션 바 뒤 배경색
        items: _navigationItem, // 아이콘 및 텍스트 설정
        index: selectedIndex,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            selectedIndex = index; // 선택된 인덱스를 업데이트
          });
        },
      ),
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Color(0xFF262626),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    leading: Padding(padding: const EdgeInsets.all(8.0),
      child: Image.asset('assets/amin_icon.png', fit: BoxFit.contain),),
    centerTitle: false,
    title: const Row(
      children: [
        Text(
          "AM!N",
          style: TextStyle(
            color: Color(0xFFFCFCFC),
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
              color: Color(0xFFFCFCFC),
              size: 25,
            ),
            highlightColor: Color(0xFF3A86FF),
            splashColor: Color(0xFF3A86FF),
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
                        icon: const Icon(Icons.close, color: Color(0xFFFCFCFC),),
                        onPressed: () => AppRoutes.pop(context),
                      ),
                    ],
                  ),
                  const Text(
                    "What language do you want to learn?",
                    style: TextStyle(color: Color(0xFFFCFCFC), fontSize: 18, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Color(0xFFFCFCFC), fontSize: 18, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Color(0xFFFCFCFC), fontSize: 18, fontWeight: FontWeight.bold),
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
    label: Text(label, style: const TextStyle(color: Color(0xFFFCFCFC))),
    backgroundColor: Colors.grey[800],
    selectedColor: Color(0xFF3A86FF),
    onSelected: (bool selected) {
      // Add logic for chip selection
    },
  );
}