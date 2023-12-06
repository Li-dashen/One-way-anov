install.packages("openxlsx")
install.packages("dplyr")
install.packages("tidyr")
install.packages("kableExtra")

library(openxlsx)
library(dplyr)
library(tidyr)
library(kableExtra)

#(One Way ANOV)
OneWay_ANOV = function(df){
  col_names = colnames(df)
  print(paste("Hypothesis:",col_names[2],"will be different due to",col_names[1]))
  
  #change table from 2*n to i*j 
  MainTable = df %>%
    group_by(老板类型) %>%
    mutate(row = row_number()) %>%
    spread(col_names[1], col_names[2]) %>%
    select(-row)
  
  #mean
  all_values = unlist(MainTable)
  TotalAverage = mean(all_values)
  
  #get SS(Between)
  BetweenGroup_ss = (sum((TotalAverage - colMeans(MainTable))^2))* nrow(MainTable)
  
  
  #get SS(Within)
  WithinGroup_ss = 0
  for (i in 1:ncol(MainTable)){
    Sum = sum((MainTable[,i]-colMeans(MainTable[,i]))^2)
    WithinGroup_ss = WithinGroup_ss + Sum
  }
  
  #get df(including Between and within)
  #Between
  dfBetween = ncol(MainTable) - 1
  dfWithin = nrow(MainTable)*ncol(MainTable) - ncol(MainTable)
  
  #get MS
  MSBetween = BetweenGroup_ss / dfBetween
  MSWithin = WithinGroup_ss / dfWithin
  
  #get F
  F_value = MSBetween/MSWithin
  
  #get P
  P_value = 1 - pf(F_value,dfBetween,dfWithin)
  if(P_value >= 0.01 && P_value < 0.05){
    F_value = paste(F_value,"*")
    x = "*P<0.05"
  } else if (P_value >= 0.001 && P_value < 0.01){
    F_value = paste(F_value,"**")
    x = "**P<0.01"
  }else if (P_value < 0.001){
      F_value = paste(F_value,"***")
      x = "***P<0.001"
  }
  
  
  #Finally output variance analysis table and average analysis table
  #Variance analysis table
  Variance =  data.frame(
    SV = c("Between", "Within", "Total"),
    SS = c(BetweenGroup_ss, WithinGroup_ss, BetweenGroup_ss+WithinGroup_ss),
    df = c(dfBetween,dfWithin,dfBetween+dfWithin),
    Ms = c(MSBetween, MSWithin, " "),
    F = c(F_value, " ", " "),
    P = c(P_value," "," ")
  )
  VarianceTable = kable(Variance, "markdown")
  print(Variance)
  print(x)
  
  #Average analysis table
  GroupNames = colnames(MainTable)
  Sd = apply(MainTable,2,sd)
  Average =  data.frame(
    Group = c(GroupNames[1],GroupNames[2],GroupNames[3],"Total"),
    Average = c(colMeans(MainTable)[1],colMeans(MainTable)[2],colMeans(MainTable)[3],TotalAverage),
    SD = c(Sd[1],Sd[2],Sd[3]," "),
    number = c(nrow(MainTable),nrow(MainTable),nrow(MainTable),ncol(MainTable)*nrow(MainTable)),
    F = c(F_value, " ", " ", " "),
    p = c(P_value, " ", " ", " ")
  )
  AverageTable = kable(Average, "markdown")
  print(AverageTable)
  print(x)
  
  print(paste("Conclusion:The effect of",col_names[1],"on",col_names[2],
        "is significant at the ",x," level.(F=",F_value,"df1=",dfBetween,
        "df2=",dfWithin," p=",P_value,")"))
}

df = read.xlsx("工作满意度.xlsx")

#Change name
for(i in 1:nrow(df)){
  if(df$老板类型[i] == 1) df$老板类型[i] = "Power"
  else if(df$老板类型[i] == 2) df$老板类型[i] = "Freedom"
  else df$老板类型[i] = "Democracy"
}

OneWay_ANOV(df)
