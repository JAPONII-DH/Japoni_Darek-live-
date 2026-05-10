# 🇯🇵 Japoni_Darek-live-
> **أداة احترافية لإدارة سكربتات DARK LIVE عبر بيئة Termux**

---

### 🚀 المميزات (Features)
* **تشغيل ذكي:** اختصار `japoni` للوصول السريع.
* **تكامل مع الهاتف:** تخزين الملفات في الذاكرة الداخلية لسهولة التعديل.
* **دعم سحابي:** متوافق مع Cloudflare Tunnel للتحكم عن بُعد.

---

### 📥 التثبيت (Installation)
انسخ الأوامر التالية وصقها في Termux ليتم تثبيت كل شيء تلقائياً:

```bash
pkg update && pkg upgrade -y
pkg install git bash -y
termux-setup-storage
git clone [https://github.com/JAPONII-DH/Japoni_Darek-live-.git](https://github.com/JAPONII-DH/Japoni_Darek-live-.git)
cd Japoni_Darek-live-
mkdir -p /sdcard/JAPONI-MOD
cp DARK.LIVE.sh /sdcard/JAPONI-MOD/
cp *.php /sdcard/JAPONI-MOD/
chmod +x /sdcard/JAPONI-MOD/DARK.LIVE.sh
ln -sf /sdcard/JAPONI-MOD/DARK.LIVE.sh $PREFIX/bin/japoni
japoni
