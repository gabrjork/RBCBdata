# Importando séries do IPCA
install.packages("GetBCBData") # CRAN v0.6

library(writexl)
library(GetBCBData) # CRAN v0.6
library(tidyverse) # CRAN v1.0.7
library(beepr) # CRAN v1.3.2

# Definindo o diretório de trabalho
choose.files()
diretorio <- choose.dir()
setwd(diretorio) # Definindo o diretório de trabalho
getwd()

# Importando dados do BCB
IPCAs <- GetBCBData::gbcbd_get_series(
  id = c(
    "IPCA" = 433, "ALIMENTACAO" = 1635, "ADMINISTRADOS" = 4449,
    "LIVRES" = 11428, "NAODURAVEIS" = 10841, "SEMIDURAVEIS" = 10842,
    "DURAVEIS" = 10843, "SERVICOS" = 10844, "INDUSTRIAIS" = 27863,
    "DIFUSAO" = 21379, "IPCAMS" = 4466, "IPCAEX0" = 11427,
    "IPCAEX3" = 27839, "IPCAEXFE" = 28751
  ),
  first.date = "2023-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
tail(IPCAs)

# Salvando o arquivo com um timestamp
timestamp <- format(Sys.time(), "%Y%m%d")
nome_arquivo <- paste0("IPCAs_", timestamp, ".xlsx")

write_xlsx(IPCAs, nome_arquivo)

beep(1) # Som de notificação
