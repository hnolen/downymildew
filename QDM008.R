#Analysis of QDM-008 data
#design: RCBD with 1 factor: Genotype at 14 levels
#this does have missing data points/missing reps (no germination)
#there are 3 genotypes (Ficifolium Q, Ficifolium P, and CA286) with no downy mildew - thus no variance, these genotypes were taken out of the data set for analysis!

#Testing ANOVA assumptions
str(dm19_dat)
dm19_dat$Row<-as.factor(dm19_dat$Row)
dm19_dat$AUDPC<-as.numeric(as.character(dm19_dat$AUDPC))
str(dm19_dat)
dm19_dat[24,3]<- 0

audpc_mod<- lm(AUDPC ~ Treatment + Row, dm19_dat)
anova(audpc_mod)
avg_dm<-aggregate(dm19_dat$AUDPC, list(dm19_dat$Treatment), mean)
#resids x preds plot, generate resids for SW test:
dm19_dat$resids<-residuals(audpc_mod)
dm19_dat$preds<-predict(audpc_mod)
dm19_dat$sq_preds<-dm19_dat$preds^2
plot(resids ~ preds, data = dm19_dat) 

#shapiro wilk - Tests for normality of residuals
shapiro.test(dm19_dat$resids) # p-value = 0.434

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(AUDPC ~ Treatment, data = dm19_dat) # p-value = 0.0002741 
leveneTest(AUDPC ~ Treatment, center = mean, data = dm19_dat)

#tukey 1 df test for non-additivity - Tests that blocks are behaving additively
audpc_1df_mod<-lm(AUDPC ~ Treatment + Row + sq_preds, dm19_dat)
anova(audpc_1df_mod) # p-value of sq_preds = 0.9144


######DATA TRANSFORMATION#########
#find exponent for power transformation
means <- aggregate(dm19_dat$AUDPC, list(dm19_dat$Treatment), mean)
vars <- aggregate(dm19_dat$AUDPC, list(dm19_dat$Treatment), var)
logmeans<-log10(means$x)
logvars<-log10(vars$x)
power_mod<-lm(logvars ~ logmeans)
summary(power_mod)

#solve for exponent 
a<- 1-(0.1749/2) #=0.91255 
dm19_dat$trans_AUDPC<-(dm19_dat$AUDPC)^a


#test assumptions again
#resids x preds plot, generate resids for SW test:
dm19_dat$trans_resids<-residuals(audpc_mod)
dm19_dat$trans_preds<-predict(audpc_mod)
dm19_dat$trans_sq_preds<-dm19_dat$preds^2
plot(trans_resids ~ trans_preds, data = dm19_dat) 
mod<-lm(trans_resids ~ trans_preds, data = dm19_dat)
summary(mod)
#shapiro wilk - Tests for normality of residuals
shapiro.test(dm19_dat$trans_resids) # p-value = 0.434

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(trans_AUDPC ~ Treatment, center = mean, data = dm19_dat) # p-value = 0.0007272 

#tukey 1 df test for non-additivity - Tests that blocks are behaving additively
trans_audpc_1df_mod<-lm(trans_AUDPC ~ Treatment + Row + sq_preds, dm19_dat)
anova(trans_audpc_1df_mod) # p-value of sq_preds = 0.8315


Anova(audpc_mod, type =2)


#i have unequal variances - need to do welch's one way anova
welch<-oneway.test(AUDPC ~ Treatment, data = dm19_dat, var.equal = FALSE)
oneway.test(AUDPC ~ Row, data = dm19_dat, var.equal = FALSE)



library("emmeans")
lsm<-emmeans(audpc_mod, "Treatment")
tuk<-contrast(lsm, method="pairwise", adjust = "tukey")
tuk<-HSD.test(audpc_mod, "Treatment")


######do same thing with stem lesion audpc####
stem_mod<- lm(SL_AUDPC ~ Treatment + Row, sl_audpc)
anova(stem_mod)
avg_sl<-aggregate(sl_audpc$SL_AUDPC, list(sl_audpc$Treatment), mean)
#resids x preds plot, generate resids for SW test:
sl_audpc$resids<-residuals(stem_mod)
sl_audpc$preds<-predict(stem_mod)
sl_audpc$sq_preds<-sl_audpc$preds^2
plot(resids ~ preds, data = sl_audpc) 

#shapiro wilk - Tests for normality of residuals
shapiro.test(sl_audpc$resids) # p-value = 8.08e-5

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(SL_AUDPC ~ Treatment, data = sl_audpc) # p-value = 0.2393 

#tukey 1 df test for non-additivity - Tests that blocks are behaving additively
stem_1df_mod<-lm(SL_AUDPC ~ Treatment + Row + sq_preds, sl_audpc)
anova(stem_1df_mod) # p-value of sq_preds = 0.2433


######DATA TRANSFORMATION######### - failed SW
#find exponent for power transformation
add_1<-function(x) {
  x+1
}
sl_audpc$add_audpc<-add_1(sl_audpc$SL_AUDPC)
sl_means <- aggregate(sl_audpc$add_audpc, list(sl_audpc$Treatment), mean)
sl_vars <- aggregate(sl_audpc$add_audpc, list(sl_audpc$Treatment), var)
sl_logmeans<-log10(sl_means$x)
sl_logvars<-log10(sl_vars$x)
sl_power_mod<-lm(sl_logvars ~ sl_logmeans)
summary(sl_power_mod)

#solve for exponent 
a<- 1-(0.9685/2) #=0.51575
sl_audpc$trans_AUDPC<-(sl_audpc$add_audpc)^a


#test assumptions again
#resids x preds plot, generate resids for SW test:
sl_audpc$trans_resids<-residuals(stem_mod)
sl_audpc$trans_preds<-predict(stem_mod)
sl_audpc$trans_sq_preds<-sl_audpc$preds^2
plot(trans_resids ~ trans_preds, data = sl_audpc) 
mod<-lm(trans_resids ~ trans_preds, data = sl_audpc)
summary(mod)
#shapiro wilk - Tests for normality of residuals
shapiro.test(sl_audpc$trans_resids) # p-value = 0.434

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(trans_AUDPC ~ Treatment, data = sl_audpc) # p-value = 0.077 

#tukey 1 df test for non-additivity - Tests that blocks are behaving additively
trans_audpc_1df_mod<-lm(trans_AUDPC ~ Treatment + Row + sq_preds, sl_audpc)
anova(trans_audpc_1df_mod) # p-value of sq_preds = 0.8315


Anova(stem_mod, type =2)


#i have unequal variances - need to do welch's one way anova
welch<-oneway.test(AUDPC ~ Treatment, data = dm19_dat, var.equal = FALSE)
oneway.test(AUDPC ~ Row, data = dm19_dat, var.equal = FALSE)



library("emmeans")
library(agricolae)
lsm<-emmeans(stem_mod, "Treatment")
tuk<-contrast(lsm, method="pairwise", adjust = "tukey")
tuk<-HSD.test(stem_mod, "Treatment")

###pink spots
str(pink_dat)
pink_dat$Row<-as.factor(pink_dat$Row)

pink_mod<- lm(Pink_incidence ~ Treatment + Row, pink_dat)
anova(pink_mod)
#resids x preds plot, generate resids for SW test:
pink_dat$resids<-residuals(pink_mod)
pink_dat$preds<-predict(pink_mod)
pink_dat$sq_preds<-pink_dat$preds^2
plot(resids ~ preds, data = pink_dat) 

#shapiro wilk - Tests for normality of residuals
shapiro.test(pink_dat$resids) # p-value = 0.0006742

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(Pink_incidence ~ Treatment, data = pink_dat) # p-value = 0.06742 

#tukey 1 df test for non-additivity - Tests that blocks are behaving additively
pink_1df_mod<-lm(Pink_incidence ~ Treatment + Row + sq_preds, pink_dat)
anova(pink_1df_mod) # p-value of sq_preds = 0.04719

######DATA TRANSFORMATION######### - failed SW and blocks not behaving additively
#find exponent for power transformation
add_1<-function(x) {
  x+1
}
pink_dat$add_inc<-add_1(pink_dat$Pink_incidence)
pink_means <- aggregate(pink_dat$add_inc, list(pink_dat$Treatment), mean)
pink_vars <- aggregate(pink_dat$add_inc, list(pink_dat$Treatment), var)
pink_logmeans<-log10(pink_means$x)
pink_logvars<-log10(pink_vars$x)
pink_power_mod<-lm(pink_logvars ~ pink_logmeans)
summary(pink_power_mod)

#solve for exponent 
a<- 1-(0.9685/2) #=0.51575
sl_audpc$trans_AUDPC<-(sl_audpc$add_audpc)^a


#test assumptions again
#resids x preds plot, generate resids for SW test:
sl_audpc$trans_resids<-residuals(stem_mod)
sl_audpc$trans_preds<-predict(stem_mod)
sl_audpc$trans_sq_preds<-sl_audpc$preds^2
plot(trans_resids ~ trans_preds, data = sl_audpc) 
mod<-lm(trans_resids ~ trans_preds, data = sl_audpc)
summary(mod)
#shapiro wilk - Tests for normality of residuals
shapiro.test(sl_audpc$trans_resids) # p-value = 0.434

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(trans_AUDPC ~ Treatment, center = mean, data = dm19_dat) # p-value = 0.0007272 

#tukey 1 df test for non-additivity - Tests that blocks are behaving additively
trans_audpc_1df_mod<-lm(trans_AUDPC ~ Treatment + Row + sq_preds, dm19_dat)
anova(trans_audpc_1df_mod) # p-value of sq_preds = 0.8315

#visualization
plot(AUDPC ~ Treatment, dm19_dat)
library(ggplot2)

f<-ggplot(dm19_dat, aes(Treatment,AUDPC))
p<-f+geom_boxplot(aes(Treatment, AUDPC))
p+theme(
  # Hide panel borders and remove grid lines
  panel.border = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  # Change axis line
  axis.line = element_line(colour = "black")
)



#### ANALYSES ASKED FOR BY REVIEWERS:

#doing ANOVA on Relative AUDPC
#Testing ANOVA assumptions
str(audpcr_dat)
audpcr_dat$Row<-as.factor(audpcr_dat$Row)
audpcr_dat$AUDPCr<-as.numeric(as.character(audpcr_dat$AUDPCr))
str(audpcr_dat)
#audpcr_dat[24,3]<- 0

audpcr_mod<- lm(AUDPCr ~ Treatment + Row, audpcr_dat)
anova(audpcr_mod)
avg_dm<-aggregate(audpcr_dat$AUDPCr, list(audpcr_dat$Treatment), mean)
#resids x preds plot, generate resids for SW test:
audpcr_dat$resids<-residuals(audpcr_mod)
audpcr_dat$preds<-predict(audpcr_mod)
audpcr_dat$sq_preds<-audpcr_dat$preds^2
plot(resids ~ preds, data = audpcr_dat) #plot looks a little football shaped

#shapiro wilk - Tests for normality of residuals
shapiro.test(audpcr_dat$resids) # p-value = 0.02591

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(AUDPCr ~ Treatment, data = audpcr_dat) # p-value = 0.1085 
leveneTest(AUDPCr ~ Treatment, center = mean, data = audpcr_dat) #pvalue = 0.01651

#tukey 1 df test for non-additivity - Tests that blocks are behaving additively
audpcr_1df_mod<-lm(AUDPCr ~ Treatment + Row + sq_preds, audpcr_dat)
anova(audpcr_1df_mod) # p-value of sq_preds = 0.3304

# Now I also have the issue of non-normal residuals, the resids ~ preds plot is kind of football shaped, so an arcsine transformation is probably best
audpcr_dat$trans_audpcr<-asin(sqrt(audpcr_dat$AUDPCr/50))

#re-testing assumptions with transformed data

trans_audpcr_mod<- lm(trans_audpcr ~ Treatment + Row, audpcr_dat)
anova(trans_audpcr_mod)

#resids x preds plot, generate resids for SW test:
audpcr_dat$trans_resids<-residuals(trans_audpcr_mod)
audpcr_dat$trans_preds<-predict(trans_audpcr_mod)
audpcr_dat$trans_sq_preds<-audpcr_dat$trans_preds^2
plot(trans_resids ~ trans_preds, data = audpcr_dat) #plot looks a little football shaped

#shapiro wilk - Tests for normality of residuals
shapiro.test(audpcr_dat$trans_resids) # p-value = 0.5639

#levene's test - Tests for homogeneity of variance
library(car)
leveneTest(trans_audpcr ~ Treatment, data = audpcr_dat) # p-value = 0.001595 
leveneTest(trans_audpcr ~ Treatment, center = mean, data = audpcr_dat) #pvalue = 4.547e-5


#Now using the relative AUDPC values and doing an arcsine transformation all of my assumptions are good,
#So I can actually do a regular anova, but have to use the Anova() function because my stuff is unbalanced

Anova(trans_audpcr_mod, type = 2)

library("emmeans")
library(agricolae)
lsm<-emmeans(trans_audpcr_mod, "Treatment")
tuk<-contrast(lsm, method="pairwise", adjust = "tukey")
tuk<-HSD.test(trans_audpcr_mod, "Treatment", unbalanced = TRUE) #MSD=0.0124

#for some reason the HSD.test isn't giving me MSD but you can calculate with this formula:
# q (studentized range)*sqrt(MSE/n) = 0.0124

#need standard error of untransformed data
lsm_original<-emmeans(audpcr_mod, "Treatment")


avg_dm<-aggregate(audpcr_dat$trans_audpcr, list(audpcr_dat$Treatment), mean)



