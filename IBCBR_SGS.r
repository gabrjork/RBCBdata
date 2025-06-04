# Importando estatísticas fiscais do BCB
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
IBC_BR <- GetBCBData::gbcbd_get_series(
        id = c(
                "IBCBR" = 24364, "AGRO" = 29602, "INDUSTRIA" = 29604, "SERVICOS" = 29606,
                "IMPOSTOS" = 29610, "IBCBREXAGRO" = 29608, "IBCBRsemajuste" = 24363,
                "agro_semajuste" = 29601,
                "ind_semajuste" = 29603, "serv_semajuste" = 29605, "impostos_semajuste" = 29609, "IBCBREXAGRO_semajuste" = 29607
        ),
        first.date = "2022-01-01",
        last.date = Sys.Date(),
        format.data = "wide"
)
tail(IBC_BR)

# Salvando o arquivo com um timestamp
timestamp <- format(Sys.time(), "%Y%m%d")
nome_arquivo <- paste0("ibcbr_", timestamp, ".xlsx")

write_xlsx(IBC_BR, nome_arquivo)

# Reproduzindo o som de notificação
beep(sound = 1)
