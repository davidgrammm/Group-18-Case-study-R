install.packages("tidyverse")
install.packages("dplyr")
install.packages("readr")
install.packages("readxl")

library(readr)
library(dplyr)
# Einzelteil T21 importieren (andere Einzelteile vorerst nich relevant für uns)
Einzelteil_T21 <- read_delim("Data/Einzelteil/Einzelteil_T21.csv")

# Stücklisten der kritischen Kupplungen K3SG1 / K3SG2 importieren
Bestandteile_Komponente_K3SG1 <- read_delim("Data/Komponente/Bestandteile_Komponente_K3SG1.csv")
Bestandteile_Komponente_K3SG2 <- read_delim("Data/Komponente/Bestandteile_Komponente_K3SG2.csv")

# Komponenten K3SG1 / K3SG2 importieren
Komponente_K3SG1 <- read_delim("Data/Komponente/Komponente_K3SG1.csv")
Komponente_K3SG2 <- read_delim("Data/Komponente/Komponente_K3SG2.csv")

# Stücklisten der vier Fahrzeugmodelle importieren
Bestandteile_Fahrzeug_Typ11 <- read_delim("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM1_Typ11.csv")
Bestandteile_Fahrzeug_Typ12 <- read_delim("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM1_Typ12.csv")
Bestandteile_Fahrzeug_Typ21 <- read_delim("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM2_Typ21.csv")
Bestandteile_Fahrzeug_Typ22 <- read_delim("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM2_Typ22.csv")

# Zulassungen und Geodaten importieren
Zulassungen <- read_delim("Data/Zulassungen/Zulassungen_alle_Fahrzeuge.csv")
Geodaten <- read_delim("Data/Geodaten/Geodaten_Gemeinden_v1.2_2017-08-22_TrR.csv")

# Daten zum Teil T21 mit den Schaltungen K3SG1/K3GSG2 joinen, in denen T21 verbaut ist
# in den Stücklisten von K3SG1 / K3SG2 ist angegeben, welches T21 verbaut ist
K3SG1_Einzelteil <- inner_join(Einzelteil_T21,Bestandteile_Komponente_K3SG1, by = "ID_T21") %>%                 
  select(ID_T21, Fehlerhaft_T21 = Fehlerhaft, Fehlerhaft_T21_Datum = Fehlerhaft_Datum, ID_Schaltung = ID_K3SG1)

K3SG2_Einzelteil <- inner_join(Einzelteil_T21,Bestandteile_Komponente_K3SG2, by = "ID_T21") %>%
  select(ID_T21, Fehlerhaft_T21 = Fehlerhaft, Fehlerhaft_T21_Datum = Fehlerhaft_Datum, ID_Schaltung = ID_K3SG2)

K3SG1_K3SG2_Einzelteil <- rbind(K3SG1_Einzelteil,K3SG2_Einzelteil)

# die Stücklisten von K3SG1 muss aufgeräumt werden (.x und .y Spalten)
# Fehlerhaft Spalten umbenennen, da gleichnamige Spalten für T21
Komponente_K3SG1_cleaned <- Komponente_K3SG1 %>% 
  mutate(Fehlerhaft_Schaltung = coalesce(Fehlerhaft.x, Fehlerhaft.y)) %>%
  mutate(Fehlerhaft_Schaltung_Datum = coalesce(Fehlerhaft_Datum.x, Fehlerhaft_Datum.y)) %>%
  mutate(ID_Schaltung = coalesce(ID_Schaltung.x, ID_Schaltung.y)) %>%
  select(-Fehlerhaft.x, -Fehlerhaft.y,-Fehlerhaft_Datum.x,-Fehlerhaft_Datum.y, -ID_Schaltung.x, -ID_Schaltung.y)

Komponente_K3SG2_cleaned <- Komponente_K3SG2 %>% 
  rename(Fehlerhaft_Schaltung = Fehlerhaft)%>% 
  rename(Fehlerhaft_Schaltung_Datum = Fehlerhaft_Datum)

# Die T21 Einzelteildaten, die über die Stücklisten den Schaltungen zugeordnet werden konnten,
# werden nun in einer Tabelle mit den Komponentendaten der Schaltungen kombiniert
K3SG1_Komponente_fertig <- inner_join(K3SG1_K3SG2_Einzelteil,Komponente_K3SG1_cleaned, by = "ID_Schaltung") %>% 
  select(ID_T21, ID_Schaltung, Fehlerhaft_T21, Fehlerhaft_T21_Datum, Fehlerhaft_Schaltung, Fehlerhaft_Schaltung_Datum)

K3SG2_Komponente_fertig <- inner_join(K3SG1_K3SG2_Einzelteil,Komponente_K3SG2_cleaned, by = "ID_Schaltung") %>% 
  select(ID_T21, ID_Schaltung, Fehlerhaft_T21, Fehlerhaft_T21_Datum, Fehlerhaft_Schaltung, Fehlerhaft_Schaltung_Datum)

# Die Daten der Komponenten K3SG1 / K3SG2 werden miteinander kombiniert
Komponenten_fertig <- rbind(K3SG1_Komponente_fertig,K3SG2_Komponente_fertig)

# Umbenennen der Stückliste von Fahrzeug_Typ22, damit sich diese mit den anderen Stücklisten kombinieren lässt
Bestandteile_Fahrzeug_Typ22 <- Bestandteile_Fahrzeug_Typ22 %>% 
  rename(...1 = X1)

# Kombinieren der Stücklisten der 4 Fahrzeugmodelle
Bestandteile_Fahrzeuge <- rbind(Bestandteile_Fahrzeug_Typ11,Bestandteile_Fahrzeug_Typ12,Bestandteile_Fahrzeug_Typ21,Bestandteile_Fahrzeug_Typ22)

# Über die Stücklisten kann jedem Fahrzeug die Verbaute Kupplung zugeordnet werden
# Der verbauten Kupplung wurden bereits die Daten zum verbauten T21 zugeordnet
Bestandteile_Komponenten <- inner_join(Komponenten_fertig,Bestandteile_Fahrzeuge, by="ID_Schaltung")%>% 
  select(ID_T21, ID_Schaltung, Fehlerhaft_T21, Fehlerhaft_T21_Datum, Fehlerhaft_Schaltung, Fehlerhaft_Schaltung_Datum, ID_Fahrzeug)

# Nun kann das Dataset mit den Fahrzeugdaten gejoined werden. Hier ist aber nur Fehlerfhaft
# und Fehlerhaft Datum relevant. Das Produktionsdatum spielt keine Rolle, der Rest der 
# Informationen ist in der ID enthalten

Fahrzeuge_OEM1_Typ11 <- select(Fahrzeuge_OEM1_Typ11, ID_Fahrzeug, Fehlerhaft, Fehlerhaft_Datum)
Fahrzeuge_OEM1_Typ12 <- select(Fahrzeuge_OEM1_Typ12, ID_Fahrzeug, Fehlerhaft, Fehlerhaft_Datum)
Fahrzeuge_OEM2_Typ21 <- select(Fahrzeuge_OEM2_Typ21, ID_Fahrzeug, Fehlerhaft, Fehlerhaft_Datum)
Fahrzeuge_OEM2_Typ22 <- select(Fahrzeuge_OEM2_Typ22, ID_Fahrzeug, Fehlerhaft, Fehlerhaft_Datum)


Bestandteile_Komponenten_Fahrzeuge <- Bestandteile_Komponenten %>%
  left_join(rbind(Fahrzeuge_OEM1_Typ11,Fahrzeuge_OEM1_Typ12,Fahrzeuge_OEM2_Typ21,Fahrzeuge_OEM2_Typ22), by = "ID_Fahrzeug") 

Bestandteile_Komponenten_Fahrzeuge <- Bestandteile_Komponenten_Fahrzeuge %>%  
  rename(Fehlerhaft_Fahrzeug = Fehlerhaft)%>% 
  rename(Fehlerhaft_Fahrzeug_Datum = Fehlerhaft_Datum)
  

# Um jedem Fahrzeug die Zulassung zuzuordnen, muss IDNummer in ID_Fahrzeug umbenannt werden
Zulassungen_column_renamed <- Zulassungen %>% 
  rename(ID_Fahrzeug = IDNummer)

# jedem Fahrzeug werden die Zulassungsdaten zugeordnet
Zulassungen_Bestandteile_Komponenten_Fahrzeuge <- inner_join(Bestandteile_Komponenten_Fahrzeuge,Zulassungen_column_renamed, by="ID_Fahrzeug") %>%
  select(ID_T21, ID_Schaltung, Fehlerhaft_T21, Fehlerhaft_T21_Datum, Fehlerhaft_Schaltung, Fehlerhaft_Schaltung_Datum, ID_Fahrzeug,Fehlerhaft_Fahrzeug,Fehlerhaft_Fahrzeug_Datum, Gemeinde=Gemeinden, Zulassung)

# jedem Fahrzeug inklusive Zulassung werden die Geodaten dieser Zulassung zugeordnet
Geodaten_Zulassung_Bestandteile_Komponenten_Fahrzeuge <- left_join(Zulassungen_Bestandteile_Komponenten_Fahrzeuge, Geodaten, by="Gemeinde") %>% 
  select(ID_T21, ID_Schaltung, Fehlerhaft_T21, Fehlerhaft_T21_Datum, Fehlerhaft_Schaltung, Fehlerhaft_Schaltung_Datum, ID_Fahrzeug,Fehlerhaft_Fahrzeug,Fehlerhaft_Fahrzeug_Datum, Gemeinde, Zulassung, Postleitzahl, Laengengrad, Breitengrad)


#FÜR DIE DOKU MUSS HIER NOCH EIN BEFEHL REIN, MIT DEM RAUSGEFUNDEN WURDE, DASS FÜR SEEG DIE DATEN FEHLEN
# Für die Gemeinde SEEG fehlen die Geodaten, diese müssen deshalb nachgepflegt werden
Geodaten_Zulassung_Bestandteile_Komponenten_Fahrzeuge $Laengengrad[Geodaten_Zulassung_Bestandteile_Komponenten$Gemeinde == "SEEG"] <- "10.6104157" #Laengengrad nachpflegen
Geodaten_Zulassung_Bestandteile_Komponenten_Fahrzeuge $Breitengrad[Geodaten_Zulassung_Bestandteile_Komponenten$Gemeinde == "SEEG"] <- "47.6542215" #Breitengrad nachpflegen
Geodaten_Zulassung_Bestandteile_Komponenten_Fahrzeuge $Postleitzahl[Geodaten_Zulassung_Bestandteile_Komponenten$Gemeinde == "SEEG"] <- "87637"     #PLZ nachpflegen

# Prüfen, in wievielen verschiedenen Gemeinden betroffene Autos zugelassen sind
# So kann überprüft werden, ob potentiell überhaupt genug Geodaten zur Verfügung stehen
anz_unique_gemeinden <- length(unique(Geodaten_Zulassung_Bestandteile_Komponenten_Fahrzeuge $Gemeinde))
print(anz_unique_gemeinden)

# Tatsächlich stehen ausreichend Geodaten zur Verfügung, im nächsten Schritt muss überprüft werden,
# ob jeder Zulassung auch ein Langen und Breitengrad zugeteilt werden kann

print(paste("Zulassungen ohne zugehörige PostleitzahL:",sum(is.na(Geodaten_Zulassung_Bestandteile_Komponenten_Fahrzeuge $Postleitzahl))))

#TO DO:
# Anstatt immmer 10 Zeilen zu selecten, vlt einfach 2 Zeilen rauswerfen (man kann auch irgendwie select(-c(...))) machen

# UNTERE TO DOs sind erledigt
# TO Do: Fahrzeuglisten OEM2 Produktionsdatum aus den zwei Spalten erzeugen, um Join mit OEM1 Fahrzeugen zu ermöglichen
# Das Dataset Geodaten_Zulassung_Bestandteile_Komponenten mit Fahrzeuge joinen, um Daten zu erhalten, ob Fahrzeuge kaputt sind
# AAABER evtl. unnötig, wenn Produktionsdatum immer Zulassungsdatum -1: Dann kann man Produktionsdatum komplett ignorieren


# (der zweite Schritt sollte evtl. vor den Geodaten erfolgen. Die Reihenfolge ist eigentlich egal, so ist es jedoch intuitiver)
# TO Do: gucken ob die Geodaten alle Passen oder ob da was fehlt. Es ist dann gut, wenn jeder Zulasssung ein Laengengrad+ Breitengrad zugeordnet werdne kann

