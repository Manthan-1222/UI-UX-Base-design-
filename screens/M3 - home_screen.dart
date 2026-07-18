import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_shell.dart';

class BusinessCardData {
  final String title;
  final String description;
  final LinearGradient gradient;
  final String? imageUrl;
  final IconData? icon;
  final Color? iconColor;

  BusinessCardData({
    required this.title,
    required this.description,
    required this.gradient,
    this.imageUrl,
    this.icon,
    this.iconColor,
  });
}

class HomeScreen extends StatefulWidget {
  final String accessToken;

  const HomeScreen({super.key, required this.accessToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  late PageController _pageController;
  int _currentPage = 1; // Default to Distributor (index 1) to match active state in HTML
  bool _isSaving = false;
  final TextEditingController _customCategoryController = TextEditingController();

  final List<BusinessCardData> _categories = [
    BusinessCardData(
      title: 'Farmer',
      description: 'Track milk production and track herd health daily.',
      gradient: const LinearGradient(
        colors: [Color(0xFF48D6A3), Color(0xFF29B6A0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuARSnJdaktkf09vcFEgFWQYRzWHCy7WT2kabd7LyEYd3c727Wd54JSv2ZDH0HI-uc208A4QwRF66GuPe9q39TSWsMGJclhi8Dlv7pkq7ZcWY8hTTh0EXMW5JQiDsU_AXdFtQ-kAc1HHyp09r0pYUDE9p735u_K4y0Lhg_6VH_tGa2ZfKA05nTB1BvdV1TYE4rhtWBR4BKfIwf4EEzCQ_inAWsm8tU-GJn8NKoI4wrQRZbDJ0Nm1GR3DM7So9e5C_gy8il8aFjOAx-0e',
    ),
    BusinessCardData(
      title: 'Distributor',
      description: 'Manage record daily milk deliveries across routes.',
      gradient: const LinearGradient(
        colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDB3SHvTb6jDRRE0kkNaxGot0AwYbcEIc_6IDA7GVD9lqhnqZW6SdqFntLevPbKifVZhuHj9t17tNUjlAGXk5vbemsP6qSxNHwdgxn00ZZBNlDW48OG24ut_WS9BNQ_1wqsgC9qosNeBfQlDjgj3X04Feu-qUsTJLJvmGr6pjBCagzIEM0RWLPIkP2PT7C9c3vSc7rWeDxMsr7j5J1jluFpdQGLLHvoUNeWVH4ADS64yekQ2oGv15xZ7QpKw16y8R-QOGkZj3P2nOl7',
    ),
    BusinessCardData(
      title: 'Retailer',
      description: 'Manage store inventory and customer sales.',
      gradient: const LinearGradient(
        colors: [Color(0xFFF6D365), Color(0xFFFDA085)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.shopping_cart,
      iconColor: const Color(0xFFF59E0B),
    ),
    BusinessCardData(
      title: 'Add Custom',
      description: 'Click to add your own business type.',
      gradient: const LinearGradient(
        colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.add,
      iconColor: const Color(0xFFC084FC),
    ),
  ];

  final List<LinearGradient> _customGradients = const [
    LinearGradient(
      colors: [Color(0xFF4FACFE), Color(0xFFA29BFE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF00D4FF), Color(0xFF0099FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFF6B9D), Color(0xFFC06C84)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
  int _customGradientIndex = 0;

  @override
  void initState() {
    super.initState();
    // Replicate viewport fraction for premium peeking cards
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.72,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _showAddCustomBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24.0,
            left: 24.0,
            right: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Category',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      _customCategoryController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Category Name',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _customCategoryController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Distributor',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 18.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF40B178),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40B178),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  onPressed: _addNewCategory,
                  child: const Text(
                    'Add to Slider',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }

  void _addNewCategory() {
    final String name = _customCategoryController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category name'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    final gradient = _customGradients[_customGradientIndex % _customGradients.length];
    _customGradientIndex++;

    final newCard = BusinessCardData(
      title: name,
      description: 'Custom business category',
      gradient: gradient,
      icon: Icons.business,
      iconColor: gradient.colors.first,
    );

    setState(() {
      // Insert before "Add Custom" card which is at index _categories.length - 1
      _categories.insert(_categories.length - 1, newCard);
    });

    _customCategoryController.clear();
    Navigator.pop(context);

    // Scroll to the newly added category card
    final newIndex = _categories.length - 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _handleContinue() async {
    final selectedCard = _categories[_currentPage];

    if (selectedCard.title == 'Add Custom') {
      // Prompt user to select/add a category
      _showAddCustomBottomSheet();
      return;
    }

    // Trial/Mock fallback check
    if (widget.accessToken.isEmpty) {
      _showToast('Category selected: ${selectedCard.title} (Trial Session) 🎉', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
      return;
    }

    setState(() => _isSaving = true);
    final result = await _authService.updateBusinessCategory(
      category: selectedCard.title,
      accessToken: widget.accessToken,
    );
    setState(() => _isSaving = false);

    if (result['status'] == 'success') {
      _showToast('Business Category set to ${selectedCard.title} successfully! 🎉', false);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    } else {
      // If error occurs, still allow continuing to dashboard but notify user
      _showToast(result['message'] ?? 'Failed to persist category. Continuing to dashboard.', true);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    }
  }

  void _showToast(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError ? const Color(0xFFBA1A1A) : const Color(0xFF1E7E34),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                // Header section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Select Your\nBusiness Category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Choose the role that best describes your dairy operations.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFF4B5563),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Interactive Premium Slider
                Expanded(
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      return PageView.builder(
                        controller: _pageController,
                        itemCount: _categories.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          // Compute active animation value
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.22)).clamp(0.0, 1.0);
                          } else {
                            value = index == _currentPage ? 1.0 : 0.8;
                          }

                          final scale = 0.8 + (0.2 * value);
                          final opacity = 0.5 + (0.5 * value);

                          return Center(
                            child: Transform.scale(
                              scale: scale,
                              child: Opacity(
                                opacity: opacity,
                                child: _buildCategoryCard(index),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Pagination Dots
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_categories.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 18.0 : 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFFF5F6D)
                              : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                ),

                // Footer Continue Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40B178),
                        elevation: 4.0,
                        shadowColor: const Color(0xFF40B178).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: _handleContinue,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF40B178)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(int index) {
    final card = _categories[index];
    final isAddCustom = card.title == 'Add Custom';

    return GestureDetector(
      onTap: () {
        if (index != _currentPage) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
          );
        } else if (isAddCustom) {
          _showAddCustomBottomSheet();
        }
      },
      child: Container(
        width: 256.0,
        height: 384.0,
        decoration: BoxDecoration(
          gradient: card.gradient,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Icon Container
            Container(
              width: 96.0,
              height: 96.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: card.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(48.0),
                        child: Image.network(
                          card.imageUrl!,
                          width: 56.0,
                          height: 56.0,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // High-quality fallback icons if image fails to load
                            return Icon(
                              card.title == 'Farmer'
                                  ? Icons.agriculture_outlined
                                  : Icons.local_shipping_outlined,
                              size: 48.0,
                              color: card.title == 'Farmer'
                                  ? const Color(0xFF29B6A0)
                                  : const Color(0xFFFF5F6D),
                            );
                          },
                        ),
                      )
                    : Icon(
                        card.icon,
                        size: 48.0,
                        color: card.iconColor,
                      ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Card Title
            Text(
              card.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),

            // Card Description
            Text(
              card.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white.withOpacity(0.9),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
