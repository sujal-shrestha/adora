import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Simple model for an ad
class Ad {
  final int id;
  final String title;
  final String description;
  final String brand;
  final String imageUrl;
  final String link;

  const Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.brand,
    required this.imageUrl,
    required this.link,
  });
}

/// Mock data by niche
const Map<String, List<Ad>> mockAdData = {
  'Fitness': [
    Ad(
      id: 1,
      title: "Burn Fat Fast with 15-Min Workouts",
      description: "Get in shape without a gym. Real results in weeks!",
      brand: "FitNation",
      imageUrl:
          "https://www.hearstmagazines.co.uk/media/catalog/product/cache/51953653fdef8ef18ec1474aa5cd7e22/1/5/15minweightloss_7.jpg",
      link: "https://www.facebook.com/ads/library/?id=123456789",
    ),
    Ad(
      id: 2,
      title: "Home Fitness Plan for Busy Professionals",
      description: "No equipment needed. Transform your body at home.",
      brand: "CoreX",
      imageUrl:
          "https://sfhealthtech.com/cdn/shop/articles/guy-training-home.jpg?v=1638186084",
      link: "https://www.facebook.com/ads/library/?id=987654321",
    ),
  ],
  'Skincare': [
    Ad(
      id: 3,
      title: "Glow Up with Natural Skincare",
      description: "Vegan-friendly, dermatologist-approved glow kit.",
      brand: "LushCare",
      imageUrl:
          "https://cdn.dribbble.com/userupload/38635102/file/original-c1c44c3443731e6467f488e428821d9a.jpg?resize=400x0",
      link: "https://www.facebook.com/ads/library/?id=2233445566",
    ),
    Ad(
      id: 4,
      title: "Erase Acne in 7 Days",
      description: "Join thousands who cleared their skin with ClearZen.",
      brand: "ClearZen",
      imageUrl:
          "https://mir-s3-cdn-cf.behance.net/project_modules/fs/b2892a73497731.5c0b2d9e3b61a.jpg",
      link: "https://www.facebook.com/ads/library/?id=6655443322",
    ),
  ],
  'Finance': [
    Ad(
      id: 5,
      title: "Start Investing with Just \$5",
      description: "No experience needed. Learn and grow your savings.",
      brand: "WealthStep",
      imageUrl:
          "https://www.creatopy.com/blog/wp-content/uploads/2019/09/house-insurance-hands-giving-house-439x600.jpg",
      link: "https://www.facebook.com/ads/library/?id=9988776655",
    ),
    Ad(
      id: 6,
      title: "Get Funded in 24 Hours",
      description: "Apply now and get up to \$10K for your side hustle.",
      brand: "FundFlash",
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwpnspK6KduH6aOA-3Ma8l59OCi08u1FMknw&s",
      link: "https://www.facebook.com/ads/library/?id=5544332211",
    ),
  ],
};

/// The main Spy Tool screen
class SpyToolView extends StatefulWidget {
  const SpyToolView({super.key});

  @override
  State<SpyToolView> createState() => _SpyToolViewState();
}

class _SpyToolViewState extends State<SpyToolView> {
  String _selectedNiche = mockAdData.keys.first;
  Timer? _redirectTimer;

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  Future<void> _openFacebookAdsLibrary() async {
    // Show a non-dismissible dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text("Opening Meta Ads Library…"),
          ],
        ),
      ),
    );

    // After a short delay, launch the library and close the dialog
    _redirectTimer = Timer(const Duration(seconds: 2), () async {
      Navigator.of(context).pop(); // close the dialog

      const libraryUrl =
          'https://www.facebook.com/ads/library';

      final uri = Uri.parse(libraryUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Ads Library')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ads = mockAdData[_selectedNiche]!;

    return Scaffold(
      appBar: AppBar(title: const Text("🕵️ Ads Spy Tool")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Open Library Button
            Center(
              child: ElevatedButton(
                onPressed: _openFacebookAdsLibrary,
                child: const Text("Open Facebook Ads Library"),
              ),
            ),
            const SizedBox(height: 24),

            // Niche selector
            Text("Browse Top Ads by Niche", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: mockAdData.keys.map((niche) {
                  final isSelected = niche == _selectedNiche;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(niche),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedNiche = niche),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Top Ads:", style: TextStyle(fontWeight: FontWeight.bold)),

            // Ads list
            Expanded(
              child: ListView.builder(
                itemCount: ads.length,
                itemBuilder: (_, i) {
                  final ad = ads[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(ad.imageUrl, width: 64, height: 64, fit: BoxFit.cover),
                      ),
                      title: Text(ad.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ad.brand, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(ad.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      onTap: () async {
                        final uri = Uri.parse(ad.link);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open ad link')),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
