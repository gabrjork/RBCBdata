# Importando estatísticas monetárias e de crédito do BCB



library(writexl)
library(GetBCBData)
library(tidyverse)
library(dplyr)
library(beepr)

choose.files() # Apenas para triggar o funcionamento correto do choose.dir()
diretorio <- choose.dir()
setwd(diretorio)
getwd()

# Importando dados do BCB
estatisticas_credito <- GetBCBData::gbcbd_get_series(
  id = c(
    "CONCTOTAL" = 24439, "CONCLIVRES" = 24442, "CONCDIR" = 24445,
    "CONCPJ" = 24440, "CONCPF" = 24441,
    "CONCPFDIR" = 24447, "CONCPJDIR" = 24446,
    "CONCPFLIVRE" = 24444, "CONCPJLIVRE" = 24443,
    "PJRURAL" = 20689, "PJIMOB" = 20692, "PJBNDES" = 20696, "PJOUTROS" = 20697,
    "PFRURAL" = 20701, "PFIMOB" = 20704, "PFBNDES" = 20708, "PFMICRO" = 20712, "PFOUTROS" = 20713,
    "INADTOTAL" = 21082, "INADPJ" = 21083, "INADPF" = 21084,
    "INADLIVRES" = 21085, "INADDIR" = 21132,
    "SPREADTOTAL" = 20783, "SPREADPJ" = 20784, "SPREADPF" = 20785,
    "JUROSTOTAL" = 20714, "JUROSLIVREPF" = 20740, "JUROSLIVREPJ" = 20718, "JUROSDIRPF" = 20768, "JUROSDIRPJ" = 20757,
    "ENDIVTOTAL" = 29037, "ENDIVEXIMOB" = 29038, "COMPRENDA" = 29034, "COMPRENDAEXIMOB" = 29035
  ),
  first.date = "2023-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
tail(estatisticas_credito)

# Dividindo colunas específicas por 1000
estatisticas_credito <- estatisticas_credito %>%
  mutate(
    across(
      .cols = -c(
        ref.date, INADTOTAL, INADPJ, INADPF, INADLIVRES, INADDIR,
        SPREADTOTAL, SPREADPJ, SPREADPF, ENDIVTOTAL, ENDIVEXIMOB,
        COMPRENDA, COMPRENDAEXIMOB, JUROSTOTAL, JUROSLIVREPF, JUROSLIVREPJ, JUROSDIRPF, JUROSDIRPJ,
        JUROSLIVREPF, JUROSLIVREPJ
      ), # Mantém essas inalteradas
      .fns = ~ . / 1000 # Aplica esta função a todas as demais colunas
    )
  )

# Salvando o arquivo com um timestamp
timestamp <- format(Sys.time(), "%Y%m%d")
nome_arquivo <- paste0("estatisticas_credito_", timestamp, ".xlsx")

write_xlsx(estatisticas_credito, nome_arquivo)

# Reproduzindo o som de notificação
beep(sound = 1)
