import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'M1 - login_screen.dart';
import 'M3 - home_screen.dart';

// --- Colors from HTML ---
const Color cSurface = Color(0xfff8f9ff);
const Color cOnSurface = Color(0xff011d35);
const Color cOnSurfaceVariant = Color(0xff43474f);
const Color cPrimary = Color(0xff001736);
const Color cPrimaryContainer = Color(0xff002b5b);
const Color cOnPrimaryContainer = Color(0xff7594ca);
const Color cSurfaceContainerLowest = Color(0xffffffff);
const Color cOutlineVariant = Color(0xffc4c6d0);
const Color cOutline = Color(0xff747780);
const Color cSurfaceContainer = Color(0xffe4efff);
const Color cSurfaceContainerHigh = Color(0xffdbe9ff);
const Color cOnTertiaryFixedVariant = Color(0xff2e4962);
const Color cOnPrimary = Color(0xffffffff);

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogout() async {
    setState(() => _isLoading = true);
    // Ideally we would pass the refresh token, but for now we simulate or call a generic logout
    await _authService.logout();
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cSurface,
      body: Stack(
        children: [
          SingleChildScrollView(
            // pb-40 in HTML is approx 160px for the bottom nav bar space
            padding: const EdgeInsets.only(left: 20, right: 20, top: 48, bottom: 160),
            child: Column(
              children: [
                _buildProfileSection(),
                const SizedBox(height: 16), // space-y-stack-md
                _buildSettingsList(),
              ],
            ),
          ),
          
          // Floating Action Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 88, // bottom-[88px] in HTML
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Business Category change
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(accessToken: ''), // Empty token for now, or fetch from storage
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 384), // max-w-sm
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF002B5B), Color(0xFF405F91)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.category, color: cOnPrimary, size: 24),
                        SizedBox(height: 4),
                        Text(
                          "Change Business Category",
                          style: TextStyle(
                            color: cOnPrimary,
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: cPrimaryContainer)),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24), // py-stack-lg
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 96, // w-24
                height: 96, // h-24
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cSurfaceContainerHigh, width: 4),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuCTKgmZqum6sJaInjyb-OZ4IZcyOavVu_F8Ux7cjH88LLNJC3tEpy0OOy4BWeiAd0PeodcDZnKx5OsfAbxKNadTofoyeQbr41zaJaTqHOeX_rrLC6igZxUzA4xCU8WH5sKd0h7bXCNg0fO900G9q_1Y-ldRFm0fMpXaICuzPQIRvsraeLTxY39LGlZkKeNahV9rfo6laHXOLVJq4o0NkTKxXP4MexQIlrup5xkMHyoOGKhlHxtfs1BoEErhRIFRomDACwPNOou7DInW",
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4), // p-1
                  decoration: BoxDecoration(
                    color: cPrimaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: cSurface, width: 2),
                  ),
                  child: const Icon(Icons.verified, color: cOnPrimaryContainer, size: 18),
                ),
              ),
            ],
          ),
          const Text(
            "Rajesh Kumar",
            style: TextStyle(
              color: cPrimary,
              fontFamily: 'Manrope',
              fontSize: 24, // headline-md
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: cOnSurfaceVariant,
              ),
              children: [
                TextSpan(text: "Farm ID: DK-8829 | "),
                TextSpan(
                  text: "Premium Plan",
                  style: TextStyle(
                    color: cOnTertiaryFixedVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildSettingCard(
          icon: Icons.lock,
          title: "Edit Login Credentials",
          subtitle: "Manage your security",
          onTap: () {
            // Navigator.push to edit credentials
          },
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: Icons.notifications,
          title: "Notification Settings",
          subtitle: "Configure alerts and news",
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: Icons.palette,
          title: "App Theme",
          subtitle: "Light Mode",
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: Icons.language,
          title: "App Language",
          subtitle: "English",
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: Icons.workspace_premium,
          title: "Subscription Plan",
          subtitle: "Pro Monthly Plan",
          isSubtitleBold: true,
          subtitleColor: cPrimary,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        // Added Logout Button based on plan
        _buildSettingCard(
          icon: Icons.logout,
          title: "Log Out",
          subtitle: "Sign out of your account",
          onTap: _handleLogout,
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isSubtitleBold = false,
    Color subtitleColor = cOnSurfaceVariant,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16), // p-stack-md
          decoration: BoxDecoration(
            color: cSurfaceContainerLowest,
            border: Border.all(color: cOutlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cSurfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: cPrimary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14, // label-lg
                        fontWeight: FontWeight.w600,
                        color: cOnSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14, // body-sm
                        fontWeight: isSubtitleBold ? FontWeight.w600 : FontWeight.w400,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: cOutline, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
