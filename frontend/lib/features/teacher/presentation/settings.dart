import 'package:flutter/material.dart';
import '../../auth/presentation/login_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool riskAlerts = true;

  @override
  Widget build(BuildContext context) {

    const primary = Color(0xFF137FEC);
    const backgroundDark = Color(0xFF101922);

    return Scaffold(
      backgroundColor: backgroundDark,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Ayarlar & Profil",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PROFİL FOTO
              Stack(
                children: [

                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuCKoDXNIwHZRA8uWKcJ5cLbpHf25mcT_DE7pmvugDCmnApcl0I8kk3ETGbrB9IZ3tP9OWVlp0YO1Fmjkgyn9qluPfHiVNzJPp1dEHQtR1pK_aRwGeQtGc8K0nTUCQaE9i95em1DcpThXY01lNXYKsn1eqLvbtAs_C7m7Cl-iBf1jR9UTtqDEF_XZ90NwutPqUpK_bTQbfGEn4xUGlX6APpayGV_Ux5HnSC55RgZIk-vjcNAplflT1mv0cUsK3fphNepmU4jVMdGozJY"),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(Icons.edit,color: Colors.white,size: 18),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Dr. Selin Yılmaz",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),

              const SizedBox(height: 4),

              const Text(
                "Kıdemli Rehberlik Danışmanı",
                style: TextStyle(color: Colors.white60),
              ),

              const SizedBox(height: 6),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school,color: Colors.white54,size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Merkez Lisesi",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// HESAP AYARLARI
              _sectionTitle("Hesap Ayarları"),

              _settingTile(
                icon: Icons.person,
                title: "Kişisel Bilgiler",
                subtitle: "Ad, Email, Telefon",
              ),

              _settingTile(
                icon: Icons.lock,
                title: "Şifre Değiştir",
                subtitle: "Son güncelleme 3 ay önce",
              ),

              const SizedBox(height: 20),

              /// UYGULAMA AYARLARI
              _sectionTitle("Uygulama Tercihleri"),

              SwitchListTile(
                value: riskAlerts,
                activeColor: primary,
                secondary: const Icon(Icons.notifications,color: primary),
                title: const Text(
                  "Yüksek Risk Bildirimleri",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Anlık bildirim al",
                  style: TextStyle(color: Colors.white54),
                ),
                onChanged: (value) {
                  setState(() {
                    riskAlerts = value;
                  });
                },
              ),

              _settingTile(
                icon: Icons.language,
                title: "Dil Seçimi",
                subtitle: "Türkçe",
              ),

              _settingTile(
                icon: Icons.palette,
                title: "Tema",
                subtitle: "Karanlık Mod",
              ),

              const SizedBox(height: 20),

              /// GİZLİLİK
              _sectionTitle("Gizlilik & Destek"),

              _settingTile(
                icon: Icons.shield,
                title: "Veri Gizliliği & KVKK",
              ),

              _settingTile(
                icon: Icons.support_agent,
                title: "Teknik Destek",
              ),

              _settingTile(
                icon: Icons.description,
                title: "Kullanım Şartları",
              ),

              const SizedBox(height: 30),

              /// ÇIKIŞ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(.2),
                    foregroundColor: Colors.red,
                    minimumSize: const Size(double.infinity,55),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Çıkış Yap"),
                  onPressed: () {
                    // Çıkış işlemi burada yapılacak
                    // Örneğin, kullanıcı oturumu kapatılabilir ve giriş ekranına yönlendirilebilir
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "RIBA Uygulaması v2.4.1",
                style: TextStyle(color: Colors.white38,fontSize: 12),
              ),

              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20,vertical:8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    String? subtitle
  }){
    return ListTile(
      leading: Icon(icon,color: const Color(0xFF137FEC)),
      title: Text(title,style: const TextStyle(color: Colors.white)),
      subtitle: subtitle!=null
          ? Text(subtitle,style: const TextStyle(color: Colors.white54))
          : null,
      trailing: const Icon(Icons.chevron_right,color: Colors.white38),
    );
  }
}

