import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.barlowTextTheme()),
      title: 'Flutter Demo',
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(
              backgroundImage: 'assets/background.jpg',
              profileImage: 'assets/profile.jpg',
            ),
            const SizedBox(height: 80),

            const InfoCard(
              name: 'Aigrisson',
              subscribers: '87k',
              creationdate: '11 aout 2005',
            ),

            const QrCard(
              qrCodeImage: 'assets/qrcode.png',
              label: 'Tu me scannes ??',
            ),

            const SocialIconsRow(),

            const SizedBox(height: 32),
            // const TechSection(),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String backgroundImage;
  final String profileImage;

  const ProfileHeader({
    super.key,
    required this.backgroundImage,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // backgroud image
          Container(
            height: 220,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Colors.orange.withAlpha(100),
                //     Colors.orange.withAlpha(50),
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
              ),
            ),
          ),
          // Bouton partager en haut à droite
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 30),
              onPressed: () {
                // Partager quelque chose
              },
            ),
          ),
          // Photo de profil qui déborde en bas
          Positioned(
            bottom: 0,
            child: Transform.translate(
              offset: const Offset(0, 80),
              child: Container(
                height: 150,
                width: 150,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: AssetImage(profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String subscribers;
  final String creationdate;

  const InfoCard({
    super.key,
    required this.name,
    required this.subscribers,
    required this.creationdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha(50),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: InfoField(label: 'Posts', value: '42')),
              Expanded(child: InfoField(label: 'Abonnés', value: subscribers)),
              Expanded(child: InfoField(label: 'Abonnements', value: '150')),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Actif depuis $creationdate',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;

  const InfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }
}

class QrCard extends StatelessWidget {
  final String qrCodeImage;
  final String label;

  const QrCard({super.key, required this.qrCodeImage, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withAlpha(50),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.asset(qrCodeImage, width: 180),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final String url;

  const SocialIcon({
    super.key,
    required this.icon,
    required this.gradientColors,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {
          // Handle URL launch here
        },
      ),
    );
  }
}

class SocialIconsRow extends StatelessWidget {
  const SocialIconsRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SocialBox(
            icon: FontAwesomeIcons.flutter,
            gradientColors: const [
              Color(0xFFEA842B),
              Color.fromARGB(255, 237, 171, 114),
            ],
            url: 'https://flutter.dev',
          ),
          SocialBox(
            icon: FontAwesomeIcons.github,
            gradientColors: const [Color(0xFF333333), Color(0xFF555555)],
            url: 'https://github.com',
          ),
          SocialBox(
            icon: FontAwesomeIcons.linkedin,
            gradientColors: const [
              Color(0xFF0A66C2),
              Color(0xFF004182),
            ],
            url: 'https://linkedin.com',
          ),
          SocialBox(
            icon: FontAwesomeIcons.twitter,
            gradientColors: const [
              Color(0xFF1DA1F2),
              Color(0xFF0D8DDC),
            ],
            url: 'https://twitter.com',
          ),
          SocialBox(
            icon: FontAwesomeIcons.youtube,
            gradientColors: const [
              Color(0xFFFF0000),
              Color(0xFFCC0000),
            ],
            url: 'https://youtube.com',
          ),
            
        ],
      ),
    );
  }
}

class SocialBox extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final String url;

  const SocialBox({
    super.key,
    required this.icon,
    required this.gradientColors,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: FaIcon(icon, color: Colors.white),
      ),
    );
  }
}
