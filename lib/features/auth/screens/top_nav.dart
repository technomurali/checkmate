import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/top_nav_tile.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/dispute_form_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/new_event_screen.dart';
import 'package:checkmate/features/auth/screens/profile_screen.dart';
import 'package:checkmate/features/auth/screens/signin_screen.dart';
import 'package:checkmate/features/auth/screens/pharma_rep_dashboard.dart';
import 'package:checkmate/features/auth/screens/office_user_dashboard_screen.dart';
import 'package:checkmate/features/auth/screens/hcp_dashboard.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:flutter/material.dart';

class TopNav extends StatefulWidget {
  final Widget body;
  const TopNav({super.key, required this.body});

  @override
  State<TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<TopNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 150,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top - 10,
              left: 10,
            ),
            alignment: Alignment.center,
            width: double.infinity,
            color: AppColors.topNavColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (userModal.role == UserType.pharmaRep) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PharmaRepDashboard(user: userModal),
                          ),
                        );
                      } else if (userModal.role == UserType.hco) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OfficeUserDashboardScreen(user: userModal),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HCPDashboard(user: userModal),
                          ),
                        );
                      }
                    },

                    child: TopNavTile(
                      icon: Icon(Icons.dashboard, size: 36),
                      label: "Home",
                    ),
                  ),

                  if (userModal.role == UserType.pharmaRep)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewEventScreen(),
                          ),
                        );
                      },
                      child: TopNavTile(
                        icon: Icon(Icons.event_available_outlined, size: 36),
                        label: AppStrings.createEvent,
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventHistoryScreen(),
                        ),
                      );
                    },
                    child: TopNavTile(
                      icon: Icon(Icons.event_repeat_outlined, size: 36),
                      label: AppStrings.eventHistory,
                    ),
                  ),
                  if (userModal.role != UserType.pharmaRep)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisputeFormScreen(),
                          ),
                        );
                      },
                      child: TopNavTile(
                        icon: Icon(Icons.report_problem, size: 36),
                        label: AppStrings.fileDispute,
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisputeHistoryScreen(),
                        ),
                      );
                    },
                    child: TopNavTile(
                      icon: Icon(Icons.history, size: 36),
                      label: AppStrings.disputeHistory,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(),
                        ),
                      );
                    },
                    child: TopNavTile(
                      icon: Icon(Icons.person, size: 36),
                      label: AppStrings.userProfile,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SigninScreen()),
                      );
                    },
                    child: TopNavTile(
                      icon: Icon(Icons.power_settings_new_sharp, size: 36),
                      label: AppStrings.signOut,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}
