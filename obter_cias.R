library(httr)
library(purrr)
library(dplyr)
library(tidyverse)
library(RPostgreSQL)

setwd("C:/Users/NOTEBOOK CASA/Desktop/cvm_DFPs")

#1. Criando as Funções
obter_dfp <- function(ano){
  url <- paste0("https://dados.cvm.gov.br/dados/CIA_ABERTA/DOC/DFP/DADOS/","dfp_cia_aberta_",ano,".zip") #copiando a URL dos arquivos
  GET(url, write_disk(paste0("dfp_cia_aberta_",ano,".zip"))) #baixando os arquivos
  planilhas <- unzip(paste0("C:/Users/NOTEBOOK CASA/Desktop/cvm_DFPs/dfp_cia_aberta_",ano,".zip"))
} #descompactando os arquivos .RAR

obter_cias <- function(){
  #Listando os arquivos no diretório referente às demonstrações financeiras
  CIA <- list.files(path = ".", pattern = "^dfp_cia_aberta_20", full.names = TRUE)
  
  #Lendo os arquivos
  CIA <- read_csv2(CIA, id = "file_name",locale = locale(encoding = "ISO-8859-1"))
  
  #Obtendo o código e o nome das empresas
  CIA <- CIA %>% select(CD_CVM,DENOM_CIA) %>% distinct(CD_CVM,DENOM_CIA)
  
  #Convertendo para dataframe
  CIAS <- as.data.frame(CIA)
  names(CIAS) <- c("cd_cvm","nome_companhia")
  CIAS <- CIAS %>% distinct(cd_cvm, .keep_all = TRUE)
  
  #Salvando os arquivo gerados e deletando os outros
  write.csv(CIAS,"cias.csv")
  f <- list.files(path = ".", pattern = "^dfp_cia_aberta", full.names = TRUE, recursive = TRUE)
  file.remove(f)
  
  return(CIAS)
}


#2. Coletando os dados
anos <- as.integer(format(Sys.Date(),"%Y")) - 1 #alterar para a data desejada

for (ano in anos){
  obter_dfp(ano)
}

cias <- obter_cias()

#3. Inserindo os dados no BD
inserir_dados_cias <- function(df){
  con <- dbConnect(RPostgres::Postgres(), dbname = "teste_dados_r",
                 host = "localhost", port = "5432",
                 user = "postgres", password = "admin") # Estabelecer conexão com o banco de dados PostgreSQL
  
  
  #Obtendo lista de todas as companhias já existentes no BD e filtrando apenas novas
  todas_cias <- dbGetQuery(con,"SELECT * FROM companhias")
  df <- df %>% anti_join(todas_cias)
  
  if (nrow(df) > 0) {
    dbWriteTable(conn = con, name = "companhias", value = df,
                                  row.names = FALSE, overwrite = FALSE, append = TRUE)
    cat("Dados inseridos com sucesso.")} else {cat("Nenhuma nova companhia. Nenhum dado inserido")}
  
  dbDisconnect(con) # Fechar a conexão com o banco de dados
}

inserir_dados_cias(cias)
