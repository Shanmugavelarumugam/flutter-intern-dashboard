import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> mockAnnouncements = [
    {
      "title": "🎉 Welcome to the Fundraising Program!",
      "description":
          "We're excited to have you onboard. Start your fundraising journey today and make a difference in the world. Together we can create positive change in communities.",
      "time": "2 hours ago",
      "icon": Icons.celebration,
      "color": Color(0xFF10B981),
      "bgColor": Color(0xFFF0FDF4),
      "isNew": true,
      "type": "welcome",
      "priority": "high",
    },
    {
      "title": "💡 Pro Tip: Maximize Your Impact",
      "description":
          "Share your referral code with friends and family to increase your fundraising reach. Every share counts towards making a bigger difference!",
      "time": "5 hours ago",
      "icon": Icons.lightbulb_outline,
      "color": Color(0xFFF59E0B),
      "bgColor": Color(0xFFFEF3C7),
      "isNew": true,
      "type": "tip",
      "priority": "medium",
    },
    {
      "title": "🏆 New Rewards Unlocked!",
      "description":
          "Earn exclusive badges and rewards for every ₹1,000 raised. Check your progress in the rewards section and claim your achievements.",
      "time": "1 day ago",
      "icon": Icons.emoji_events,
      "color": Color(0xFFEF4444),
      "bgColor": Color(0xFFFEF2F2),
      "isNew": false,
      "type": "reward",
      "priority": "high",
    },
    {
      "title": "📢 Campaign Update: Extended Deadline",
      "description":
          "The current fundraising campaign deadline has been extended by one week. More time to reach your goals and make an impact!",
      "time": "2 days ago",
      "icon": Icons.campaign,
      "color": Color(0xFF3B82F6),
      "bgColor": Color(0xFFEFF6FF),
      "isNew": false,
      "type": "update",
      "priority": "medium",
    },
    {
      "title": "🌟 Top Performer Spotlight: Ananya Sharma",
      "description":
          "Congratulations to Ananya Sharma for raising ₹7,500! Learn from her success strategies and fundraising techniques.",
      "time": "3 days ago",
      "icon": Icons.star,
      "color": Color(0xFF8B5CF6),
      "bgColor": Color(0xFFF5F3FF),
      "isNew": false,
      "type": "achievement",
      "priority": "low",
    },
    {
      "title": "📈 Weekly Progress Report Available",
      "description":
          "Your fundraising progress is looking great! You're in the top 20% of all participants. Keep up the amazing work!",
      "time": "1 week ago",
      "icon": Icons.analytics,
      "color": Color(0xFF06B6D4),
      "bgColor": Color(0xFFECFEFF),
      "isNew": false,
      "type": "report",
      "priority": "low",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth > 600 && screenWidth <= 900;
    final isSmallMobile = screenWidth < 380;
    final isVerySmallMobile = screenWidth < 350;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(
                    _getResponsivePadding(
                      isWeb,
                      isTablet,
                      isSmallMobile,
                      isVerySmallMobile,
                    ),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeaderSection(
                        isWeb,
                        isTablet,
                        isSmallMobile,
                        isVerySmallMobile,
                      ),
                      SizedBox(
                        height: _getResponsiveSpacing(
                          isWeb,
                          isTablet,
                          isSmallMobile,
                          isVerySmallMobile,
                        ),
                      ),
                      _buildStatsSection(
                        isWeb,
                        isTablet,
                        isSmallMobile,
                        isVerySmallMobile,
                      ),
                      SizedBox(
                        height: _getResponsiveSpacing(
                          isWeb,
                          isTablet,
                          isSmallMobile,
                          isVerySmallMobile,
                        ),
                      ),
                      _buildFilterSection(
                        isWeb,
                        isTablet,
                        isSmallMobile,
                        isVerySmallMobile,
                      ),
                      SizedBox(height: isVerySmallMobile ? 12 : 16),
                    ]),
                  ),
                ),
                _buildAnnouncementsList(
                  isWeb,
                  isTablet,
                  isSmallMobile,
                  isVerySmallMobile,
                ),
                SliverPadding(
                  padding: EdgeInsets.all(isVerySmallMobile ? 12 : 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildFooterSection(
                      isWeb,
                      isTablet,
                      isSmallMobile,
                      isVerySmallMobile,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getResponsivePadding(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    if (isWeb) return 32;
    if (isTablet) return 24;
    if (isVerySmallMobile) return 14;
    if (isSmallMobile) return 18;
    return 20;
  }

  double _getResponsiveSpacing(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    if (isWeb) return 24;
    if (isTablet) return 20;
    if (isVerySmallMobile) return 16;
    if (isSmallMobile) return 18;
    return 20;
  }

  Widget _buildHeaderSection(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isVerySmallMobile ? 18 : (isSmallMobile ? 20 : (isWeb ? 28 : 24)),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5), Color(0xFFEFF6FF)],
          stops: [0.0, 0.4, 0.8],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isVerySmallMobile
                    ? 48
                    : (isSmallMobile ? 52 : (isWeb ? 70 : 60)),
                height: isVerySmallMobile
                    ? 48
                    : (isSmallMobile ? 52 : (isWeb ? 70 : 60)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: isVerySmallMobile
                      ? 24
                      : (isSmallMobile ? 26 : (isWeb ? 32 : 28)),
                ),
              ),
              SizedBox(
                width: isVerySmallMobile
                    ? 14
                    : (isSmallMobile ? 16 : (isWeb ? 24 : 20)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Announcements",
                      style: TextStyle(
                        fontSize: isVerySmallMobile
                            ? 20
                            : (isSmallMobile ? 22 : (isWeb ? 32 : 26)),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: isVerySmallMobile ? 4 : 6),
                    Text(
                      "Stay updated with latest news, tips and achievements",
                      style: TextStyle(
                        fontSize: isVerySmallMobile
                            ? 12
                            : (isSmallMobile ? 13 : (isWeb ? 15 : 14)),
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: isVerySmallMobile
                ? 18
                : (isSmallMobile ? 20 : (isWeb ? 28 : 24)),
          ),
          _buildNotificationIndicator(
            isWeb,
            isTablet,
            isSmallMobile,
            isVerySmallMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIndicator(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    final newAnnouncements = mockAnnouncements
        .where((announcement) => announcement['isNew'] == true)
        .length;

    return Container(
      padding: EdgeInsets.all(
        isVerySmallMobile ? 14 : (isSmallMobile ? 16 : (isWeb ? 20 : 18)),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: const Color(0xFF10B981),
              size: isVerySmallMobile ? 20 : 22,
            ),
          ),
          SizedBox(width: isVerySmallMobile ? 14 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Updates Available",
                  style: TextStyle(
                    fontSize: isVerySmallMobile
                        ? 13
                        : (isSmallMobile ? 14 : (isWeb ? 16 : 15)),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: isVerySmallMobile ? 3 : 5),
                Text(
                  "$newAnnouncements unread announcement${newAnnouncements != 1 ? 's' : ''}",
                  style: TextStyle(
                    fontSize: isVerySmallMobile
                        ? 12
                        : (isSmallMobile ? 13 : (isWeb ? 14 : 13)),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isVerySmallMobile ? 14 : 16,
              vertical: isVerySmallMobile ? 8 : 10,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: newAnnouncements > 0
                    ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                    : [const Color(0xFF10B981), const Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color:
                      (newAnnouncements > 0
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981))
                          .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  newAnnouncements > 0
                      ? Icons.mark_email_unread_rounded
                      : Icons.mark_email_read_rounded,
                  color: Colors.white,
                  size: isVerySmallMobile ? 14 : 16,
                ),
                SizedBox(width: isVerySmallMobile ? 4 : 6),
                Text(
                  newAnnouncements > 0 ? "New!" : "All Read",
                  style: TextStyle(
                    fontSize: isVerySmallMobile ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    final newCount = mockAnnouncements
        .where((announcement) => announcement['isNew'] == true)
        .length;
    final highPriority = mockAnnouncements
        .where((announcement) => announcement['priority'] == 'high')
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Total",
            "${mockAnnouncements.length}",
            Icons.notifications_outlined,
            const Color(0xFF3B82F6),
            isWeb,
            isTablet,
            isSmallMobile,
            isVerySmallMobile,
          ),
        ),
        SizedBox(width: isVerySmallMobile ? 10 : 12),
        Expanded(
          child: _buildStatCard(
            "Unread",
            "$newCount",
            Icons.mark_email_unread_outlined,
            const Color(0xFFEF4444),
            isWeb,
            isTablet,
            isSmallMobile,
            isVerySmallMobile,
          ),
        ),
        SizedBox(width: isVerySmallMobile ? 10 : 12),
        Expanded(
          child: _buildStatCard(
            "Important",
            "$highPriority",
            Icons.priority_high_rounded,
            const Color(0xFFF59E0B),
            isWeb,
            isTablet,
            isSmallMobile,
            isVerySmallMobile,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isVerySmallMobile ? 12 : (isSmallMobile ? 14 : (isWeb ? 18 : 16)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: isVerySmallMobile ? 18 : 20,
              ),
            ),
            SizedBox(height: isVerySmallMobile ? 8 : 10),
            Text(
              value,
              style: TextStyle(
                fontSize: isVerySmallMobile
                    ? 18
                    : (isSmallMobile ? 20 : (isWeb ? 24 : 22)),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: isVerySmallMobile ? 3 : 5),
            Text(
              title,
              style: TextStyle(
                fontSize: isVerySmallMobile
                    ? 11
                    : (isSmallMobile ? 12 : (isWeb ? 13 : 12)),
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    final filters = ['All', 'New', 'Important', 'Tips', 'Updates'];

    return SizedBox(
      height: isVerySmallMobile ? 40 : 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            margin: EdgeInsets.only(right: isVerySmallMobile ? 8 : 10),
            child: FilterChip(
              selected: isSelected,
              onSelected: (bool value) {
                // Handle filter selection
              },
              label: Text(
                filters[index],
                style: TextStyle(
                  fontSize: isVerySmallMobile ? 11 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selectedColor: const Color(0xFF10B981),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementsList(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final announcement = mockAnnouncements[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(
            _getResponsivePadding(
              isWeb,
              isTablet,
              isSmallMobile,
              isVerySmallMobile,
            ),
            index == 0 ? 0 : (isVerySmallMobile ? 8 : 10),
            _getResponsivePadding(
              isWeb,
              isTablet,
              isSmallMobile,
              isVerySmallMobile,
            ),
            index == mockAnnouncements.length - 1
                ? (isVerySmallMobile ? 12 : 20)
                : 0,
          ),
          child: _buildAnnouncementCard(
            announcement,
            isWeb,
            isTablet,
            isSmallMobile,
            isVerySmallMobile,
          ),
        );
      }, childCount: mockAnnouncements.length),
    );
  }

  Widget _buildAnnouncementCard(
    Map<String, dynamic> announcement,
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    final isNew = announcement['isNew'] == true;
    final priority = announcement['priority'];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isNew
              ? Border.all(color: const Color(0xFF10B981).withOpacity(0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Handle announcement tap
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(
                  isVerySmallMobile
                      ? 16
                      : (isSmallMobile ? 18 : (isWeb ? 22 : 20)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon with priority indicator
                    Stack(
                      children: [
                        Container(
                          width: isVerySmallMobile ? 48 : 52,
                          height: isVerySmallMobile ? 48 : 52,
                          decoration: BoxDecoration(
                            color: announcement['bgColor'],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: announcement['color'].withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              announcement['icon'],
                              color: announcement['color'],
                              size: isVerySmallMobile ? 22 : 24,
                            ),
                          ),
                        ),
                        if (priority == 'high')
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.priority_high_rounded,
                                color: Colors.white,
                                size: isVerySmallMobile ? 10 : 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: isVerySmallMobile ? 14 : 16),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcement['title'],
                                      style: TextStyle(
                                        fontSize: isVerySmallMobile
                                            ? 14
                                            : (isSmallMobile
                                                  ? 15
                                                  : (isWeb ? 17 : 16)),
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: isVerySmallMobile ? 6 : 8),
                                    Text(
                                      announcement['description'],
                                      style: TextStyle(
                                        fontSize: isVerySmallMobile
                                            ? 12
                                            : (isSmallMobile
                                                  ? 13
                                                  : (isWeb ? 14 : 13)),
                                        color: const Color(0xFF64748B),
                                        height: 1.5,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isNew)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFEF4444),
                                        Color(0xFFDC2626),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "NEW",
                                    style: TextStyle(
                                      fontSize: isVerySmallMobile ? 9 : 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: isVerySmallMobile ? 10 : 12),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: isVerySmallMobile ? 14 : 16,
                                color: const Color(0xFF94A3B8),
                              ),
                              SizedBox(width: isVerySmallMobile ? 5 : 6),
                              Text(
                                announcement['time'],
                                style: TextStyle(
                                  fontSize: isVerySmallMobile ? 11 : 12,
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: isVerySmallMobile ? 12 : 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(
                                    announcement['type'],
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _getTypeColor(
                                      announcement['type'],
                                    ).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getTypeLabel(announcement['type']),
                                  style: TextStyle(
                                    fontSize: isVerySmallMobile ? 10 : 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getTypeColor(announcement['type']),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Priority ribbon for high priority
              if (priority == 'high')
                Positioned(
                  top: 16,
                  left: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      "IMPORTANT",
                      style: TextStyle(
                        fontSize: isVerySmallMobile ? 8 : 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isVerySmallMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFF64748B),
            size: isVerySmallMobile ? 18 : 20,
          ),
          SizedBox(width: isVerySmallMobile ? 10 : 12),
          Expanded(
            child: Text(
              "You're all caught up with the latest announcements",
              style: TextStyle(
                fontSize: isVerySmallMobile ? 12 : 13,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'welcome':
        return const Color(0xFF10B981);
      case 'tip':
        return const Color(0xFFF59E0B);
      case 'reward':
        return const Color(0xFFEF4444);
      case 'update':
        return const Color(0xFF3B82F6);
      case 'achievement':
        return const Color(0xFF8B5CF6);
      case 'report':
        return const Color(0xFF06B6D4);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'welcome':
        return 'Welcome';
      case 'tip':
        return 'Pro Tip';
      case 'reward':
        return 'Reward';
      case 'update':
        return 'Update';
      case 'achievement':
        return 'Achievement';
      case 'report':
        return 'Report';
      default:
        return 'General';
    }
  }
}
