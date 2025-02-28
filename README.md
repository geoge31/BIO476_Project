# Project - Spring 2024 
# `BIO-476`
## Team : @csd3927, @csd4748
---
<br><br>
Το dataset [**GDS6010**](https://github.com/geoge31/BIO476_Project/blob/main/GDS6010.soft) μετράει τις εκφράσεις γονιδίων σε άτομα προσβλημένα από influenza virus H5N1 και υγιή άτομα σε astrocytes U251 (cell lines). H μέτρηση έγινε σε τρεις χρονικές στιγμές: 6, 12 και 24 ώρες μετά τη μόλυνση. Για τις αντίστοιχες μετρήσεις έχουμε και τα controls. Το παρακάτω διάγραμμα δειχνει τον πειραματικό σχεδιασμό.

![image](https://github.com/geoge31/BIO476_Project/assets/146980540/195dff1a-e559-4da7-b149-196bc6971229)

Το link για το dataset είναι εδώ
https://www.ncbi.nlm.nih.gov/sites/GDSbrowser?acc=GDS6010

1. Κατεβάστε το dataset και φορτώστε το στην R
2. Χρησιμοποιήστε μόνο τα δείγματα που αντιστοιχούν στις 6 και στις 24 ώρες και χρησιμοποιήστε αυτές τις κατηγορίες ώς παράγοντα (factor) με 2 levels: 6 και 24.
3. Βρείτε ποια γονίδια διαφοροποιούνται μεταξύ των 6 και 24 ωρών παίρνοντας υπόψιν και τον παράγοντα infection (γραμμικά μοντέλα με 2 παράγοντες με αλληλεπίδραση).
4. Θεωρείτε ότι η μόλυνση με H5N1 προκαλεί συστημική αντίδραση στον οργανισμό (δηλαδή επηρεάζονται πολλά γονίδια) ή επηρεάζονται μόνο λίγα γονίδια;
5. Χρησιμοποιήστε την lm συνάρτηση ώστε να δείτε σε ένα μοντέλο με αλληηλεπίδραση ποιοι παράγοντες ειναι σημαντικοί.
6. Βρείτε ποια γονίδια επηρεάζονται μεταξύ control και H5N1 παίρνοντας υπόψιν τις ώρες μετά τη μόλυνση (πάρτε όλα τα δείγματα και χρησιμοποιήστε τον χρόνο όχι σαν ποσοτική μεταβλητή αλλά σαν ποιοτική. πχ όπως το φύλο, αλλά με 3 επίπεδα).
7. Για τα 100 γονίδια με το μικρότερο p-value, κατεβάστε τους υποκινητές τους με την biomart και βρείτε αν υπάρχει κάποιο TFBS (transcription factor bindding site) που υπεραντιπροσωπεύεται έναντι ενός τυχαίου συνόλου 1000 γονιδίων (γι αυτό πάαρτε 1000 τυχαία γονίδια από το microarray πείραμα και βρείτε τους υποκινητές τους).
8. *** bonus *** για το γονιδιο με το μικρότερο p-value βρείτε πόσα γονίδια συνεκρφάζονται με αυτό (χρησιμοποιώντας τη συνάρτηση cor, μπορείτε να υπολογίσετε το συντελεστη συσχέτισης μεταξύ 2 vector). Επαναλάβετε την ανάλυση 7 γι αυτά τα γονίδια ώστε να βρείτε τους TFBS. 
