##MODELING DISEASE GROWTH CURVES

## Monomolecular model example
plotmono <- function(y0,r,maxt){
  curve(
    1-(1-y0)*exp(-r*x),
    from=0,
    to=maxt,
    xlab='Time',
    ylab='Disease Incidence',
    col='mediumblue')
}
plotmono(0.0017, 0.00242, 2000)

## Logistic Model Example
plotlog <- function(y0,r,maxt){
  curve(
    1/(1+(1-y0)/y0*exp(-r*x)),
    from=0,
    to=maxt,
    xlab='Time',
    ylab='Disease Incidence',
    col='mediumblue'
  )
}
plotlog(0.001, 0.01636, 1000)

## Gompertz Model Example
plotgomp <- function(y0,r,maxt){
  curve(
    exp(log(y0)*exp(-r*x)),
    from=0, to=maxt, xlab='Time',
    ylab='Disease Incidence',
    col='mediumblue'
  )
}
plotgomp(0.0017,0.02922, 250)


#Following tutorial: https://cran.r-project.org/web/packages/epifitter/vignettes/fitting.html

library(epifitter)
library(ggplot2)
library(dplyr)
library(magrittr)
library(cowplot)


#can obtain parameters by doing linear regression of a transformation of the data, 
#or a nonlinear regression fitted to original data - fit_nlin2() allows estimating the upper asymptote,
#when disease intensity is not close to 100% (ex. my data)

#my big question here is do I use all of my data from each cultivar or do I just use one?
#answer: I'm pretty sure I use it all and have to make different curves for each treatment



dpcL <- sim_logistic(
  N = 100, # duration of the epidemics in days
  y0 = 0.01, # disease intensity at time zero
  dt = 10, # interval between assessments
  r = 0.1, # apparent infection rate
  alpha = 0.2, # level of noise
  n = 7 # number of replicates
)
head(dpcL)

ggplot(
  dpcL,
  aes(time, y,
      group = replicates
  )
) +
  geom_point(aes(time, random_y), shape = 1) + # plot the replicate values
  geom_point(color = "steelblue", size = 2) +
  geom_line(color = "steelblue") +
  labs(
    title = "Simulated 'complete' epidemics of sigmoid shape",
    subtitle = "Produced using sim_logistic()"
  )+
  theme_minimal_hgrid()


#looking at another tutorial: https://www.statforbiology.com/nonlinearregression/usefulequations#sygmoidal_curves
library(drc)
library(nlme)
library(aomisc)

install.packages("devtools")
library(devtools)
install_github("OnofriAndreaPG/aomisc")
install_github("OnofriAndreaPG/agriCensData")
install_github("OnofriAndreaPG/drcSeedGerm")
install_github("OnofriAndreaPG/lmDiallel")




#based on Motulsky and Christopolous, non-linear regression has the assumptions of normal residuals and homoscedasiticity
#need to check these assumptions

str(disease_dat)
disease_dat$Disease<-as.numeric(as.character(disease_dat$Disease))

dis_mod<- lm(Disease ~ Treatment, disease_dat)
anova(dis_mod)
avg_dm<-aggregate(disease_dat$Disease, list(disease_dat$Treatment), mean)
#resids x preds plot, generate resids for SW test:
disease_dat$resids<-residuals(dis_mod)
disease_dat$preds<-predict(dis_mod)
disease_dat$sq_preds<-disease_dat$preds^2
plot(resids ~ preds, data = disease_dat) 

#shapiro wilk - Tests for normality of residuals
shapiro.test(disease_dat$resids) # p-value = 2.2e-16

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(Disease ~ Treatment, data = disease_dat) # p-value = 2.2e-16 
leveneTest(Disease ~ Treatment, center = mean, data = disease_dat)

######DATA TRANSFORMATION#########
#find exponent for power transformation
means <- aggregate(disease_dat$Disease, list(disease_dat$Treatment), mean)
vars <- aggregate(disease_dat$Disease, list(disease_dat$Treatment), var)
logmeans<-log10(means$x)
logvars<-log10(vars$x)
power_mod<-lm(logvars ~ logmeans)
summary(power_mod) #exponent is 0.70937

#solve for exponent 
a<- 1-(0.70937/2) #=0.645315 
disease_dat$trans_dis<-(disease_dat$Disease)^a

#recheck assumptions with transformed data
transdis_mod<- lm(trans_dis ~ Treatment, disease_dat)
anova(transdis_mod)
#avg_dm<-aggregate(disease_dat$Disease, list(disease_dat$Treatment), mean)
#resids x preds plot, generate resids for SW test:
disease_dat$trans_resids<-residuals(transdis_mod)
disease_dat$trans_preds<-predict(transdis_mod)
disease_dat$trans_sq_preds<-disease_dat$trans_preds^2
plot(trans_resids ~ trans_preds, data = disease_dat) 

#shapiro wilk - Tests for normality of residuals
shapiro.test(disease_dat$trans_resids) # p-value = 4.88e-14

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(trans_dis ~ Treatment, data = disease_dat) # p-value = 2.2e-16 
leveneTest(Disease ~ Treatment, center = mean, data = disease_dat)


#Did not change my residuals plot at all. I think I should try subtracting 10 from all of my data points and then
#maybe doing a log transformation? 




