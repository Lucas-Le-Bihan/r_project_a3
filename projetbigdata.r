data <- read.csv('stat_acc_V3.csv', header = TRUE, sep = ';')
communes <- read.csv('communes-departement-region.csv', header = TRUE, sep = ',')
regions <- read.csv('Regions.csv', header = TRUE, sep = ';')

data <- data[!is.null(data$id_code_insee) & !is.null(data$an_nais) & !is.null(data$age) & !is.null(data$place), ]
data$Num_Acc <- as.numeric(data$Num_Acc)
data$id_usa <- as.numeric(data$id_usa)
data$id_code_insee <- as.numeric(data$id_code_insee)
data$latitude <- as.numeric(data$latitude)
data$longitude <- as.numeric(data$longitude)
data$an_nais <- as.numeric(data$an_nais)
data$age <- as.numeric(data$age)
data$place <- as.numeric(data$place)
data$ville <- as.character(data$ville)
data$date <- as.Date(data$date)

communes$code_commune_INSEE <- as.numeric(communes$code_commune_INSEE)
communes$code_region <- as.numeric(communes$code_region)

regions$CODREG <- as.numeric(regions$CODREG)

accidents_par_mois <- aggregate(data$Num_Acc, by = list(Mois = format(data$date, "%Y-%m")), FUN = length)
accidents_par_semaine <- aggregate(data$Num_Acc, by = list(Semaine = format(data$date, "%Y-%W")), FUN = length)

barplot(accidents_par_mois$x, names.arg = accidents_par_mois$Mois, xlab = "Mois", ylab = "Nombre d'accidents", main = "Évolution du nombre d'accidents par mois")
barplot(accidents_par_semaine$x, names.arg = accidents_par_semaine$Semaine, xlab = "Semaine", ylab = "Nombre d'accidents", main = "Évolution du nombre d'accidents par semaine")

merged_data <- merge(data, communes, by.x = "id_code_insee", by.y = "code_commune_INSEE", all.x = TRUE)
merged_data <- merge(merged_data, regions, by.x = "code_region", by.y = "CODREG", all.x = TRUE)
merged_data$accidents_100k <- (merged_data$nombre_accidents / merged_data$PMUN) * 100000
donnees_acp <- data.frame(region = merged_data$nom_region,
                          accidents_100k = merged_data$accidents_100k,
                          gravite = merged_data$descr_grav)
print(head(donnees_acp))
print(head(communes))