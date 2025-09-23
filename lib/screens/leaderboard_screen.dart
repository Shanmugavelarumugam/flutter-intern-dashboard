import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final List<Map<String, dynamic>> mockLeaders = [
    {
      "name": "Ananya Sharma",
      "score": "₹7,500",
      "avatar": "A",
      "rank": 1,
      "progress": 0.95,
      "isCurrentUser": false,
      "badge": "🥇",
    },
    {
      "name": "Rahul Verma",
      "score": "₹6,800",
      "avatar": "R",
      "rank": 2,
      "progress": 0.85,
      "isCurrentUser": false,
      "badge": "🥈",
    },
    {
      "name": "Meera Patel",
      "score": "₹6,200",
      "avatar": "M",
      "rank": 3,
      "progress": 0.78,
      "isCurrentUser": false,
      "badge": "🥉",
    },
    {
      "name": "Vikram Singh",
      "score": "₹5,800",
      "avatar": "V",
      "rank": 4,
      "progress": 0.72,
      "isCurrentUser": false,
      "badge": "4",
    },
    {
      "name": "Priya Reddy",
      "score": "₹5,400",
      "avatar": "P",
      "rank": 5,
      "progress": 0.68,
      "isCurrentUser": false,
      "badge": "5",
    },
    {
      "name": "You",
      "score": "₹5,250",
      "avatar": "Y",
      "rank": 6,
      "progress": 0.65,
      "isCurrentUser": true,
      "badge": "6",
    },
    {
      "name": "Karan Malhotra",
      "score": "₹4,900",
      "avatar": "K",
      "rank": 7,
      "progress": 0.61,
      "isCurrentUser": false,
      "badge": "7",
    },
    {
      "name": "Sneha Joshi",
      "score": "₹4,600",
      "avatar": "S",
      "rank": 8,
      "progress": 0.57,
      "isCurrentUser": false,
      "badge": "8",
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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
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

  // Web Layout - Full desktop experience
 Widget _buildWebLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildWebHeader(),
                  const SizedBox(height: 24),

                  // Stats and Content Area - FIXED LAYOUT
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Stats and User Info
                        Expanded(
                          flex: 4, // Adjusted flex ratio
                          child: Column(
                            children: [
                              _buildWebStatsGrid(),
                              const SizedBox(height: 24),
                              _buildWebUserRankCard(),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        // Right Column - Leaderboard
                        Expanded(
                          flex: 6, // Adjusted flex ratio
                          child: _buildWebLeaderboardTable(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mobile Layout - Preserve existing design
  Widget _buildMobileLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600 && screenWidth <= 900;
    final isSmallMobile = screenWidth < 380;
    final isVerySmallMobile = screenWidth < 350;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(_getResponsivePadding(false, isTablet, isSmallMobile, isVerySmallMobile)),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeaderSection(false, isTablet, isSmallMobile, isVerySmallMobile),
                  SizedBox(height: _getResponsiveSpacing(false, isTablet, isSmallMobile, isVerySmallMobile)),
                  _buildStatsSection(false, isTablet, isSmallMobile, isVerySmallMobile),
                  SizedBox(height: _getResponsiveSpacing(false, isTablet, isSmallMobile, isVerySmallMobile)),
                  _buildLeaderboardSection(false, isTablet, isSmallMobile, isVerySmallMobile),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Web Header
// Fix the Web Header padding as well
  Widget _buildWebHeader() {
    return Container(
      padding: const EdgeInsets.all(24), // Reduced padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(20), // Slightly smaller radius
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60, // Smaller size
            height: 60,
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
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.leaderboard_rounded,
              color: Colors.white,
              size: 30, // Smaller icon
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Global Leaderboard",
                  style: TextStyle(
                    fontSize: 28, // Smaller font
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Track your ranking among fellow fundraisers",
                  style: TextStyle(
                    fontSize: 14, // Smaller font
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 30,
              color: Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }


  // Web Stats Grid
  Widget _buildWebStatsGrid() {
    final stats = [
      {
        'title': 'Total Participants',
        'value': '${mockLeaders.length}',
        'icon': Icons.people_alt_rounded,
        'color': Color(0xFF3B82F6),
      },
      {
        'title': 'Top Score',
        'value': '₹7,500',
        'icon': Icons.trending_up_rounded,
        'color': Color(0xFF10B981),
      },
      {
        'title': 'Average Score',
        'value': '₹5,800',
        'icon': Icons.analytics_rounded,
        'color': Color(0xFFF59E0B),
      },
      {
        'title': 'Your Rank',
        'value': '6',
        'icon': Icons.leaderboard_rounded,
        'color': Color(0xFF8B5CF6),
      },
    ];

    return SizedBox(
      height: 200, // Fixed height to prevent overflow
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.5, // Increased aspect ratio for better fit
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) => _buildWebStatCard(stats[index]),
      ),
    );
  }

  // Web Stat Card - FIXED VERSION
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
        padding: const EdgeInsets.all(16), // Reduced padding
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: stat['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                stat['icon'],
                color: stat['color'],
                size: 24,
              ), // Smaller icon
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center content vertically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat['value'],
                    style: TextStyle(
                      fontSize: 18, // Smaller font size
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['title'],
                    style: TextStyle(
                      fontSize: 12, // Smaller font size
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Web User Rank Card
  Widget _buildWebUserRankCard() {
    final currentUser = mockLeaders.firstWhere((leader) => leader['isCurrentUser'] == true);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_rounded, color: Color(0xFF10B981), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Ranking",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
             Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Rank",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "${currentUser['rank']}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // distinct color
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 24,
                        ), // spacing between rank and score
                        Column(
                          children: [
                            Text(
                              "Score",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "${currentUser['score']}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green, // distinct color
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: currentUser['progress'],
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress to next rank",
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                "${(currentUser['progress'] * 100).round()}%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Web Leaderboard Table
  Widget _buildWebLeaderboardTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(24),
           decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),

            child: const Row(
              children: [
                SizedBox(width: 60),
                SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Participant",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Progress",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Score",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          
          // Table Rows
          Expanded(
            child: ListView.builder(
              itemCount: mockLeaders.length,
              itemBuilder: (context, index) => _buildWebLeaderboardRow(mockLeaders[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLeaderboardRow(Map<String, dynamic> leader) {
    final isCurrentUser = leader['isCurrentUser'] == true;
    
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFF10B981).withOpacity(0.05) : Colors.white,
        border: isCurrentUser ? Border.all(color: const Color(0xFF10B981).withOpacity(0.2)) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getRankColor(leader['rank']),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(leader['rank']).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  leader['badge'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCurrentUser ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  leader['avatar'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Name
            Expanded(
              flex: 3,
              child: Text(
                leader['name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                  color: isCurrentUser ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Progress Bar
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: leader['progress'],
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_getRankColor(leader['rank'])),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(leader['progress'] * 100).round()}%",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            
            // Score
            Expanded(
              flex: 1,
              child: Text(
                leader['score'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Keep all existing mobile methods unchanged
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1: return const Color(0xFFFFD700);
      case 2: return const Color(0xFFC0C0C0);
      case 3: return const Color(0xFFCD7F32);
      default: return const Color(0xFF10B981);
    }
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

  // Include all your existing mobile widget methods exactly as they are
  Widget _buildHeaderSection(bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    // Your existing implementation
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isVerySmallMobile ? 16 : (isSmallMobile ? 18 : (isWeb ? 28 : 22))),
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
                width: isVerySmallMobile ? 40 : (isSmallMobile ? 45 : (isWeb ? 65 : 55)),
                height: isVerySmallMobile ? 40 : (isSmallMobile ? 45 : (isWeb ? 65 : 55)),
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
                  Icons.leaderboard,
                  color: Colors.white,
                  size: isVerySmallMobile ? 20 : (isSmallMobile ? 22 : (isWeb ? 30 : 25)),
                ),
              ),
              SizedBox(width: isVerySmallMobile ? 12 : (isSmallMobile ? 14 : (isWeb ? 20 : 16))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Global Leaderboard",
                      style: TextStyle(
                        fontSize: isVerySmallMobile ? 16 : (isSmallMobile ? 18 : (isWeb ? 26 : 22)),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: isVerySmallMobile ? 4 : 6),
                    Text(
                      "See how you rank among other interns",
                      style: TextStyle(
                        fontSize: isVerySmallMobile ? 11 : (isSmallMobile ? 12 : (isWeb ? 14 : 13)),
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isVerySmallMobile ? 16 : (isSmallMobile ? 18 : (isWeb ? 24 : 20))),
          _buildRankIndicator(isWeb, isTablet, isSmallMobile, isVerySmallMobile),
        ],
      ),
    );
  }

  Widget _buildRankIndicator(bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    final currentUser = mockLeaders.firstWhere((leader) => leader['isCurrentUser'] == true);
    
    return Container(
      padding: EdgeInsets.all(isVerySmallMobile ? 12 : (isSmallMobile ? 14 : (isWeb ? 18 : 16))),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.emoji_events,
              color: const Color(0xFF10B981),
              size: isVerySmallMobile ? 18 : 20,
            ),
          ),
          SizedBox(width: isVerySmallMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Current Rank",
                  style: TextStyle(
                    fontSize: isVerySmallMobile ? 12 : (isSmallMobile ? 13 : (isWeb ? 14 : 13)),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: isVerySmallMobile ? 2 : 4),
                Text(
                  "${currentUser['rank']} • ${currentUser['score']}",
                  style: TextStyle(
                    fontSize: isVerySmallMobile ? 16 : (isSmallMobile ? 18 : (isWeb ? 20 : 18)),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isVerySmallMobile ? 12 : 16, vertical: isVerySmallMobile ? 6 : 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Top ${((currentUser['rank'] / mockLeaders.length) * 100).round()}%",
              style: TextStyle(
                fontSize: isVerySmallMobile ? 10 : 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Total Participants", "${mockLeaders.length}", Icons.people_alt_outlined, const Color(0xFF3B82F6), isWeb, isTablet, isSmallMobile, isVerySmallMobile)),
        SizedBox(width: isVerySmallMobile ? 8 : 12),
        Expanded(child: _buildStatCard("Top Score", "₹7,500", Icons.trending_up, const Color(0xFF10B981), isWeb, isTablet, isSmallMobile, isVerySmallMobile)),
        SizedBox(width: isVerySmallMobile ? 8 : 12),
        Expanded(child: _buildStatCard("Average Score", "₹5,800", Icons.analytics_outlined, const Color(0xFFF59E0B), isWeb, isTablet, isSmallMobile, isVerySmallMobile)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: EdgeInsets.all(isVerySmallMobile ? 10 : (isSmallMobile ? 12 : (isWeb ? 16 : 14))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(isVerySmallMobile ? 6 : 8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: isVerySmallMobile ? 16 : 18),
            ),
            SizedBox(height: isVerySmallMobile ? 6 : 8),
            Text(value, style: TextStyle(fontSize: isVerySmallMobile ? 14 : (isSmallMobile ? 16 : (isWeb ? 18 : 16)), fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            SizedBox(height: isVerySmallMobile ? 2 : 4),
            Text(title, style: TextStyle(fontSize: isVerySmallMobile ? 10 : (isSmallMobile ? 11 : (isWeb ? 12 : 11)), color: const Color(0xFF64748B), fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection(bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Top Performers", style: TextStyle(fontSize: isVerySmallMobile ? 16 : (isSmallMobile ? 18 : (isWeb ? 22 : 20)), fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            Text("Score", style: TextStyle(fontSize: isVerySmallMobile ? 12 : (isSmallMobile ? 13 : (isWeb ? 14 : 13)), fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
          ],
        ),
        SizedBox(height: isVerySmallMobile ? 12 : (isSmallMobile ? 14 : 16)),
        ...mockLeaders.map((leader) => _buildLeaderboardItem(leader, isWeb, isTablet, isSmallMobile, isVerySmallMobile)),
      ],
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> leader, bool isWeb, bool isTablet, bool isSmallMobile, bool isVerySmallMobile) {
    final isCurrentUser = leader['isCurrentUser'] == true;
    
    return Container(
      margin: EdgeInsets.only(bottom: isVerySmallMobile ? 8 : 10),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFF10B981).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isCurrentUser ? Border.all(color: const Color(0xFF10B981).withOpacity(0.2)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: EdgeInsets.all(isVerySmallMobile ? 12 : (isSmallMobile ? 14 : 16)),
        child: Row(
          children: [
            Container(
              width: isVerySmallMobile ? 32 : 36,
              height: isVerySmallMobile ? 32 : 36,
              decoration: BoxDecoration(color: _getRankColor(leader['rank']), shape: BoxShape.circle),
              child: Center(child: Text(leader['badge'], style: TextStyle(fontSize: isVerySmallMobile ? 12 : 14, fontWeight: FontWeight.bold, color: Colors.white))),
            ),
            SizedBox(width: isVerySmallMobile ? 12 : 16),
            Container(
              width: isVerySmallMobile ? 36 : 40,
              height: isVerySmallMobile ? 36 : 40,
              decoration: BoxDecoration(color: isCurrentUser ? const Color(0xFF10B981) : const Color(0xFF3B82F6), shape: BoxShape.circle),
              child: Center(child: Text(leader['avatar'], style: TextStyle(fontSize: isVerySmallMobile ? 14 : 16, fontWeight: FontWeight.bold, color: Colors.white))),
            ),
            SizedBox(width: isVerySmallMobile ? 10 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leader['name'], style: TextStyle(fontSize: isVerySmallMobile ? 13 : (isSmallMobile ? 14 : 15), fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500, color: isCurrentUser ? const Color(0xFF10B981) : const Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: isVerySmallMobile ? 2 : 4),
                  LinearProgressIndicator(value: leader['progress'], backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(_getRankColor(leader['rank'])), borderRadius: BorderRadius.circular(4), minHeight: 4),
                ],
              ),
            ),
            SizedBox(width: isVerySmallMobile ? 8 : 12),
            Text(leader['score'], style: TextStyle(fontSize: isVerySmallMobile ? 14 : (isSmallMobile ? 16 : 15), fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }
}