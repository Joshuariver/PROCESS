# 조절회귀분석
# Source: Regorz Statistik

setwd("~/R/PROCESS v4.0 for R")


library(dplyr)
library(haven)
library(psych)
library(rockchalk)

df <- read_spss("~/R/Regression/SPSS_다변량회귀분석/01.상반부 자료/실습자료2/8. 조절 회귀분석.sav")

df <- mutate(df, 외관 = (외관1+외관2+외관3)/3, 편의성 = (편의성1+편의성2)/2,
             유용성 = (유용성1+유용성2+유용성3)/3, 브랜드 = (브랜드1+브랜드2+브랜드3)/3,
             만족감 = (만족감1+만족감2)/2)


# df <- mutate(df, 외관_브랜드 = (외관*브랜드), 편의성_브랜드 = (편의성*브랜드), 유용성_브랜드 = (유용성*브랜드))


# Process 공식
# process(data = my_data_frame,
#         y = "my_DV", x = "my_IV",
#         w = "my_MOD", model = 1)
# 
# 추가 옵션들
# Mean centering                              center = 2
# Change the values for interaction probes    moments = 1
# Including covariates                        cov = "age",  둘 이상일 때  cov = c("age","gender")
# Bootstrapping                               modelbt = 1
# Bootstrapping 횟수                          boot = 5000
# Bootstrapping 고정                          seed = 654321
# Interaction 효과 표로 표시                  library(rockchalk)
#                                             alternative: plot = 1
# Johnson Neiman 표시                         jn = 1


process(data = df,y = "만족감", x = "외관",w = "브랜드", model = 1, plot = 1, 
        modelbt = 1, boot = 5000, seed = 654321, jn = 1, center = 2)


process(data = df,y = "만족감", x = "편의성",w = "브랜드", model = 1, plot = 1, 
        modelbt = 1, boot = 5000, seed = 654321, jn = 1, center = 2)

process(data = df,y = "만족감", x = "유용성",w = "브랜드", model = 1, plot = 1, 
        modelbt = 1, boot = 5000, seed = 654321, jn = 1, center = 2)

# Plotting

required <- c("survey", "huxtable", "sandwich", "cowplot")
if (!all(sapply(required, requireNamespace, quietly = TRUE)))
  knitr::opts_chunk$set(eval = FALSE)
knitr::opts_chunk$set(message = F, warning = F, fig.width = 6, fig.height = 5)
library(jtools)
library(interactions)



fiti <- lm(만족감 ~ 유용성 * 브랜드 , data = df)
summ(fiti)

interact_plot(fiti, pred = 유용성, modx = 브랜드, johnson_neyman = TRUE)

interact_plot(fiti, pred = 유용성, modx = 브랜드, linearity.check = TRUE, plot.points = TRUE)


ss <- sim_slopes(fiti, pred = 유용성, modx = 브랜드, 
                 modx.values = c(0, 5, 10))
plot(ss)

johnson_neyman(fiti, pred = 유용성, modx = 브랜드, alpha = .05)
