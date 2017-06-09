# # define a simple function
# myFirstFun<-function(n)
# {
#   n*n  #  compute the square of integer n
# }
# # define a value
# k<-10
# # call the function with that value
# m<-myFirstFun(k)

processOtherEntitiesPanel <- function(HTMLcharacterArray,otherEntitiesDataFrame,companyName)
{
  parsedHtmlEntities <- htmlParse(HTMLcharacterArray) ##externalptr
  otherEntitiesInfo<-xpathSApply(parsedHtmlEntities,"//div[@class='panel-body']/div",xmlValue)
  #print(otherEntitiesInfo)
  for(ind in 1:length(otherEntitiesInfo))
  {
    tmpArr<-data.frame(CompanyName=companyName,OtherEntities=trimws(otherEntitiesInfo[ind]), stringsAsFactors=FALSE)
    #tmpArr<-c(companyName,trimws(otherEntitiesInfo[ind]))
    otherEntitiesDataFrame <- rbind(otherEntitiesDataFrame,tmpArr)
  }
  return(otherEntitiesDataFrame)
}

processIndustriesPanel <-  function(HTMLcharacterArray,industriesDataFrame,companyName)
{
  parsedHtmlIndustries <- htmlParse(HTMLcharacterArray) ##externalptr
  companyIndustriesInfo<-xpathSApply(parsedHtmlIndustries,"//div[@class='panel-body']/div[@class='col-md-6']/ul",saveXML)
  for(ind in 1:length(companyIndustriesInfo))
  {
    parsedHtmlIndustries <- htmlParse(companyIndustriesInfo[ind]) ##externalptr
    industryType <- xpathSApply(parsedHtmlIndustries,"//li[@class='about']",xmlValue)
    industrySubType <- xpathSApply(parsedHtmlIndustries,"//li[@class=' about']",xmlValue) ## this class a space as prefix
    if(length(industrySubType)>0)
      industrySubType <- industrySubType[1]
    else
      industrySubType <- "Missing"
    tmpArr<-data.frame(CompanyName=companyName,Industries=trimws(industryType[1]), SubType=trimws(industrySubType), stringsAsFactors=FALSE)
    #tmpArr<-c(companyName,trimws(industryType[1]),trimws(industrySubType))
    industriesDataFrame <- rbind(industriesDataFrame,tmpArr)
  }
  return(industriesDataFrame)
}

processParticipationPanel <-  function(HTMLcharacterArray,participationDataFrame,companyName)
{
  parsedHtmlParticipation <- htmlParse(HTMLcharacterArray) ##externalptr
  companyParticPanelSub<-xpathSApply(parsedHtmlParticipation,"//div[@class='panel-body']/span/div",saveXML)
  for(index in 1:length(companyParticPanelSub))
  {
    parsedHtmlParticipation <- htmlParse(companyParticPanelSub[index]) ##externalptr
    participation <- xpathSApply(parsedHtmlParticipation,"//p",xmlValue)
    participationSplit=strsplit(participation,":",fixed=T)
    parsedHtmlParticipationSingle <- htmlParse(companyParticPanelSub[index]) ##externalptr
    participationsDetails <- xpathSApply(parsedHtmlParticipationSingle,"//div[@class='about']",xmlValue)
    if(length(participationsDetails)==3)
    {
      detailsSplit=strsplit(participationsDetails,":",fixed=T)

      tmpArr <-data.frame(CompanyName=companyName,Participation=trimws(participationSplit[[1]][1]),Certification.Date=trimws(detailsSplit[[1]][2]),Certification.Due.Date=trimws(detailsSplit[[2]][2]), Type=trimws(detailsSplit[[3]][2]), stringsAsFactors=FALSE)
      #tmpArr<-c(companyName,trimws(participationSplit[[1]][1]),trimws(detailsSplit[[1]][2]),trimws(detailsSplit[[2]][2]),trimws(detailsSplit[[3]][2]))
      #print(tmpArr)
    }else
    {
      tmpArr <-data.frame(CompanyName=companyName,Participation="To Be Checked",Certification.Date="To Be Checked",Certification.Due.Date="To Be Checked", Type="To Be Checked", stringsAsFactors=FALSE)
      #tmpArr<-c(companyName,"To Be Checked","To Be Checked","To Be Checked","To Be Checked")
    }
    participationDataFrame<-rbind(participationDataFrame,tmpArr)

  }
  return(participationDataFrame)
}

processPrivacyPolicyPanel <- function(HTMLcharacterArray,privacyPolicyDataFrame,companyName)
{
  parsedHtmlPolicy <- htmlParse(HTMLcharacterArray) ##externalptr
  companyPolicyInfo<-xpathSApply(parsedHtmlPolicy,"//div[@class='panel-body']/div[@class='col-md-12']/p",xmlValue)
  if(length(companyPolicyInfo)==2)
  {
    tmpArr<-data.frame(CompanyName=companyName,Verification.Method=trimws(companyPolicyInfo[2]), stringsAsFactors=FALSE)
    #tmpArr<-c(companyName,trimws(companyPolicyInfo[2])) #Only the second value. --> Self-Assessment
  }else if(length(companyPolicyInfo)==1)
  {
    companyPolicyInfo<-xpathSApply(parsedHtmlPolicy,"//div[@class='panel-body']/div[@class='col-md-12']/a",xmlValue)
    tmpArr<-data.frame(CompanyName=companyName,Verification.Method=trimws(companyPolicyInfo[1]), stringsAsFactors=FALSE)
    #tmpArr<-c(companyName,trimws(companyPolicyInfo[1])) #Certifying Entity
  }else
  {
    tmpArr<-data.frame(CompanyName=companyName,Verification.Method="To Be Checked", stringsAsFactors=FALSE)
    #tmpArr<-c(companyName,"To Be Checked")
  }
  privacyPolicyDataFrame <- rbind(privacyPolicyDataFrame,tmpArr)
  return(privacyPolicyDataFrame)
}

processDisputeResolutionPanel <- function(HTMLcharacterArray,disputeResolutionDataFrame,companyName)
{
  parsedHtmlResolution <- htmlParse(HTMLcharacterArray) ##externalptr
  companyResolutionInfo<-xpathSApply(parsedHtmlResolution,"//div[@class='panel-body']/div[@class='col-md-6']/div[@class='about']",saveXML)

  if(!is.null(companyResolutionInfo))
  {
    companyResolutionInfo <- str_replace_all(companyResolutionInfo,"</small>","")
    companyResolutionInfo <- str_replace_all(companyResolutionInfo,"<small>","\n")
    parsedHtmlResolution <- htmlParse(companyResolutionInfo) ##externalptr
    companyResolutionInfo <- xpathSApply(parsedHtmlResolution,"//div",xmlValue)
    companyResolutionInfoSplit <- strsplit(companyResolutionInfo,"\n",fixed=T) ##list
  }else
  {
    companyResolutionInfo <- ""
  }

  if(length(companyResolutionInfo)==2)
  {
    responsible <-companyResolutionInfoSplit[[1]]
    infoAddress <- companyResolutionInfoSplit[[2]]
    respName <-responsible[1]
    respRole <-responsible[2]
    companyAddress <-infoAddress[1]
    companyCity <-infoAddress[2]

    tmpArr<-data.frame(CompanyName=companyName,Person.Responsible=trimws(respName),Role=trimws(respRole), Address=trimws(companyAddress),City=trimws(companyCity), stringsAsFactors=FALSE)
    #tmpArr<-c(companyName,trimws(respName),trimws(respRole),trimws(companyAddress),trimws(companyCity))
  }else
  {
    tmpArr<-data.frame(CompanyName=companyName,Person.Responsible="To Be Checked",Role="To Be Checked", Address="To Be Checked",City="To Be Checked", stringsAsFactors=FALSE)
    #tmpArr<-c(companyName,"To Be Checked","To Be Checked","To Be Checked","To Be Checked")
  }
  disputeResolutionDataFrame <- rbind(disputeResolutionDataFrame,tmpArr)
  return(disputeResolutionDataFrame)
}
#install.packages("XML")
#install.packages("httr")
#install.packages("pracma")
library(XML)
library(httr)
library(pracma)
library(stringr)

OutputFolder <- "./Data"
separator <- "|#|";
companyInfo <- readLines("./Links.txt")

companyInfoSplit <- strsplit(companyInfo, separator,fixed=T)
print(length(companyInfoSplit))
if(length(companyInfoSplit)>0)
{
  otherEntitiesDataFrame<-data.frame(CompanyName=character(),OtherEntities=character(), stringsAsFactors=FALSE)
  industriesDataFrame<-data.frame(CompanyName=character(),Industries=character(), SubType=character(), stringsAsFactors=FALSE)
  participationDataFrame<-data.frame(CompanyName=character(),Participation=character(),Certification.Date=character(),Certification.Due.Date=character(), Type=character(), stringsAsFactors=FALSE)
  privacyPolicyDataFrame<-data.frame(CompanyName=character(),Verification.Method=character(), stringsAsFactors=FALSE)
  disputeResolutionDataFrame<-data.frame(CompanyName=character(),Person.Responsible=character(),Role=character(), Address=character(),City=character(), stringsAsFactors=FALSE)
  wrongURLDataFrame<-data.frame(CompanyName=character(),URL=character(), stringsAsFactors=FALSE)
  for (i in 1:length(companyInfoSplit))
  #for (i in 1:1)
  {
    companyName <- trimws(companyInfoSplit[[i]][1])
    companyURL <- trimws(companyInfoSplit[[i]][2])
    print(i)
    print(companyName)
    htmlGetCompany <- GET(companyURL) ##list
    htmlContentTextCompany <- content(htmlGetCompany, as="text") ##character
    parsedHtmlCompany <- htmlParse(htmlContentTextCompany) ##externalptr
    ### GENERAL: GET PANELS
    pagePanels<-xpathSApply(parsedHtmlCompany, "//div[@class='panel panel-default']", saveXML) ##character
    otherEntitiesFlag <- FALSE
    industriesFlag <- FALSE
    participationFlag <- FALSE
    privacyPolicyFlag <- FALSE
    disputeResolutionFlag <- FALSE


    #print("before loop panel")
    if(length(pagePanels)>0)
    {
      for(panelIndex in 1:length(pagePanels))
      {
        #print("in loop panel")
        #print(panelIndex)

        parsedHtmlPanel <- htmlParse(pagePanels[panelIndex]) ##externalptr
        panelTitle<-xpathSApply(parsedHtmlPanel,"//div[@class='panel-heading']",xmlValue)

        if(strcmpi(trimws(panelTitle),c("Other Covered Entities"))) ### Other Covered Entities ###
        {
          #print("covered entities in")
          otherEntitiesDataFrame <- processOtherEntitiesPanel(pagePanels[panelIndex],otherEntitiesDataFrame,companyName)
          otherEntitiesFlag <- TRUE
          #print("covered entities out")

        }else if(strcmpi(trimws(panelTitle),c("Industries"))) ### Industries ###
        {
          #print("industries in")
          industriesDataFrame <- processIndustriesPanel(pagePanels[panelIndex],industriesDataFrame,companyName)
          industriesFlag <- TRUE
          #print("industries out")
        }else if(strcmpi(trimws(panelTitle),c("Participation"))) ### Participation ###
        {
          #print("partic in")
          participationDataFrame<- processParticipationPanel(pagePanels[panelIndex],participationDataFrame,companyName)
          participationFlag <- TRUE
          #print("partic out")
        }else if(strcmpi(trimws(panelTitle),c("Privacy Policy"))) ### Privacy Policy  ###
        {
          #print("privacy in")
          privacyPolicyDataFrame <- processPrivacyPolicyPanel(pagePanels[panelIndex],privacyPolicyDataFrame,companyName)
          privacyPolicyFlag <- TRUE
          #print("privacy out")
        }else if(strcmpi(trimws(panelTitle),c("Dispute Resolution"))) ### Dispute Resolution  ###
        {
          #print("dispute in")
          disputeResolutionDataFrame <- processDisputeResolutionPanel(pagePanels[panelIndex],disputeResolutionDataFrame,companyName)
          disputeResolutionFlag <- TRUE
          #print("dispute out")
        }
      }

      if(!otherEntitiesFlag)
      {
        tmpArr<-data.frame(CompanyName=companyName,OtherEntities="Missing", stringsAsFactors=FALSE)
        #tmpArr<-c(companyName,"Missing")
        otherEntitiesDataFrame <- rbind(otherEntitiesDataFrame,tmpArr)
      }
      if(!industriesFlag)
      {
        tmpArr<-data.frame(CompanyName=companyName,Industries="Missing", SubType="Missing", stringsAsFactors=FALSE)
        #tmpArr<-c(companyName,"Missing","Missing")
        industriesDataFrame <- rbind(industriesDataFrame,tmpArr)
      }
      if(!participationFlag)
      {
        tmpArr <-data.frame(CompanyName="Missing",Participation="Missing",Certification.Date="Missing",Certification.Due.Date="Missing", Type="Missing", stringsAsFactors=FALSE)
        #tmpArr<-c(companyName,"Missing","Missing","Missing","Missing")
        participationDataFrame<-rbind(participationDataFrame,tmpArr)
      }
      if(!privacyPolicyFlag)
      {
        tmpArr<-data.frame(CompanyName=companyName,Verification.Method="Missing", stringsAsFactors=FALSE)
        #tmpArr<-c(companyName,"Missing")
        privacyPolicyDataFrame<-rbind(privacyPolicyDataFrame,tmpArr)
      }
      if(!disputeResolutionFlag)
      {
        tmpArr<-data.frame(CompanyName=companyName,Person.Responsible="Missing",Role="Missing", Address="Missing",City="Missing", stringsAsFactors=FALSE)
        #tmpArr<-c(companyName,"Missing","Missing","Missing","Missing")
        disputeResolutionDataFrame<-rbind(disputeResolutionDataFrame,tmpArr)
      }
    }else
    {
      tmpArr<-data.frame(CompanyName=companyName,URL=companyURL, stringsAsFactors=FALSE)
      #tmpArr<-c(companyName,companyURL)
      wrongURLDataFrame<-rbind(wrongURLDataFrame,tmpArr)
    }

  }
  print("Company Processed")
  #companyDF_columnNames=c("CompanyName","Participation", trimws(detailsSplit[[1]][1]),trimws(detailsSplit[[2]][1]),trimws(detailsSplit[[3]][1]))
  #colnames(participationDataFrame)<-companyDF_columnNames

}else
{
  msg<-"ERROR COMPANY NAMES AND LINKS HAVE DIFFERENT LEGNTHS: "
  #msg<-paste(msg,as.character(length(companyNames)),as.character(length(companyLinks), separator="")
  print(msg)
}

##Convert Dates
participationDataFrame$Certification.Date <- as.Date(participationDataFrame$Certification.Date, format = "%m/%d/%Y")
participationDataFrame$Certification.Due.Date <- as.Date(participationDataFrame$Certification.Due.Date, format = "%m/%d/%Y")

##df.out
industriesDataFrame$CompanyName <- as.character(industriesDataFrame$CompanyName)
disputeResolutionDataFrame$CompanyName <- as.character(disputeResolutionDataFrame$CompanyName)
sectorCityBoss <- dplyr::left_join(industriesDataFrame, disputeResolutionDataFrame, by="CompanyName")
sectorCityBoss <- sectorCityBoss[,c("CompanyName","Industries", "SubType","Person.Responsible","Role","City","Address")]

if(!file.exists(OutputFolder))
{
  dir.create(OutputFolder)
}

write.table(sectorCityBoss,file = paste(OutputFolder,"/sectorCityBoss.csv", sep=""), sep=";", quote=F, na="None", row.names = F)
write.table(otherEntitiesDataFrame,file = paste(OutputFolder,"/otherEntitiesDataFrame.csv", sep=""), sep=";", quote=F, na="None", row.names = F)
write.table(industriesDataFrame,file = paste(OutputFolder,"/industriesDataFrame.csv", sep=""), sep=";", quote=F, na="None", row.names = F)
write.table(participationDataFrame,file = paste(OutputFolder,"/participationDataFrame.csv", sep=""), sep=";", quote=F, na="None", row.names = F)
write.table(privacyPolicyDataFrame,file = paste(OutputFolder,"/privacyPolicyDataFrame.csv", sep=""), sep=";", quote=F, na="None", row.names = F)
write.table(disputeResolutionDataFrame,file = paste(OutputFolder,"/disputeResolutionDataFrame.csv", sep=""), sep=";", quote=F, na="None", row.names = F)
write.table(wrongURLDataFrame,file = paste(OutputFolder,"/wrongURLDataFrame.csv", sep=""), sep=";", quote=F, na="None", row.names = F)

saveRDS(sectorCityBoss,file = paste(OutputFolder,"/sectorCityBoss.rds", sep=""))
saveRDS(otherEntitiesDataFrame,file = paste(OutputFolder,"/otherEntitiesDataFrame.rds", sep=""))
saveRDS(industriesDataFrame,file = paste(OutputFolder,"/industriesDataFrame.rds", sep=""))
saveRDS(participationDataFrame,file = paste(OutputFolder,"/participationDataFrame.rds", sep=""))
saveRDS(privacyPolicyDataFrame,file = paste(OutputFolder,"/privacyPolicyDataFrame.rds", sep=""))
saveRDS(disputeResolutionDataFrame,file = paste(OutputFolder,"/disputeResolutionDataFrame.rds", sep=""))
saveRDS(wrongURLDataFrame,file = paste(OutputFolder,"/wrongURLDataFrame.rds", sep=""))
