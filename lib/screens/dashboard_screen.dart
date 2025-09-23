import 'package:flutter/material.dart';
import 'leaderboard_screen.dart';
import 'announcements_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String internName;
  const DashboardScreen({super.key, required this.internName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    
    if (isWeb) {
      return _buildWebLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  // Web Layout - Sidebar + Main Content
 Widget _buildWebLayout() {
    // List of pages to show in the main content area
    final List<Widget> pages = [
      // Your current dashboard layout
      CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildWebHeader(),
                const SizedBox(height: 32),
                _buildWebStatsGrid(),
                const SizedBox(height: 32),
                _buildWebContentArea(),
              ]),
            ),
          ),
        ],
      ),

      // Other pages
      const LeaderboardScreen(),
      const AnnouncementsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar Navigation
            _buildWebSidebar(),

            // Main Content Area
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child:
                      pages[_currentIndex], // Show page based on sidebar selection
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Mobile Layout - Bottom Navigation
  Widget _buildMobileLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600 && screenWidth <= 900;
    final isSmallMobile = screenWidth < 380;
    final isVerySmallMobile = screenWidth < 350;

    final List<Widget> pages = [
      _buildMobileDashboard(isTablet, isSmallMobile, isVerySmallMobile, screenWidth),
      const LeaderboardScreen(),
      const AnnouncementsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: _buildBottomNavigationBar(isTablet, isSmallMobile, isVerySmallMobile),
    );
  }

  // Web Sidebar Navigation
  Widget _buildWebSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo and Header
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Fundraise Pro",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Welcome, ${widget.internName}",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Items
          Expanded(
            child: Column(
              children: [
                _buildWebNavItem(Icons.dashboard, "Dashboard", 0),
                _buildWebNavItem(Icons.leaderboard, "Leaderboard", 1),
                _buildWebNavItem(Icons.campaign, "Announcements", 2),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.share, color: const Color(0xFF10B981), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Referral Code",
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              "INTERN2025",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebNavItem(IconData icon, String title, int index) {
    final isSelected = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10B981).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B),
          ),
        ),
        onTap: () => setState(() => _currentIndex = index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildWebHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard Overview",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Track your fundraising progress and achievements",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.insights, size: 40, color: const Color(0xFF10B981)),
          ),
        ],
      ),
    );
  }

  Widget _buildWebStatsGrid() {
    final stats = [
      {'title': 'Total Donations', 'value': '₹5,250', 'icon': Icons.currency_rupee, 'color': Color(0xFF10B981)},
      {'title': 'Active Campaigns', 'value': '3', 'icon': Icons.campaign, 'color': Color(0xFF3B82F6)},
      {'title': 'Impact Score', 'value': '85%', 'icon': Icons.trending_up, 'color': Color(0xFFEF4444)},
      {'title': 'Ranking', 'value': '6', 'icon': Icons.leaderboard, 'color': Color(0xFF8B5CF6)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildWebStatCard(stats[index]),
    );
  }

  Widget _buildWebStatCard(Map<String, dynamic> stat) {
    return Container(
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: stat['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(stat['icon'], color: stat['color'], size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              stat['value'],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              stat['title'],
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebContentArea() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Actions
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 20),
              _buildWebQuickActions(),
            ],
          ),
        ),
        
        const SizedBox(width: 32),
        
        // Rewards Section
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rewards & Achievements",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildWebRewardsGrid(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWebQuickActions() {
    final actions = [
      {'title': 'Start Campaign', 'icon': Icons.add_circle_outline, 'color': Color(0xFF10B981)},
      {'title': 'Invite Friends', 'icon': Icons.person_add_outlined, 'color': Color(0xFF3B82F6)},
      {'title': 'View Progress', 'icon': Icons.analytics_outlined, 'color': Color(0xFFF59E0B)},
      {'title': 'Settings', 'icon': Icons.settings_outlined, 'color': Color(0xFF8B5CF6)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => _buildWebActionButton(actions[index]),
    );
  }

  Widget _buildWebActionButton(Map<String, dynamic> action) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: action['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(action['icon'], color: action['color']),
        ),
        title: Text(
          action['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildWebRewardsGrid() {
    final rewards = [
      {'title': 'Bronze', 'subtitle': '₹1,000 Raised', 'progress': 0.85, 'color': Color(0xFFEF4444), 'unlocked': true},
      {'title': 'Silver', 'subtitle': '₹5,000 Raised', 'progress': 0.52, 'color': Color(0xFF64748B), 'unlocked': true},
      {'title': 'Gold', 'subtitle': '₹10,000 Raised', 'progress': 0.32, 'color': Color(0xFFF59E0B), 'unlocked': false},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: rewards.length,
      itemBuilder: (context, index) => _buildWebRewardCard(rewards[index]),
    );
  }

  Widget _buildWebRewardCard(Map<String, dynamic> reward) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: reward['unlocked'] 
            ? [reward['color'].withOpacity(0.1), reward['color'].withOpacity(0.05)]
            : [Colors.grey.shade100, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: reward['unlocked'] ? reward['color'].withOpacity(0.2) : Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 40, color: reward['unlocked'] ? reward['color'] : Colors.grey),
            const SizedBox(height: 12),
            Text(
              reward['title'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: reward['unlocked'] ? reward['color'] : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reward['subtitle'],
              style: TextStyle(color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: reward['progress'],
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(reward['unlocked'] ? reward['color'] : Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  // Keep all your existing mobile methods below (they remain unchanged)
  // _buildBottomNavigationBar, _buildNavItem, _buildMobileDashboard, 
  // _buildWelcomeSection, _buildStatsSection, _buildQuickActions, 
  // _buildRewardsSection, and all their helper methods...

  // ... [Include all your existing mobile methods here exactly as they are]
  // They will work exactly the same for mobile devices

  Widget _buildBottomNavigationBar(bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF10B981),
          unselectedItemColor: const Color(0xFF64748B),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isVerySmallMobile ? 10 : (isSmallMobile ? 11 : 12),
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: isVerySmallMobile ? 9 : (isSmallMobile ? 10 : 11),
            fontWeight: FontWeight.w500,
          ),
          items: [
            _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, "Dashboard", 0, isSmallMobile, isVerySmallMobile, false),
            _buildNavItem(Icons.leaderboard_outlined, Icons.leaderboard, "Leaderboard", 1, isSmallMobile, isVerySmallMobile, false),
            _buildNavItem(Icons.campaign_outlined, Icons.campaign, "Announcements", 2, isSmallMobile, isVerySmallMobile, false),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData outlinedIcon, IconData filledIcon, String label, int index, bool isSmallMobile, bool isVerySmallMobile, bool isWeb) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isVerySmallMobile ? 6 : (isSmallMobile ? 8 : 10)),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isSelected ? filledIcon : outlinedIcon,
          size: isVerySmallMobile ? 18 : (isSmallMobile ? 20 : 22),
        ),
      ),
      label: label,
    );
  }

  Widget _buildMobileDashboard(bool isTablet, bool isSmallMobile, bool isVerySmallMobile, double screenWidth) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(_getResponsivePadding(false, isTablet, isSmallMobile, isVerySmallMobile)),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWelcomeSection(false, isTablet, isSmallMobile, isVerySmallMobile),
                  SizedBox(height: _getResponsiveSpacing(false, isTablet, isSmallMobile, isVerySmallMobile)),
                  _buildStatsSection(false, isTablet, isSmallMobile, isVerySmallMobile, screenWidth),
                  SizedBox(height: _getResponsiveSpacing(false, isTablet, isSmallMobile, isVerySmallMobile)),
                  _buildQuickActions(false, isTablet, isSmallMobile, isVerySmallMobile, screenWidth),
                  SizedBox(height: _getResponsiveSpacing(false, isTablet, isSmallMobile, isVerySmallMobile)),
                  _buildRewardsSection(false, isTablet, isSmallMobile, isVerySmallMobile),
                  SizedBox(height: isVerySmallMobile ? 10 : 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsivePadding(bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    if (isWeb) return 32;
    if (isTablet) return 24;
    if (isVerySmallMobile) return 12;
    if (isSmallMobile) return 16;
    return 20;
  }

  double _getResponsiveSpacing(bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    if (isWeb) return 28;
    if (isTablet) return 20;
    if (isVerySmallMobile) return 16;
    if (isSmallMobile) return 18;
    return 20;
  }

  // ... [Include all your existing mobile widget methods exactly as they are]
  // _buildWelcomeSection, _buildStatsSection, _buildQuickActions, 
  // _buildRewardsSection, and all their helper methods remain unchanged


  Widget _buildWelcomeSection(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isVerySmallMobile ? 16 : (isSmallMobile ? 18 : (isWeb ? 28 : 22)),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5), Color(0xFFEFF6FF)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
                    ? 40
                    : (isSmallMobile ? 45 : (isWeb ? 65 : 55)),
                height: isVerySmallMobile
                    ? 40
                    : (isSmallMobile ? 45 : (isWeb ? 65 : 55)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.volunteer_activism,
                  color: Colors.white,
                  size: isVerySmallMobile
                      ? 20
                      : (isSmallMobile ? 22 : (isWeb ? 30 : 25)),
                ),
              ),
              SizedBox(
                width: isVerySmallMobile
                    ? 12
                    : (isSmallMobile ? 14 : (isWeb ? 20 : 16)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: TextStyle(
                        fontSize: isVerySmallMobile
                            ? 12
                            : (isSmallMobile ? 13 : (isWeb ? 16 : 14)),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: isVerySmallMobile ? 2 : 4),
                    Text(
                      "${widget.internName}! 👋",
                      style: TextStyle(
                        fontSize: isVerySmallMobile
                            ? 16
                            : (isSmallMobile ? 18 : (isWeb ? 26 : 22)),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isVerySmallMobile ? 2 : 4),
                    Text(
                      "Keep making a difference!",
                      style: TextStyle(
                        fontSize: isVerySmallMobile
                            ? 11
                            : (isSmallMobile ? 12 : (isWeb ? 14 : 13)),
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: isVerySmallMobile
                ? 16
                : (isSmallMobile ? 18 : (isWeb ? 24 : 20)),
          ),
          Container(
            padding: EdgeInsets.all(
              isVerySmallMobile ? 12 : (isSmallMobile ? 14 : (isWeb ? 18 : 16)),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.share,
                    color: const Color(0xFF10B981),
                    size: isVerySmallMobile ? 16 : 18,
                  ),
                ),
                SizedBox(width: isVerySmallMobile ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Referral Code",
                        style: TextStyle(
                          fontSize: isVerySmallMobile
                              ? 10
                              : (isSmallMobile ? 11 : (isWeb ? 13 : 12)),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: isVerySmallMobile ? 1 : 2),
                      Text(
                        "INTERN2025",
                        style: TextStyle(
                          fontSize: isVerySmallMobile
                              ? 14
                              : (isSmallMobile ? 15 : (isWeb ? 18 : 16)),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF10B981),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isVerySmallMobile ? 10 : 12,
                    vertical: isVerySmallMobile ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Copy",
                    style: TextStyle(
                      fontSize: isVerySmallMobile ? 10 : 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
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
    double screenWidth,
  ) {
    int crossAxisCount;
    if (isWeb) {
      crossAxisCount = 3;
    } else if (isTablet) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    final stats = [
      {
        'title': 'Total Donations',
        'value': '₹ 5,250',
        'icon': Icons.currency_rupee,
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFFF0FDF4),
      },
      {
        'title': 'Active Campaigns',
        'value': '3',
        'icon': Icons.campaign,
        'color': const Color(0xFF3B82F6),
        'bgColor': const Color(0xFFEFF6FF),
      },
      {
        'title': 'Impact Score',
        'value': '85%',
        'icon': Icons.trending_up,
        'color': const Color(0xFFEF4444),
        'bgColor': const Color(0xFFFEF2F2),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Impact",
          style: TextStyle(
            fontSize: isVerySmallMobile
                ? 16
                : (isSmallMobile ? 18 : (isWeb ? 24 : 20)),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: isVerySmallMobile ? 12 : (isSmallMobile ? 14 : 16)),
        if (isWeb && screenWidth > 1200)
          Row(
            children: stats
                .map(
                  (stat) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: isVerySmallMobile ? 8 : 12,
                      ),
                      child: _buildStatCard(
                        stat,
                        isWeb,
                        isTablet,
                        isSmallMobile,
                        isVerySmallMobile,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: isVerySmallMobile ? 8 : 12,
              mainAxisSpacing: isVerySmallMobile ? 8 : 12,
              childAspectRatio: _getStatCardAspectRatio(
                isWeb,
                isTablet,
                isSmallMobile,
                isVerySmallMobile,
              ),
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) => _buildStatCard(
              stats[index],
              isWeb,
              isTablet,
              isSmallMobile,
              isVerySmallMobile,
            ),
          ),
      ],
    );
  }

  double _getStatCardAspectRatio(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    if (isVerySmallMobile) return 0.9;
    if (isSmallMobile) return 1.0;
    if (isTablet) return 1.2;
    if (isWeb) return 1.3;
    return 1.1;
  }

  Widget _buildStatCard(
    Map<String, dynamic> stat,
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isVerySmallMobile ? 10 : (isSmallMobile ? 12 : (isWeb ? 20 : 16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(
                isVerySmallMobile ? 6 : (isSmallMobile ? 8 : 10),
              ),
              decoration: BoxDecoration(
                color: stat['bgColor'],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                stat['icon'],
                color: stat['color'],
                size: isVerySmallMobile
                    ? 16
                    : (isSmallMobile ? 18 : (isWeb ? 24 : 20)),
              ),
            ),
            SizedBox(height: isVerySmallMobile ? 8 : (isSmallMobile ? 10 : 12)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                stat['value'],
                style: TextStyle(
                  fontSize: isVerySmallMobile
                      ? 16
                      : (isSmallMobile ? 18 : (isWeb ? 22 : 20)),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(height: isVerySmallMobile ? 2 : 4),
            Text(
              stat['title'],
              style: TextStyle(
                fontSize: isVerySmallMobile
                    ? 10
                    : (isSmallMobile ? 11 : (isWeb ? 12 : 11)),
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
    double screenWidth,
  ) {
    final actions = [
      {
        'title': 'Start Campaign',
        'icon': Icons.add_circle_outline,
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFFF0FDF4),
      },
      {
        'title': 'Invite Friends',
        'icon': Icons.person_add_outlined,
        'color': const Color(0xFF3B82F6),
        'bgColor': const Color(0xFFEFF6FF),
      },
      {
        'title': 'My Progress',
        'icon': Icons.analytics_outlined,
        'color': const Color(0xFFF59E0B),
        'bgColor': const Color(0xFFFEF3C7),
      },
      {
        'title': 'Settings',
        'icon': Icons.settings_outlined,
        'color': const Color(0xFF8B5CF6),
        'bgColor': const Color(0xFFF5F3FF),
      },
    ];

    int crossAxisCount;
    if (isWeb) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: isVerySmallMobile
                ? 16
                : (isSmallMobile ? 18 : (isWeb ? 24 : 20)),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: isVerySmallMobile ? 12 : (isSmallMobile ? 14 : 16)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isVerySmallMobile ? 6 : 8,
            mainAxisSpacing: isVerySmallMobile ? 6 : 8,
            childAspectRatio: _getActionButtonAspectRatio(
              isWeb,
              isTablet,
              isSmallMobile,
              isVerySmallMobile,
            ),
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) => _buildActionButton(
            actions[index],
            isWeb,
            isTablet,
            isSmallMobile,
            isVerySmallMobile,
          ),
        ),
      ],
    );
  }

  double _getActionButtonAspectRatio(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    if (isVerySmallMobile) return 0.8;
    if (isSmallMobile) return 0.9;
    if (isTablet) return 1.0;
    if (isWeb) return 1.1;
    return 1.0;
  }

  Widget _buildActionButton(
    Map<String, dynamic> action,
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    // Increased icon and text sizes
    double iconSize = isVerySmallMobile
        ? 24
        : (isSmallMobile ? 28 : (isWeb ? 32 : 30));
    double textSize = isVerySmallMobile
        ? 13
        : (isSmallMobile ? 14 : (isWeb ? 16 : 15));

    return GestureDetector(
      onTap: () {
        // Handle action
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(
            isVerySmallMobile ? 8 : (isSmallMobile ? 10 : (isWeb ? 16 : 12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(
                  isVerySmallMobile ? 6 : (isSmallMobile ? 8 : 10),
                ),
                decoration: BoxDecoration(
                  color: action['bgColor'],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  action['icon'],
                  color: action['color'],
                  size: iconSize, // increased
                ),
              ),
              SizedBox(height: isVerySmallMobile ? 6 : 8),
              Text(
                action['title'],
                style: TextStyle(
                  fontSize: textSize, // increased
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsSection(
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    final rewards = [
      {
        'title': 'Bronze',
        'subtitle': '₹1,000 Raised',
        'icon': Icons.emoji_events,
        'color': const Color(0xFFEF4444),
        'progress': 0.85,
        'isUnlocked': true,
      },
      {
        'title': 'Silver',
        'subtitle': '₹5,000 Raised',
        'icon': Icons.star,
        'color': const Color(0xFF64748B),
        'progress': 0.52,
        'isUnlocked': true,
      },
      {
        'title': 'Gold',
        'subtitle': '₹10,000 Raised',
        'icon': Icons.workspace_premium,
        'color': const Color(0xFFF59E0B),
        'progress': 0.32,
        'isUnlocked': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Rewards & Achievements",
                style: TextStyle(
                  fontSize: isVerySmallMobile
                      ? 16
                      : (isSmallMobile ? 18 : (isWeb ? 24 : 20)),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "View All",
                style: TextStyle(
                  fontSize: isVerySmallMobile ? 10 : (isSmallMobile ? 11 : 12),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isVerySmallMobile ? 12 : (isSmallMobile ? 14 : 16)),
        SizedBox(
          height: isVerySmallMobile
              ? 120
              : (isSmallMobile ? 130 : (isWeb ? 160 : 140)),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: rewards.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(right: isVerySmallMobile ? 8 : 12),
              child: _buildRewardCard(
                rewards[index],
                isWeb,
                isTablet,
                isSmallMobile,
                isVerySmallMobile,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(
    Map<String, dynamic> reward,
    bool isWeb,
    bool isTablet,
    bool isSmallMobile,
    bool isVerySmallMobile,
  ) {
    return Container(
      width: isVerySmallMobile
          ? 110
          : (isSmallMobile ? 120 : (isWeb ? 150 : 130)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: reward['isUnlocked']
              ? [
                  reward['color'].withOpacity(0.1),
                  reward['color'].withOpacity(0.05),
                ]
              : [Colors.grey.shade100, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reward['isUnlocked']
              ? reward['color'].withOpacity(0.2)
              : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(
        isVerySmallMobile ? 10 : (isSmallMobile ? 12 : (isWeb ? 16 : 14)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: reward['isUnlocked']
                  ? reward['color'].withOpacity(0.1)
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              reward['icon'],
              color: reward['isUnlocked'] ? reward['color'] : Colors.grey,
              size: isVerySmallMobile
                  ? 20
                  : (isSmallMobile ? 22 : (isWeb ? 28 : 24)),
            ),
          ),
          SizedBox(height: isVerySmallMobile ? 6 : 8),
          Text(
            reward['title'],
            style: TextStyle(
              fontSize: isVerySmallMobile
                  ? 12
                  : (isSmallMobile ? 13 : (isWeb ? 14 : 13)),
              fontWeight: FontWeight.bold,
              color: reward['isUnlocked'] ? reward['color'] : Colors.grey,
            ),
          ),
          SizedBox(height: isVerySmallMobile ? 2 : 4),
          Text(
            reward['subtitle'],
            style: TextStyle(
              fontSize: isVerySmallMobile
                  ? 9
                  : (isSmallMobile ? 10 : (isWeb ? 11 : 10)),
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          SizedBox(height: isVerySmallMobile ? 6 : 8),
          LinearProgressIndicator(
            value: reward['progress'],
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              reward['isUnlocked'] ? reward['color'] : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4),
            minHeight: 3,
          ),
        ],
      ),
    );
  }
}
