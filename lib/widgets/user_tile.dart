import 'package:flutter/material.dart';
import 'package:chatting_1/models/user_model.dart';

//사용자 리스트 표시할 때 나오는 프로필, 이름, 부가 정보
class UserTile extends StatelessWidget {
  final UserModel user;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;// 클릭 시 동작

  const UserTile({
    Key? key,
    required this.user,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: user.profileImageUrls.isNotEmpty
                  ? NetworkImage(user.profileImageUrls.first)
                  : const AssetImage('assets/default_profile.png')
              as ImageProvider,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
