# Packages installieren
install.packages("tidyverse")
install.packages("readr")
install.packages("readxl")

library(readr)
library(dplyr)
library(stringr)
# Import
Zulassungen_alle_Fahrzeuge <- read.csv2("Data/Zulassungen/Zulassungen_alle_Fahrzeuge.csv")
Komponente_K7 <- read.csv2("Data/Logistikverzug/Komponente_K7.csv")
Logistikverzug_K7 <- read.csv2("Data/Logistikverzug/Logistikverzug_K7.csv")




Fahrzeuge_OEM1_Typ11_Fehleranalyse <-read.csv("Data/Fahrzeug/Fahrzeuge_OEM1_Typ11_Fehleranalyse.csv")
Fahrzeuge_OEM1_Typ11 <-read.csv("Data/Fahrzeug/Fahrzeuge_OEM1_Typ11.csv")
Fahrzeuge_OEM1_Typ12 <-read.csv2("Data/Fahrzeug/Fahrzeuge_OEM1_Typ12.csv")
Fahrzeuge_OEM2_Typ21 <-read.csv("Data/Fahrzeug/Fahrzeuge_OEM2_Typ21.csv")
Fahrzeuge_OEM2_Typ22 <-read.csv2("Data/Fahrzeug/Fahrzeuge_OEM2_Typ22.csv")

Geodaten_Gemeinden <- read.csv2("Data/Geodaten/Geodaten_Gemeinden_v1.2_2017-08-22_TrR.csv")

Komponente_K4 <- read.csv2("Data/Komponente/Komponente_K4.csv")
Bestandteile_Komponente_K4 <- read.csv2("Data/Komponente/Bestandteile_Komponente_K4.csv")
Komponente_K3SG1 <- read.csv("Data/Komponente/Komponente_K3SG1.csv")
Bestandteile_Komponente_K3SG1 <- read.csv2("Data/Komponente/Bestandteile_Komponente_K3SG1.csv")
Bestandteile_Komponente_K3SG2 <- read.csv2("Data/Komponente/Bestandteile_Komponente_K3SG2.csv")

Einzelteil_T21 <- read.csv2("Data/Einzelteil/Einzelteil_T21.csv")
Einzelteil_T32 <- read.csv2("Data/Einzelteil/Einzelteil_T32.csv")

# filter cars without G3SG1 / G3SG2

Bestandteile_Fahrzeuge_OEM1_Typ11 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM1_Typ11.csv")
Bestandteile_Fahrzeuge_OEM1_Typ12 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM1_Typ12.csv")
Bestandteile_Fahrzeuge_OEM2_Typ21 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM2_Typ21.csv")
Bestandteile_Fahrzeuge_OEM2_Typ22 <- read.csv2("Data/Fahrzeug/Bestandteile_Fahrzeuge_OEM2_Typ22.csv")

# Fahrzeuge ohnee K3SG1 / K3SG2 untersuchen

ID_Fahrzeug_OEM1_Typ11_critical_shift <- Bestandteile_Fahrzeuge_OEM1_Typ11 %>%
  filter (str_detect(ID_Schaltung, "K3SG1") | str_detect(ID_Schaltung, "K3SG2"))  %>%
  select(ID_Fahrzeug)

ID_Fahrzeug_OEM1_Typ12_critical_shift <- Bestandteile_Fahrzeuge_OEM1_Typ12 %>%
  filter (str_detect(ID_Schaltung, "K3SG1") | str_detect(ID_Schaltung, "K3SG2"))  %>%
  select(ID_Fahrzeug) 

ID_Fahrzeug_OEM2_Typ21_critical_shift <- Bestandteile_Fahrzeuge_OEM2_Typ21 %>%
  filter (str_detect(ID_Schaltung, "K3SG1") | str_detect(ID_Schaltung, "K3SG2"))  %>%
  select(ID_Fahrzeug) 

ID_Fahrzeug_OEM2_Typ22_critical_shift <- Bestandteile_Fahrzeuge_OEM2_Typ22 %>%
  filter (str_detect(ID_Schaltung, "K3SG1") | str_detect(ID_Schaltung, "K3SG2"))  %>%
  select(ID_Fahrzeug)

ID_Fahrzeug_critical = rbind(ID_Fahrzeug_OEM1_Typ11_critical_shift, ID_Fahrzeug_OEM1_Typ12_critical_shift,ID_Fahrzeug_OEM2_Typ21_critical_shift,ID_Fahrzeug_OEM2_Typ22_critical_shift)

# zählen wieviel kaputt ist

percantage_defect_total = (sum(Fahrzeuge_OEM1_Typ11$Fehlerhaft)+sum(Fahrzeuge_OEM1_Typ12$Fehlerhaft)+sum(Fahrzeuge_OEM2_Typ21$Fehlerhaft)+sum(Fahrzeuge_OEM2_Typ22$Fehlerhaft))/nrow(Zulassungen_alle_Fahrzeuge)

Fahrzeuge_OEM1_Typ11 %>%
  filter(ID_Fahrzeug %in% ID_Fahrzeug_OEM1_Typ11_critical_shift) %>%
  defect_critical_shift_11 <- sum(Fahrzeuge_OEM1_Typ11$Fehlerhaft)
