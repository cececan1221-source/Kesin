import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/admob_service.dart';
import '../services/wallet_service.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.wallet});
  final WalletService wallet;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  bool _busy = false;
  BannerAd? _bannerAd;
  bool _bannerReady = false;

  Future<void> _watchAd() async {
    if (_busy) return;
    setState(() => _busy = true);
    final shown = await AdMobService.instance.showRewarded();
    if (!mounted) return;
    if (shown) {
      await widget.wallet.addPoints(AppConfig.pointsPerRewardedAd);
      setState(() {});
      _message('Reklam tamamlandı: +20 puan');
    } else {
      _message('Reklam henüz hazır değil. Birkaç saniye sonra tekrar dene.');
    }
    if (mounted) setState(() => _busy = false);
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    final ad = BannerAd(
      adUnitId: AppConfig.bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() { _bannerAd = ad as BannerAd; _bannerReady = true; });
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (mounted) setState(() => _bannerReady = false);
        },
      ),
    );
    _bannerAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard(),
      _tasks(),
      _earn(),
      _wallet(),
      _profile(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.task_outlined), selectedIcon: Icon(Icons.task), label: 'Görevler'),
          NavigationDestination(icon: Icon(Icons.play_circle_outline), selectedIcon: Icon(Icons.play_circle), label: 'Kazan'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Cüzdan'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _dashboard() => _page(
        'HakPay',
        [
          _pointsCard(),
          const SizedBox(height: 16),
          _section('Hızlı Kazanç'),
          _actionCard(
            icon: Icons.ondemand_video,
            title: 'Reklam İzle',
            subtitle: 'Test reklamını izle ve 20 puan kazan',
            onTap: _watchAd,
          ),
          const SizedBox(height: 12),
          _actionCard(
            icon: Icons.task_alt,
            title: 'Görevler',
            subtitle: 'Görevleri tamamlayarak puan kazan',
            onTap: () => setState(() => _tab = 1),
          ),
        ],
      );

  Widget _tasks() => _page('Görevler', [
        _task('Günlük giriş', 'Uygulamayı aç', 100),
        _task('Reklam testi', 'Ödüllü reklamı tamamla', 20),
        _task('Profilini tamamla', 'Profil bilgilerini doldur', 250),
      ]);

  Widget _earn() => _page('Kazan', [
        _actionCard(
          icon: Icons.play_arrow_rounded,
          title: 'Ödüllü Reklam İzle',
          subtitle: 'Google test reklamı • +20 puan',
          onTap: _watchAd,
        ),
        const SizedBox(height: 16),
        const Text(
          'Bu sürümde reklamlar Google’ın resmi test reklam birimleriyle çalışır. Gerçek reklam SDK’sı kullanılır; test gösterimleri gelir üretmez.',
          style: TextStyle(color: HakTheme.muted, height: 1.5),
        ),
      ]);

  Widget _wallet() => _page('Cüzdanım', [
        _pointsCard(),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Test bakiyesi'),
            subtitle: Text('Bu yeni projede puanlar yalnızca cihaz üzerinde test amaçlı tutulur.'),
          ),
        ),
      ]);

  Widget _profile() => _page('Profil', [
        const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('HakPay Kullanıcısı'),
            subtitle: Text('Yeni Flutter projesi'),
          ),
        ),
      ]);

  Widget _page(String title, List<Widget> children) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF12081F), HakTheme.bg],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: HakTheme.text)),
            const SizedBox(height: 20),
            ...children,
            const SizedBox(height: 18),
            _banner(),
          ],
        ),
      );

  Widget _pointsCard() => Card(
        elevation: 0,
        color: HakTheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              const Icon(Icons.monetization_on, size: 42, color: HakTheme.purple),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Toplam Puan', style: TextStyle(color: HakTheme.muted)),
                const SizedBox(height: 4),
                Text('${widget.wallet.points}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
              ]),
            ],
          ),
        ),
      );

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
      );

  Widget _actionCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) => Card(
        color: HakTheme.surface,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(backgroundColor: HakTheme.accent.withValues(alpha: .18), child: Icon(icon, color: HakTheme.purple)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: _busy ? null : onTap,
        ),
      );

  Widget _task(String title, String subtitle, int points) => Card(
        child: ListTile(
          leading: const Icon(Icons.check_circle_outline, color: HakTheme.purple),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Text('+$points', style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      );

  Widget _banner() {
    if (!_bannerReady || _bannerAd == null) return const SizedBox(height: 0);
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
