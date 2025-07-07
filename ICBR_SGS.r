# Importando estatísticas fiscais do BCB
library(writexl)
library(GetBCBData)
library(tidyverse)
library(dplyr)
library(beepr)
library(gridExtra)

choose.files() # Apenas para triggar o funcionamento correto do choose.dir()
diretorio <- choose.dir()
setwd(diretorio)
getwd()

# Importando dados do BCB
IC_BR <- GetBCBData::gbcbd_get_series(
        id = c(
                "ICBR" = 27574, "AGRO" = 27575, "METAL" = 27576,
                "ENERGIA" = 27577, "ENERGIAUSD" = 29039,
                "METALUSD" = 29040, "AGROUSD" = 29041, "ICBRUSD" = 29042),
        first.date = "2022-01-01",
        last.date = Sys.Date(),
        format.data = "wide"
)
tail(IC_BR)

# Define a coluna data como a primeira coluna
IC_BR$ref.date <- as.Date(IC_BR$ref.date)

# Definindo os pares de colunas
pares <- list(
  c("ICBR", "ICBRUSD"),
  c("AGRO", "AGROUSD"), 
  c("METAL", "METALUSD"),
  c("ENERGIA", "ENERGIAUSD")
)

# Criando lista para armazenar os gráficos
graficos <- list()

# Gerando gráfico para cada par
for(i in 1:length(pares)) {
  par <- pares[[i]]
  col_brl <- par[1]
  col_usd <- par[2]
  
  # Calculando fator de escala baseado nos valores máximos
  max_brl <- max(IC_BR[[col_brl]], na.rm = TRUE)
  max_usd <- max(IC_BR[[col_usd]], na.rm = TRUE)
  fator_escala <- max_brl / max_usd
  
  # Criando o gráfico com eixos duplos
  grafico <- ggplot(IC_BR, aes(x = ref.date)) +
    geom_line(aes_string(y = col_brl, color = "'BRL'"), size = 1.3) +
    geom_line(aes_string(y = paste0(col_usd, " * ", fator_escala), color = "'USD'"), size = 1.3) +
    scale_y_continuous(
      name = "BRL",
      sec.axis = sec_axis(~ . / fator_escala, 
                         name = "USD",
                         breaks = scales::pretty_breaks(n = 5))
    ) +
    labs(
      title = gsub("USD", "", col_usd),
      x = "Data",
      color = "Moeda"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
      axis.title = element_text(size = 19),
      axis.text = element_text(size = 19),
      legend.text = element_text(size = 19),
      legend.title = element_text(size = 19),
      legend.position = "bottom",
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    ) +
    scale_color_manual(values = c("BRL" = "#189CD8", "USD" = "#404040"))
  
  graficos[[i]] <- grafico
}

# Definindo timestamp para os arquivos
timestamp <- format(Sys.time(), "%Y%m%d")

# Exibindo todos os gráficos em uma grade 2x2
grid.arrange(grobs = graficos, ncol = 2, nrow = 2)

# Salvando os gráficos individuais em PNG
for(i in 1:length(pares)) {
  par <- pares[[i]]
  nome_grafico <- paste0("grafico_", gsub("USD", "", par[2]), "_", timestamp, ".png")
  ggsave(nome_grafico, graficos[[i]], width = 12, height = 8, dpi = 300)
}

# Salvando o arquivo com um timestamp
timestamp <- format(Sys.time(), "%Y%m%d")
nome_arquivo <- paste0("icbr_", timestamp, ".xlsx")

write_xlsx(IC_BR, nome_arquivo)

# Reproduzindo o som de notificação
beep(sound = 1)

summary(IC_BR)
