# Importando estatísticas fiscais do BCB
install.packages("GetBCBData")

library(writexl)
library(GetBCBData)
library(tidyverse)
library(dplyr)
library(beepr)

choose.files() # Para triggar o diálogo de escolha de arquivos
diretorio <- choose.dir()
setwd(diretorio) # Definindo o diretório de trabalho
getwd() # Verificando o diretório de trabalho


# Importando dados do BCB
estatisticas_fiscais <- GetBCBData::gbcbd_get_series(
  id = c(
    "DBGG" = 13762, "DLSP" = 4513,
    "RPGFRSMM" = 7853, "RPBCBRSMM" = 4641, "RPINSSRSMM" = 7854,
    "RPGCRSMM" = 4639, "RPGCRS12M" = 5068, "RPGC12MPIB" = 5783,
    "RPGRRSMM" = 4642, "RPEXPVRSMM" = 4645,
    "RPSPCRSMM" = 4649, "RPSPCRS12M" = 5078, "RSPC12MPIB" = 5793,
    "JUROSRSMM" = 4616, "JUROSRS12M" = 5045, "JUROS12MPIB" = 5760,
    "RNSPCRSMM" = 4583, "RNSPCRS12M" = 5012, "RNSPC12MPIB" = 5727
  ),
  first.date = "2023-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
tail(estatisticas_fiscais)

# Dividindo colunas específicas por 1000
estatisticas_fiscais <- estatisticas_fiscais %>%
  mutate(
    across(
      .cols = -c(ref.date, DBGG, DLSP, RPGC12MPIB, RSPC12MPIB, JUROS12MPIB, RNSPC12MPIB), # Mantém essas inalteradas
      .fns = ~ . / 1000 # Aplica esta função a todas as demais colunas
    )
  )

# Algumas séries vêm como "necessidade de financiamento". Para transformá-las em "resultado", multiplicamos por -1.
estatisticas_fiscais <- estatisticas_fiscais %>%
  mutate(
    across(
      .cols = -c(ref.date, DBGG, DLSP, JUROSRSMM, JUROSRS12M, JUROS12MPIB), # Mantém estas inalteradas
      .fns = ~ . * -1 # Aplica esta função a todas as demais colunas
    )
  )

# Salvando o arquivo com um timestamp
timestamp <- format(Sys.time(), "%Y%m%d")
nome_arquivo <- paste0("estatisticas_fiscais_", timestamp, ".xlsx")

write_xlsx(estatisticas_fiscais, nome_arquivo)

# Reproduzindo o som de notificação
beep(sound = 1) # Som de notificação
