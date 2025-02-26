import 'package:chatting_1/view_models/friend_search_view_model.dart';
import 'package:chatting_1/models/user_model.dart';
import 'package:chatting_1/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:chatting_1/view_models/chat_list_view_model.dart';
import 'package:chatting_1/views/chat/chat_view.dart';
import 'package:chatting_1/widgets/filter_chip.dart';

class FriendSearchView extends ConsumerStatefulWidget {
  const FriendSearchView({Key? key}) : super(key: key);

  @override
  _FriendSearchViewState createState() => _FriendSearchViewState();
}

class _FriendSearchViewState extends ConsumerState<FriendSearchView> {
  @override
  void initState() {
    super.initState();
    //화면 진입 시 전체 유저 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(friendSearchViewModelProvider.notifier).fetchAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(friendSearchViewModelProvider);
    return Scaffold(
      appBar: _buildAppBar1(),
      body: searchState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchState.errorMessage.isNotEmpty
          ? Center(child: Text("Error: ${searchState.errorMessage}"))
          : _buildBody(searchState),
    );
  }

  Widget _buildBody(FriendSearchState searchState) {
    return Center(
      child: Container(
        color: const Color(0xFFFCFCFC),
        child: Column(
          children: [
            //현재 어떤 필터가 적용되었는지 표시 (임시)
            _buildFilterChips(searchState),

            //실제 결과 리스트
            Expanded(
              child: ListView.builder(
                itemCount: searchState.filteredUsers.length,
                itemBuilder: (context, i) {
                  final user = searchState.filteredUsers[i];
                  return _buildUserTile(user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(UserModel user) {
    return UserTile(
      user: user,
      subtitle: user.introduce.isNotEmpty ? user.introduce : "소개가 없습니다",
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.userCirclePlus),
            onPressed: () {
              //친구 요청-> 삭제 예정
              ref
                  .read(friendSearchViewModelProvider.notifier)
                  .sendFriendRequest(user.uid);
            },
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xFF3A86FF),
              iconSize: 30,
            ),
          ),
          //채팅방 생성 아이콘
          IconButton(
            icon: const Icon(PhosphorIconsBold.paperPlaneTilt),
            onPressed: () async {
              final chatId = await ref
                  .read(chatListViewModelProvider.notifier)
                  .createOrGetChatRoom(user.uid);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    chatId: chatId,
                    otherUserUid: user.uid,
                    otherUserName: user.userName,
                  ),
                ),
              );
            },
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xFF5A6DFF),
              iconSize: 30,
            ),
          ),
        ],
      ),
      onTap: () {
        debugPrint("[FriendSearch] User ${user.userName} tapped");
      },
    );
  }

  /// AppBar
  AppBar _buildAppBar1() {
    return AppBar(
      backgroundColor: const Color(0xFF262626),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/amin_icon.png', fit: BoxFit.contain),
      ),
      centerTitle: false,
      title: const Row(
        children: [

        ],
      ),
      actions: [
        Tooltip(
          message: "Filter",
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Color(0xFFFCFCFC),
                size: 25,
              ),
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
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          builder: (ctx, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Consumer(
                builder: (context, ref, child) {
                  final searchState = ref.watch(friendSearchViewModelProvider);
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, color: Color(0xFFFCFCFC)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const Text(
                          "학습 언어 선택",
                          style: TextStyle(
                            color: Color(0xFFFCFCFC),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            _myFilterChip("한국어", 'language'),
                            _myFilterChip("영어", 'language'),
                            _myFilterChip("중국어", 'language'),
                            _myFilterChip("일본어", 'language'),
                            _myFilterChip("프랑스어", 'language'),
                            _myFilterChip("스페인어", 'language'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "목적",
                          style: TextStyle(
                            color: Color(0xFFFCFCFC),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            _myFilterChip("언어교환", 'purpose'),
                            _myFilterChip("운동메이트", 'purpose'),
                            _myFilterChip("취미공유", 'purpose'),
                            _myFilterChip("파티메이트", 'purpose'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "성별",
                          style: TextStyle(
                            color: Color(0xFFFCFCFC),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            _myFilterChip("남성", 'gender'),
                            _myFilterChip("여성", 'gender'),
                            _myFilterChip("상관 없음", 'gender'),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  //개별 chip
  Widget _myFilterChip(String label, String type) {
    final state = ref.watch(friendSearchViewModelProvider);
    final notifier = ref.read(friendSearchViewModelProvider.notifier);

    bool isSelected = false;
    if (type == 'language') {
      isSelected = (state.selectedLanguage == label);
    } else if (type == 'purpose') {
      isSelected = (state.selectedPurpose == label);
    } else if (type == 'gender') {
      if (label == '무관') {
        isSelected = state.selectedGender.isEmpty;
      } else {
        isSelected = (state.selectedGender == label);
      }
    }

    return MyFilterChip(
      label: label,
      isSelected: isSelected,
      onSelected: (selected) {
        if (type == 'language') {
          notifier.updateLanguage(selected ? label : '');
        } else if (type == 'purpose') {
          notifier.updatePurpose(selected ? label : '');
        } else if (type == 'gender') {
          if (label == '무관' && selected) {
            notifier.updateGender('');
          } else {
            notifier.updateGender(selected ? label : '');
          }
        }
      },
    );
  }

  //임시로 필터 상태 보여주는 메서드
  Widget _buildFilterChips(FriendSearchState searchState) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "선택됨: 언어=${searchState.selectedLanguage}, "
            "목적=${searchState.selectedPurpose}, "
            "성별=${searchState.selectedGender}",
      ),
    );
  }
}
