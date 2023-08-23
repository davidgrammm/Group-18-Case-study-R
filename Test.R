# Packages installieren
install.packages("tidyverse")
install.packages("readr")
install.packages("readxl")

library(readr)

# Import
Zulassungen_alle_Fahrzeuge <- read.csv2("Data/Zulassungen/Zulassungen_alle_Fahrzeuge.csv")
Komponente_K7 <- read.csv2("Data/Logistikverzug/Komponente_K7.csv")
Logistikverzug_K7 <- read.csv2("Data/Logistikverzug/Logistikverzug_K7.csv")
Komponente_K7_original <- read.csv2("Data/Komponente/Komponente_K7.csv")


Bestandteile_Fahrzeuge_OEM1_Typ11 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM1_Typ11.csv")
Bestandteile_Fahrzeuge_OEM1_Typ12 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM1_Typ12.csv")
Bestandteile_Fahrzeuge_OEM2_Typ21 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM2_Typ21.csv")
Bestandteile_Fahrzeuge_OEM2_Typ22 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM2_Typ22.csv")

Fahrzeuge_OEM1_Typ11_Fehleranalyse <-read.csv("Data/Fahrzeug/Fahrzeuge_OEM1_Typ11_Fehleranalyse.csv")
Fahrzeuge_OEM1_Typ11 <-read.csv("Data/Fahrzeug/Fahrzeuge_OEM1_Typ11.csv")
Fahrzeuge_OEM1_Typ12 <-read.csv2("Data/Fahrzeug/Fahrzeuge_OEM1_Typ12.csv")
Fahrzeuge_OEM2_Typ21 <-read.csv("Data/Fahrzeug/Fahrzeuge_OEM2_Typ21.csv")
Fahrzeuge_OEM2_Typ22 <-read.csv2("Data/Fahrzeug/Fahrzeuge_OEM2_Typ22.csv")

Geodaten_Gemeinden <- read.csv2("Data/Geodaten/Geodaten_Gemeinden_v1.2_2017-08-22_TrR.csv")

Komponente_K4 <- read.csv2("Data/Komponente/Komponente_K4.csv")
Bestandteile_Komponente_K4 <- read.csv2("Data/Komponente/Bestandteile_Komponente_K4.csv")
Komponente_K3SG2 <- read.csv("Data/Komponente/Komponente_K3SG2.csv")
Bestandteile_Komponente_K3SG2 <- read.csv2("Data/Komponente/Bestandteile_Komponente_K3SG2.csv")

Einzelteil_T21 <- read.csv2("Data/Einzelteil/Einzelteil_T21.csv")
