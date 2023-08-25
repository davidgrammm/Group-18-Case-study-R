install.packages("tidyverse")
install.packages("dplyr")
install.packages("readr")
install.packages("readxl")

library(readr)
library(dplyr)

Einzelteil_T21 <- read_delim("~/Nextcloud/Shared/IDA_CaseStudy_2023/Case_Study_Group_18/Data/Einzelteil/Einzelteil_T21.csv")
Komponente_K3SG1 <- read_delim("~/Nextcloud/Shared/IDA_CaseStudy_2023/Case_Study_Group_18/Data/Komponente/Bestandteile_Komponente_K3SG1.csv")
Komponente_K3SG2 <- read_delim("~/Nextcloud/Shared/IDA_CaseStudy_2023/Case_Study_Group_18/Data/Komponente/Bestandteile_Komponente_K3SG2.csv")
print(head(Einzelteil_T21))
print(head(Komponente_K3SG1))
print(head(Komponente_K3SG2))
print(colnames(Komponente_K3SG2))
unique_Einträge <- unique(Einzelteil_T21$Fehlerhaft)
cat("Einträge Fehlerhaft:", unique_Einträge) #Prüfen, welche Einträge in der Spalte enthalten sind



common_elements <- intersect(Einzelteil_T21$ID_T21, Komponente_K3SG2$ID_T21)
print(common_elements)

# Ausgabe
cat("Anzahl der identischen Zeilen:", identical_rows, "\n")

K3SG2_Einzelteil <- left_join(Einzelteil_T21,Komponente_K3SG2, by = "ID_T21") %>% 
  select(ID_T21, ID_K3SG2)

K3SG1_Einzelteil <- left_join(Einzelteil_T21,Komponente_K3SG1, by = "ID_T21") %>% 
  select(ID_T21, Fehlerhaft, Fehlerhaft_Datum, ID_K3SG1)



K3SG1_K3SG2_Einzelteil <- left_join(K3SG1_Einzelteil,K3SG2_Einzelteil, by = "ID_T21")


#unique_Einträge <- unique(K3SG1_Einzelteil$ID_K3SG1)
#cat("Einträge Fehlerhaft:", unique_Einträge) #Prüfen, welche Einträge in der Spalte enthalten sind

#unique_Einträge <- unique(K3SG2_Einzelteil$ID_K3SG1)
#cat("Einträge Fehlerhaft:", unique_Einträge) #Prüfen, welche Einträge in der Spalte enthalten sind, unique würde NA angeben und wenn beim joinen etwas keinen Partner hat ist NA




  
