# Importando estatísticas do setor externo do BCB
install.packages("GetBCBData") # CRAN v0.6

library(writexl)
library(GetBCBData)
library(tidyverse)
library(dplyr)
library(beepr)

choose.files() # Para triggar o diálogo de escolha de arquivos
diretorio <- choose.dir()
setwd(diretorio) # Definindo o diretório de trabalho

# Importando dados do BCB
estatisticas_externas <- GetBCBData::gbcbd_get_series(
  id = c(
    "TRANSCORRMMUSD" = 22701, "TRANSCORR12MUSD" = 24419, "TRANSCORR12MPIB" = 23079,
    "IDPMMUSD" = 22885, "IDP12MUSD" = 24422, "IDP12MPIB" = 23080, "EXP" = 22708, "IMP" = 22709, "EXPLIQ" = 22707,
    "SERVUSDMM" = 22719, "INVCART" = 22905, "RESERVASMMUSD" = 3546, "RENDAPRIMMUSD" = 22800, "RENDASECMMUSD" = 22838
  ),
  first.date = "2023-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
tail(estatisticas_externas)

# Dividindo colunas específicas por 1000
estatisticas_externas <- estatisticas_externas %>%
  mutate(
    TRANSCORRMMUSD = TRANSCORRMMUSD / 1000,
    TRANSCORR12MUSD = TRANSCORR12MUSD / 1000,
    IDPMMUSD = IDPMMUSD / 1000,
    IDP12MUSD = IDP12MUSD / 1000,
    EXPLIQ = EXPLIQ / 1000,
    EXP = EXP / 1000,
    IMP = IMP / 1000,
    SERVUSDMM = SERVUSDMM / 1000,
    INVCART = INVCART / 1000,
    RESERVASMMUSD = RESERVASMMUSD / 1000,
    RENDAPRIMMUSD = RENDAPRIMMUSD / 1000,
    RENDASECMMUSD = RENDASECMMUSD / 1000,
    RENDASPRIMSECMMUSD = RENDAPRIMMUSD + RENDASECMMUSD
  )

# Salvando o arquivo com um timestamp
timestamp <- format(Sys.time(), "%Y%m%d")
nome_arquivo <- paste0("estatisticas_externas_", timestamp, ".xlsx")
write_xlsx(estatisticas_externas, nome_arquivo)

# Reproduzindo o som de notificação
beep(sound = 1)
