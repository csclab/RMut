

dataf <- c("D:\\Study\\BioInformatics\\BioDatabases\\SignalingNetws\\NetDS_netw\\AMRN - Flower morphogenesis in Arabidopsis.txt",
          "D:\\Study\\BioInformatics\\BioDatabases\\SignalingNetws\\NetDS_netw\\CDRN - Cell differentiation regulatory network.txt",
          "D:\\Study\\BioInformatics\\BioDatabases\\SignalingNetws\\NetDS_netw\\CCSN_reduced.sif",
          "D:\\Study\\BioInformatics\\BioDatabases\\SignalingNetws\\WangLab\\HumanSignalingNet_v1_AHau_nonNeutral.sif")

makeData <- function(dataFile, dataName) {
  net <- read.table(dataFile, stringsAsFactors = FALSE, sep = "\t", col.names = c("Source", "Interaction", "Target"))
  # edges <- c(dataName, length(net$V1))
  #
  # edges <- append(edges, net$V1)
  # edges <- append(edges, net$V2)
  # edges <- append(edges, net$V3)

  newrow <- data.frame(Source = dataName, Interaction = dataName, Target = dataName, stringsAsFactors = FALSE)
  net <- rbind(newrow, net)
  return (net)
}

#amrn <- makeData(dataf[1], "AMRN")
#cdrn <- makeData(dataf[2], "CDRN")
ccsn <- makeData(dataf[3], "CCSN")
hsn <- makeData(dataf[4], "HSN")

#save(amrn, file = 'data/amrn.rdata', compress = 'xz')
#devtools::use_data(amrn, overwrite = TRUE)
#devtools::use_data(cdrn, overwrite = TRUE)
devtools::use_data(ccsn, overwrite = TRUE)
devtools::use_data(hsn, overwrite = TRUE)

