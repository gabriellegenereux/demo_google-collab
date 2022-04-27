
#Install packages (imports data base)
install.packages("questionr", dep = TRUE)
library("questionr")

#Assign data base "hdv2003" to "bd" (creates a copy of the data base into new object/data table)
data(hdv2003)
bd <- hdv2003

ls() # Show list of objects


## REMOVING OBJECTS ##

rm(hdv2003) # remove object
rm (aaa,bbb,ccc) #remove more than one object
rm (list = ls()) # remove all objects


## SHOW DATA BASE CONTENT ##

bd # Show data table
head(bd, 3) # head (default argument = 6)
tail(bd) # tail
names(bd) # variable names
length(bd) # number of variables (same output as necol(bd))
ncol(bd) # numbwe of columns (same output as lenght(bd))
nrow(bd) # number of observations
dim(bd) # number of dimensions (Columns and rows)

## SHOW DATA BASE CHARACTERISTICS ##

class(bd) # object type
str(bd) # detailed description of data table structure
describe(bd) # detailed description of table variables


## INDEXATION ##

# variables/columns - positions

bd[ ,10] #  10th variable
bd [ ,3:6] #  variables 3 TO 6 ( ':' is shortcut of function 'seq()')
bd[ ,c(3,6)] #  variables 3 AND 6 (do not forget to use 'c')
bd[ ,-2] #  all but 2nd variable
bd[ ,-(3:6)] # all variables but 3 TO 6
bd[ , -c(3,6)] # all variables but 3 AND 6

# observations/rows - positions

bd[3:6, ] #  rows 3 to 6

# variables AND observations - positions

bd[1:100, c(1:5,10)] # observations 1 to 100, variables 1 to 5 and 10
bd2 <- bd[1:100, c(1:5,10)] # creating new data set "bd2"
bd2 # show data table

# variable names

# operator '[ ]' 

bd["relig"] # variable "relig"
bd [ ,c("occup","relig")] # two variables

# mixing indexation (names and positions)

bd[1:100, c("id", "age", "sexe", "nivetud", "relig")] # first 100 observations and 5 named variables

# operator '$'

bd$sexe # variable 'sexe'
bd$sexe[1:10] # observations 1 to 10 
length(bd$sexe) #length / number of observations
str(bd$sexe) # structure
head(bd$sexe) # first observations of variable
bd$sexe=="Femme" # logical condition testing if "sexe" value is "Femme" and returns TRUE or FALSE
bd$sexe!="Homme" 
which(bd$relig == "Pratiquant occasionnel") # display positions of specific value

# select variable condition to create a new data set 
bd.f <-bd[bd$sexe=="Femme", ]
bd.f
bd.m <-bd[bd$sexe=="Homme", ]
bd.m

# select multiple conditions applied to one variable
  # example: respondants retired or at home
bd[bd$occup=="Retraite"| bd$occup=="Au foyer", ] # with operator '|' (or)

# select multiple conditions applied to multiple variables
  #example: respondants between 40 and 60 who likes reading or cinema
bd[bd$age >=40 & bd$age <= 60 & (bd$lecture.bd =="Oui" | bd$cinema == "Oui"), ]

bd.cadre<- bd[bd$qualif=="Cadre" & bd$age<50, c("id","qualif","age")] # will not work because of NAs
bd.cadre

# try again, including !is.na
bd.cadre2<- bd[bd$qualif=="Cadre" & bd$age<50 & !is.na(bd$qualif) & !is.na(bd$age), c("id","qualif","age")]
bd.cadre2

# better to use subset()
bd.cadre3<- subset(bd, qualif=="Cadre" & age<50, select= c(id,qualif,age))
bd.cadre3


# MISSING VALUES #

is.na(bd$age) # identify cases with missing values
which(is.na(bd), arr.ind = TRUE) # identify cases with missing values in whole data set
  # is.na() applies logic test
  # which() returns rows who meet condition (TRUE)
  # arr.ind= applies logic on all columns
  # returns a matrix with observation number and column number of NAs

sum(is.na(bd$qualif)) # number of NAs in variable
sum(!is.na(bd$qualif)) # number of non-NAs in variable

##bd<- na.omit(bd) ### eliminate all rows with at least one NA

##bd$age[whch(is.na(bd$age))] <- mean(bd$age, na.rm=TRUE) ### imputes NA by mean for variable

bd.qualif <- bd[complete.cases(bd$qualif), ] # create a new data set without NAs in "qualif" variable
bd.qualif
bd

# MANIPULATE VARIABLES

#change numerical value
bd$age[1] # displays age value
bd$age[1] <- 38 # input new value
bd$age[1] # now displays 38

#change nominal value
bd$sexe[1] # displays category "Femme"
bd$sexe[1] <- Homme # input new value

#add new factor
bd$sexe[1] <- "Autre" # error - factor not existing
bd$sexe <- factor(bd$sexe, levels = c("Femme", "Homme", "Autre")) # adding new factor
bd$sexe[1] <- "Autre" # editing value with new factor 
bd$sexe[1] # displays category "Autre"

#rename multiple variables
names(bd) # displays all variables name
names(bd)[c(3,4)] <- c("SEXE", "NIVETUD") # change variable names (caplocks)
names(bd) # displays edited names

# rename one variable (two options)
#option 1
names(bd)[c(9)] <- c("clso") # edit variable [9] name 
names(bd)

#option 2
bd <- rename.variable(bd, "clso", "Classe") # original name, edited name
names(bd)

# delete one or more variables
bd$cuisine <- NULL # delete one variable
bd [ ,c(5,15)] <- NULL  # delete multiple variables

# Recode categorical variables levels 
str(bd)
is.character(bd$sport) # only possible to recode level when variable is set in "character"
bd$sport[bd$sport == "Non"] <- "NON" # will NOT work because "sport" is already set in "factor"
bd$sport[bd$sport == "Oui"] <- "OUI"
bd$sport <- as.character(bd$sport) #transform "factorial" variable to "character"
bd$sport[bd$sport == "Non"] <- "NON"
bd$sport[bd$sport == "Oui"] <- "OUI"
str(bd$sport) # see edits to values
bd$sport  <- factor(bd$sport) #reconvert variable to "factor"
str(bd) # see edit to structure

#Recode or aggregate levels

# Using indexation by condition
# method above can be used (with as.character function)
# OR creating a new variable

#example: aggregating and recoding levels from variable "relig" - creating variable relig.rec
#option1
bd$relig.rec[bd$relig == "Pratiquant regulier"] <- "Pratiquant"
bd$relig.rec[bd$relig == "Pratiquant occasionnel"] <- "Pratiquant"
bd$relig.rec[bd$relig == "Appartenance sans pratique"] <- "Croyant"
bd$relig.rec[bd$relig == "Ni croyance ni appartenance"] <- "Athee"
bd$relig.rec[bd$relig == "Rejet"] <- "ND"
bd$relig.rec[bd$relig == "NSP ou NVPR"] <- "ND"

str(bd$relig.rec) #displays new variable - set in "character"
bd$relig.rec <- as.factor(bd$relig.rec)
str(bd$relig.rec) # now displays variable as factor with 4 levels

#option2
bd$relig.rec2 <- factor(bd$relig, levels = c("Pratiquant regulier", "Pratiquant occasionnel", "Appartenance sans pratique", "Ni croyance ni appartenance", "Rejet", "NSP ou NVPR"), labels = c("Pratiquant", "Pratiquant", "Croyant", "Athee", "ND", "ND") ) # anciens noms, nouveaux noms
str(bd$relig.rec.2) #displays new variable - set in "character"

#option3 - fonction ifelse()
levels(bd$occup) # transform this variable into binary variable
bd$occup.dico <- ifelse(bd$occup=="Exerce une profession", "Actif", "Inactif")
str(bd$occup.dico) # new variable set as character
bd$occup.dico <- as.factor(bd$occup.dico)
levels(bd$occup.dico)

#option2
bd$femme.ret <- ifelse(bd$sexe == "Femme" & bd$occup == "Retraite", "Oui", "Non") # create a variable identifying retired women
str(bd$femme.ret)
bd$femme.ret <- as.factor(bd$femme.ret)
str(bd$femme.ret)


bd$age.cat <- cut(bd$age, breaks=c(0, 20, 40, 60, 80, 100), labels=c("20 under", "21 to 40","41 to 60","61 to 80","81 over"), ordered_result = TRUE, )
str(bd$age)
str(bd$age.cat)


bd$annee <- 2003 - bd$age #annee de naissance
str(bd$annee)
bd$sum <- rowSums(bd[ ,c("var1", "var2", "var3")], na.rm = TRUE)
bd$sum <- rowSums (bd[ , c("var1", "var2", "var3")], na.rm = TRUE)
bd$moy <- rowMeans(bd[ , c("var1", "var2", "var3")], na.rm = TRUE)
usethis::use_git()

