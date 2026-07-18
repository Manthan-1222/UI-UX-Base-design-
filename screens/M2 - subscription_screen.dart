import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import 'M3 - home_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final String accessToken;

  const SubscriptionScreen({super.key, required this.accessToken});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final PageController _pageController = PageController(viewportFraction: 0.88);

  bool _isLoading = true;
  bool _isSubscribing = false;
  List<dynamic> _plans = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    setState(() => _isLoading = true);
    final result = await _subscriptionService.getPlans();
    setState(() => _isLoading = false);

    if (result['status'] == 'success' && result['data']?['results'] != null) {
      setState(() {
        _plans = result['data']['results'];
      });
    }

    // Fallback if backend returned empty or not connected
    if (_plans.isEmpty) {
      setState(() {
        _plans = [
          {
            'id': 'trial-plan-id',
            'name': 'Trial',
            'price': '0.00',
            'duration_days': 14,
            'features': {'max_customers': 10, 'auto_entries': false, 'whatsapp_notifications': false},
          },
          {
            'id': 'basic-plan-id',
            'name': 'Basic',
            'price': '499.00',
            'duration_days': 30,
            'features': {'max_customers': 50, 'auto_entries': true, 'whatsapp_notifications': false},
          },
          {
            'id': 'pro-plan-id',
            'name': 'Pro',
            'price': '999.00',
            'duration_days': 30,
            'features': {'max_customers': 'unlimited', 'auto_entries': true, 'whatsapp_notifications': true},
          },
        ];
      });
    }
  }

  Future<void> _handleSubscribe() async {
    if (_plans.isEmpty) return;

    final selectedPlan = _plans[_currentPage];
    final planId = selectedPlan['id']?.toString() ?? '';

    // If no access token or fallback plan, just navigate to Home
    if (widget.accessToken.isEmpty || planId.endsWith('-plan-id')) {
      _showToast('Subscribed to ${selectedPlan['name']} Plan! 🎉', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(accessToken: widget.accessToken)),
      );
      return;
    }

    setState(() => _isSubscribing = true);
    final result = await _subscriptionService.subscribe(
      planId: planId,
      accessToken: widget.accessToken,
    );
    setState(() => _isSubscribing = false);

    if (result['status'] == 'success') {
      _showToast('Subscribed to ${selectedPlan['name']} Plan successfully! 🎉', false);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(accessToken: widget.accessToken)),
        );
      }
    } else {
      _showToast(result['message'] ?? 'Subscription failed. Please try again.', true);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper for UI metadata based on plan name
  Map<String, dynamic> _getPlanMeta(Map<String, dynamic> plan) {
    final name = plan['name']?.toString().toLowerCase() ?? '';

    if (name.contains('trial')) {
      return {
        'gradient': const LinearGradient(
          colors: [Color(0xFF4DA4F7), Color(0xFF3E81EF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'bgColor': null,
        'shadowColor': const Color(0xFF3E81EF).withOpacity(0.5),
        'subtitle': 'Experience the core features',
        'priceStr': '₹0',
        'periodStr': '14 Days Free',
        'features': ['Basic Herd Tracking', 'Daily Milk Records'],
      };
    } else if (name.contains('pro')) {
      return {
        'gradient': null,
        'bgColor': const Color(0xFF1D3FBB),
        'shadowColor': const Color(0xFF1D3FBB).withOpacity(0.4),
        'subtitle': 'Ultimate management tools',
        'priceStr': '₹999',
        'periodStr': 'Per Month',
        'features': ['All Basic Features', 'AI Health Insights', 'Priority Support'],
      };
    } else {
      // Basic or default
      return {
        'gradient': null,
        'bgColor': const Color(0xFF4181F0),
        'shadowColor': const Color(0xFF4181F0).withOpacity(0.5),
        'subtitle': 'Scale your daily operations',
        'priceStr': '₹499',
        'periodStr': 'Per Month',
        'features': ['Advanced Herd Tracking', 'Milk & Feed Records', 'Financial Reports'],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar / Top padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '9:41',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1C243D)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.signal_cellular_4_bar, size: 16, color: Color(0xFF1C243D)),
                      const SizedBox(width: 6),
                      const Icon(Icons.wifi, size: 16, color: Color(0xFF1C243D)),
                      const SizedBox(width: 6),
                      Icon(Icons.battery_full_outlined, size: 20, color: const Color(0xFF1C243D).withOpacity(0.8)),
                    ],
                  ),
                ],
              ),
            ),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  const Text(
                    'Select Your\nSubscription Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1C243D),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose the best plan to power your dairy business.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xFF6B7280).withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Carousel Section
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF4181F0)),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemCount: _plans.length,
                      itemBuilder: (context, index) {
                        final plan = _plans[index] as Map<String, dynamic>;
                        final meta = _getPlanMeta(plan);

                        // Price formatting
                        String priceDisplay = meta['priceStr'];
                        if (plan['price'] != null && double.tryParse(plan['price'].toString()) != null) {
                          double p = double.parse(plan['price'].toString());
                          if (p > 0) {
                            priceDisplay = '₹${p.toInt()}';
                          }
                        }

                        return AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: _currentPage == index ? 1.0 : 0.92,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _currentPage == index ? 1.0 : 0.75,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                              decoration: BoxDecoration(
                                color: meta['bgColor'],
                                gradient: meta['gradient'],
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: meta['shadowColor'],
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(36),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Plan Title
                                  Text(
                                    plan['name']?.toString() ?? '',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    meta['subtitle'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Price
                                  Text(
                                    priceDisplay,
                                    style: const TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    meta['periodStr'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300,
                                      color: const Color(0xFFE0E7FF).withOpacity(0.9),
                                    ),
                                  ),

                                  const Spacer(),

                                  // Features List
                                  Column(
                                    children: (meta['features'] as List<String>).map((feat) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.check, size: 16, color: Colors.white),
                                            ),
                                            const SizedBox(width: 14),
                                            Text(
                                              feat,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                  const SizedBox(height: 36),

                                  // Bottom Divider line
                                  Container(
                                    height: 2,
                                    width: size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Pagination Dots
            if (!_isLoading && _plans.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_plans.length, (index) {
                    bool isSelected = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSelected ? 36 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4181F0) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ),
            ],

            // Bottom Continue Action
            Container(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || _isSubscribing ? null : _handleSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3FB5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  elevation: 8,
                  shadowColor: const Color(0xFF1A3FB5).withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: _isSubscribing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
