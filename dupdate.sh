#!/bin/bash

#datei ausführbar machen und ausführen
# chmod -c u+x dupdate.sh
# ./update.sh
# wget https://www.drupal.org/files/projects/drupal-x.x.tar.gz


echo "_________________________________________________________"
echo ""
echo "Willkommen beim Drupal8 -Update-Script!"
echo "_________________________________________________________"
echo ""
echo "|wir sind hier"      
echo "|drupalupdate.sh"     
echo "        |_______________"
echo "                        Hier ist deine Drupalinstallation"
echo "_________________________________________________________"
echo "_________________________________________________________"

#wartungsmodus! (und db-backup!)
echo -e "\033[31m \033[1mBitte wechsel JETZT in den Browser zur Weboberfläche,\033[1m \033[0m"
echo -e "\033[31m \033[1m     - sichere die Datenbank mittels MSD \033[1m \033[0m" 
echo -e "\033[31m \033[1m     - und versetze die Seite in den Wartungsmodus\033[1m \033[0m"
echo " "
echo "_________________________________________________________"
echo "_________________________________________________________"
echo "_________________________________________________________"
echo ""
read -p "Wenn du das erledigt hast, hier weitermachen mit Enter"
echo ""
echo "_________________________________________________________"
echo ""
echo "Als Erstes holen wir uns die gewünschte Drupalversion!"
echo ""
echo -e "Benötigt wird nur die Versionsnummer, Format\033[31m \033[1m x.x.x \033[1m \033[0m."
echo ""
read -p "Geb die gewünschte Versionnummer ein: " version


wget https://www.drupal.org/files/projects/drupal-${version}.tar.gz

# todo: abfrage, ob drupal-${version}tar.gz existiert, download erledigt wurde
# sonst fehlerausgabe erneute versionsabfrage + wget

echo ""
read -p "Jetzt werden alle Unterverzeichnisse ermittelt, taste die Entertaste"
echo ""
echo "_________________________________________________________"
echo "" 
find -maxdepth 1 -type d 

echo ""
echo "_________________________________________________________"
echo ""

#variable $ordner mit verzeichnisname füllen
read -p "Gib den Verzeichnisnamen der zu aktualisierenden Drupalinstallation ein:" ordner

while [ ! -d "$ordner" ]; do
    echo "$ordner existiert nicht, Tappsfähla?"
    echo " "
    read -p "Gib den Verzeichnisnamen nochmal ein:" ordner
done
echo ""
if [ -d "$ordner" ]; then
    echo "Prima, kein Tippfehler, '$ordner' existiert"
    echo " "
fi

echo ""
echo "_________________________________________________________"
echo ""
read -p "Nun wird das Verzeichnisbackup erstellt - leg los mit Enter"


#backup des orginalverzeichnisses
tar -czvf Backup_${ordner}_vor_Update_auf_Version_${version}_$(date +%F__%H.%M).tar.gz $ordner/
echo "              ."
echo "              ."
echo "              ."
echo "              ."
echo "Backup_$ordner"."_vor_Update_auf_Version_$version_"."$(date +%F__%H.%M).tar.gz wurde erstellt -"
echo " "
echo ""
echo "_________________________________________________________"
echo "_________________________________________________________"
echo ""



#drupal entpacken
tar -xzf drupal-${version}.tar.gz -C $ordner/

rm drupal-${version}.tar.gz

sleep 1
echo  "Drupalzip wurde entpackt und gelöscht"
echo ""
echo "_________________________________________________________"
echo ""
#ins seitenverzeichnis wechseln
cd $ordner

#core und vendor in core-del und vendor-del umbenennen
mv core core-del
mv vendor vendor-del
sleep 1
echo  "Alte Dateien wurden gelöscht"
echo ""
echo "_________________________________________________________"
echo ""

#ins drupalverzeichnis runterwechseln und alles eins höher kopieren mit
cd drupal-$version
#mv *   ../
cp * -r  ../

sleep 1
echo  "Neue Dateien wurden installiert"
echo ""
echo "_________________________________________________________"
echo ""

#hochwechseln
cd ..

#drupalinstallverz löschen, core-del und vendor-del löschen
chmod -R 777 vendor-del drupal-$version
rm -r core-del vendor-del drupal-$version


#update laufen lassen
echo "Geschafft!"
echo ""
echo -e "\033[1m \033[32m Jetzt:  "
echo ""
echo -e "      bitte update.php via Weboberfläche durchlaufen lassen "
echo -e "      und die Seite aus dem Wartungsmodus nehmen "
echo -e "      und Seitenfunktionalität testen  \033[0m"

echo ""
echo "_________________________________________________________"
echo "_________________________________________________________"
echo ""
echo "Das wars, auf Wiedersehen!"
echo ""
echo ""


exit 0
