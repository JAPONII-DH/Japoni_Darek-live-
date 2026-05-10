# 🇯🇵 Japoni_Darek-live-
> **أداة احترافية لإدارة سكربتات DARK LIVE عبر بيئة Termux**

---

### 🚀 المميزات (Features)
* **تشغيل ذكي:** اختصار `japoni` للوصول السريع.
* **دعم سحابي:** متوافق مع Cloudflare Tunnel للتحكم عن بُعد.

---

### 📥 التثبيت (Installation)
انسخ الأوامر التالية وصقها في Termux:
```bash
pkg update && pkg upgrade -y
pkg install git bash -y
git clone [https://github.com/JAPONII-DH/Japoni_Darek-live-.git](https://github.com/JAPONII-DH/Japoni_Darek-live-.git)
cd Japoni_Darek-live-
chmod +x DARK.LIVE.sh
echo "alias japoni='cd ~/Japoni_Darek-live- && ./DARK.LIVE.sh'" >> ~/.bashrc && source ~/.bashrc
japoni
