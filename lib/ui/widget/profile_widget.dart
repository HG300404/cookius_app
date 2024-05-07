import 'package:cookius_app/constants.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final IconData icon;
  final String title;

  const ProfileWidget({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                color: Constants.blackColor.withOpacity(.5),
                size: 24,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: Constants.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              if (widget.title == "My Profile"){

              }
            },
            icon: Icon(Icons.arrow_forward_ios, color: Constants.blackColor.withOpacity(.4),
              size: 16),
          )
        ],
      ),
    );
  }
}
