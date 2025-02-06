import 'package:flutter/material.dart';

class ProfileTiles extends StatefulWidget {
  final String iconImgUrl;
  final String title;
  final String subtitle;
  final Widget navigateTo;

  const ProfileTiles({
    super.key,
    required this.iconImgUrl,
    required this.title,
    required this.subtitle,
    required this.navigateTo,
  });

  @override
  State<ProfileTiles> createState() => _ProfileTilesState();
}

class _ProfileTilesState extends State<ProfileTiles> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.navigateTo),
          );
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.grey[300] : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: _isHovered
                ? [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1)]
                : [],
            ),
          /*child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget.navigateTo),
              );
            },*/
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    widget.iconImgUrl,
                    height: 20,
                  ),
                ),
                SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(widget.subtitle),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}