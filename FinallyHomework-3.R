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
    group_by(across(all_of(col_names[1]))) %>%
    mutate(row = row_number()) %>%
    spread(col_names[1], col_names[2]) %>%
    select(-row)
  
  TableCol = ncol(MainTable)
  TableRow = nrow(MainTable)
  
  #mean
  all_values = unlist(MainTable)
  TotalAverage = mean(all_values)
  
  #get SS(Between)
  BetweenGroup_ss = (sum((TotalAverage - colMeans(MainTable))^2))* TableRow
  
  
  #get SS(Within)
  WithinGroup_ss = 0
  for (i in 1:TableCol){
    Sum = sum((MainTable[,i]-colMeans(MainTable[,i]))^2)
    WithinGroup_ss = WithinGroup_ss + Sum
  }
  
  #get df(including Between and within)
  #Between
  dfBetween = TableCol - 1
  dfWithin = TableRow*TableCol - TableCol
  
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
  
  Average =  data.frame(matrix(nrow=TableCol+1,ncol=6))
  #Setting colnames
  col_names = c("Group", "Average", "SD", "number","F","p")
  colnames(Average) = col_names
  for (i in 1:TableCol) {
    Average[i,1] = GroupNames[i]
    Average[i,2] = colMeans(MainTable)[i]
    Average[i,3] = Sd[i]
    Average[i,4] = TableRow
  }
  Average[TableCol+1,1] = "Total"
  Average[TableCol+1,2] = TotalAverage
  Average[TableCol+1,3] = " "
  Average[TableCol+1,4] = TableRow*TableCol
  Average[1,5] = F_value
  Average[1,6] = P_value
  for (i in 1:TableCol+1) {
    Average[i,5] = " "
    Average[i,6] = " "
  }
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
