data <- read.csv("~/R/RshineApp/Data/Datacrime.csv")

#formatage colonnes et supression colonnes inutiles
colnames(data) <- tolower(colnames(data))
data$date.occ <- as.Date(data$date.occ, format ="%m/%d/%Y %I:%M:%S %p")

data <- data %>%
  rename(crimes_description = crm.cd.desc,
         weapons_description = weapon.desc,
         ) %>%
  select(-dr_no, -time.occ, -mocodes, -date.rptd, -area, -rpt.dist.no, -part.1.2, -weapon.used.cd, -crm.cd.1, -crm.cd.2, 
              -crm.cd.3, -crm.cd.4)

#Coordonées District 
coordonnees <- data.frame(
  district = c("77th Street","Central","Devonshire", "Foothill","Harbor","Hollenbeck","Hollywood",  
               "Mission","N Hollywood", "Newton" , "Northeast","Olympic","Pacific","Rampart","Southeast",
               "Southwest","Topanga","Van Nuys","West LA","West Valley","Wilshire"),
  lattitude = c(33.9711645809838,34.069289513675926,34.25746229203929,34.267333870969246,33.79825717130311,34.04044708076815, 
                34.09303314065064,34.31524877217388,34.18069490662839,34.01246624609603,34.084612144838346,34.05651133974671,
                34.044497,34.05690513491602,34.0641957520126,34.04305703428556,34.1943460556438,34.11024362284669,34.20113509820746,33.98969931422682,33.93936802375243),
  longitude = c(-118.27729963863841,-118.31725335862066,-118.52843191709383, -118.33553235942306, -118.30111754780064, -118.21796741895177, -118.3266511025072,
                -118.41881525203745, -118.38003216263127,-118.25567497904416, -118.23876530545468, -118.33264457904176, -118.515050, -118.26673578273305,
                -118.37184631895043, -118.4387774510103, -118.54730295052367, -118.62062902646991,-118.45685662587164, -118.31141939807722,-118.27428880646606))

#Top10 crimes 

top_crimes <- data %>%
  group_by(crimes_description) %>%
  summarise(nbre_occurrences = n()) %>%
  arrange(desc(nbre_occurrences))%>%
  head(10)

# Ethnie + sexe = modification valeur + compte du nombre de victime

data_pop <- data %>%
  filter(data$vict.sex %in% c("F", "M","X"))

data_ethnie <- data_pop %>%
  group_by(area.name, vict.descent, vict.sex) %>%
  mutate( vict.descent = case_when(
    vict.descent == "W" ~ "White",
    vict.descent == "B" ~ "Black",
    vict.descent == "H" ~ "Hispanic",
    TRUE ~ "Other"
  ),
  vict.sex = case_when(
    vict.sex == "F" ~ "Ladies",
    vict.sex == "M" ~ "Mens",
    TRUE ~ "Other"
  )) %>%
  summarise(nbre_victime = n())
