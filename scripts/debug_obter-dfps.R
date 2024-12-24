#cvm_dfp <- function(){
  
  
url <- paste0("https://dados.cvm.gov.br/dados/CIA_ABERTA/DOC/DFP/DADOS/","dfp_cia_aberta_","2024",".zip") #copiando a URL dos arquivos
GET(url, write_disk(paste0("dfp_cia_aberta_","2024",".zip"))) #baixando os arquivos
planilhas <- unzip(paste0("C:/Users/user/Desktop/cvm_DFPs/dfp_cia_aberta_","2024",".zip"))

#Listando os arquivos no diretório referente às demonstrações financeiras
BPA <- list.files(path = ".", pattern = "^dfp_cia_aberta_BPA_con_", full.names = TRUE)
BPP <- list.files(path = ".", pattern = "^dfp_cia_aberta_BPP_con_", full.names = TRUE)
DRE <- list.files(path = ".", pattern = "^dfp_cia_aberta_DRE_con_", full.names = TRUE)
#DFC <- list.files(path = ".", pattern = "^dfp_cia_aberta_DFC_MD_con_", full.names = TRUE)
  
#Lendo os arquivos todos de uma vez para cada demonstração
#Quando necessário: advinhar o encoding usar a função readr::guess_encoding
BPA <- read_csv2(BPA, id = "file_name",locale = locale(encoding = "ISO-8859-1"))
BPP <- read_csv2(BPP, id = "file_name",locale = locale(encoding = "ISO-8859-1"))
DRE <- read_csv2(DRE, id = "file_name",locale = locale(encoding = "ISO-8859-1"))
#DFC <- read_csv2(DFC, id = "file_name",locale = locale(encoding = "ISO-8859-1"))
  
#Balanço Patrimonial - Ativo
BPA <- BPA %>% filter(ORDEM_EXERC == "ÚLTIMO" & ST_CONTA_FIXA == "S") %>%
    select(DT_REFER,DENOM_CIA,CD_CVM,GRUPO_DFP,ESCALA_MOEDA,ORDEM_EXERC,DS_CONTA,VL_CONTA) %>%
    mutate(VL_CONTA = as.double(VL_CONTA), GRUPO_DFP = str_replace_all(GRUPO_DFP,"DF Consolidado - Balanço Patrimonial Ativo","BPA")) %>%
    filter(DS_CONTA %in% c("Ativo Total", "Caixa e Equivalentes de Caixa","Aplicações Financeiras","Empréstimos e Recebíveis",
                           "Tributos Diferidos","Outros Ativos","Investimentos","Imobilizado","Intangível","Ativo Circulante","Ativo Não Circulante") &
             VL_CONTA>=0) %>%
    mutate(DS_CONTA = str_replace_all(DS_CONTA,c("Caixa e Equivalentes de Caixa"="Ativo Circulante","Aplicações Financeiras"="Ativo Não Circulante",
                                                 "Empréstimos e Recebíveis"="Ativo Não Circulante","Tributos Diferidos"="Ativo Não Circulante",
                                                 "Outros Ativos"="Ativo Não Circulante","Investimentos"="Ativo Não Circulante","Imobilizado"="Ativo Não Circulante",
                                                 "Intangível"="Ativo Não Circulante"))) %>%
    select(DT_REFER, DENOM_CIA, CD_CVM, GRUPO_DFP, DS_CONTA, VL_CONTA)
  
#Balanço Patrimonial - Passivo
BPP <- BPP %>% filter(ORDEM_EXERC == "ÚLTIMO" & ST_CONTA_FIXA == "S") %>%
    select(DT_REFER,DENOM_CIA,CD_CVM,GRUPO_DFP,ESCALA_MOEDA,ORDEM_EXERC,DS_CONTA,VL_CONTA) %>%
    mutate(VL_CONTA = as.double(VL_CONTA), GRUPO_DFP = str_replace_all(GRUPO_DFP,"DF Consolidado - Balanço Patrimonial Passivo","BPP")) %>%
    filter(DS_CONTA %in% c("Passivo Total","Passivos Financeiros para Negociação","Outros Passivos Financeiros ao Valor Justo no Resultado",
                           "Passivos Financeiros ao Custo Amortizado","Provisões","Passivos Fiscais","Outros Passivos","Passivos sobre Ativos Não Correntes a Venda e Descontinuados",
                           "Patrimônio Líquido Consolidado","Passivo Circulante","Passivo Não Circulante") &
             VL_CONTA>=0) %>%
    mutate(DS_CONTA = str_replace_all(DS_CONTA, c("Passivos Financeiros para Negociação"="Passivo Circulante","Outros Passivos Financeiros ao Valor Justo no Resultado"="Passivo Circulante",
                                                  "Passivos Financeiros ao Custo Amortizado"="Passivo Circulante","Provisões"="Passivo Não Circulante","Passivos Fiscais"="Passivo Não Circulante",
                                                  "Outros Passivos"="Passivo Não Circulante","Passivos sobre Ativos Não Correntes a Venda e Descontinuados"="Passivo Não Circulante",
                                                  "Patrimônio Líquido Consolidado"="Patrimônio Líquido"))) %>%
    select(DT_REFER, DENOM_CIA, CD_CVM, GRUPO_DFP, DS_CONTA, VL_CONTA)
  
#Demonstração de Resultado
DRE <- DRE %>% filter(ORDEM_EXERC == "ÚLTIMO" & ST_CONTA_FIXA == "S") %>%
    select(DT_REFER,DENOM_CIA,CD_CVM,GRUPO_DFP,ESCALA_MOEDA,ORDEM_EXERC,DS_CONTA,VL_CONTA) %>%
    mutate(VL_CONTA = as.double(VL_CONTA), GRUPO_DFP = str_replace_all(GRUPO_DFP,"DF Consolidado - Demonstração do Resultado","DRE")) %>%
    filter(DS_CONTA %in% c("Receitas da Intermediação Financeira","Resultado Antes dos Tributos sobre o Lucro","Lucro/Prejuízo Consolidado do Período",
                           "Receita de Venda de Bens e/ou Serviços","Resultado Antes do Resultado Financeiro e dos Tributos",
                           "Receitas das Operações")) %>%
    mutate(DS_CONTA = str_replace_all(DS_CONTA, c("Receitas da Intermediação Financeira"="Receitas","Receita de Venda de Bens e/ou Serviços"="Receitas","Receitas das Operações"="Receitas",
                                                  "Resultado Antes dos Tributos sobre o Lucro"="Resultado Operacional","Resultado Antes do Resultado Financeiro e dos Tributos"="Resultado Operacional",
                                                  "Lucro/Prejuízo Consolidado do Período"="Lucro Líquido"))) %>%
    select(DT_REFER, DENOM_CIA, CD_CVM, GRUPO_DFP, DS_CONTA, VL_CONTA)
  
#Demonstração do Fluxo de Caixa
#DFC <- DFC %>% filter(ORDEM_EXERC == "ÚLTIMO" & ST_CONTA_FIXA == "S") %>%
  #select(DT_REFER,DENOM_CIA,CD_CVM,GRUPO_DFP,ESCALA_MOEDA,ORDEM_EXERC,DS_CONTA,VL_CONTA) %>%
  #mutate(VL_CONTA = as.double(VL_CONTA), GRUPO_DFP = str_replace_all(GRUPO_DFP,"DF Consolidado - Demonstração do Fluxo de Caixa (Método Direto)","DFC")) %>%
  #filter(DS_CONTA %in% c("Caixa Líquido Atividades Operacionais","Caixa Líquido Atividades de Investimento","Caixa Líquido Atividades de Financiamento",
  #                       "Aumento (Redução) de Caixa e Equivalentes")) %>%
  #select(DT_REFER, DENOM_CIA, CD_CVM, GRUPO_DFP, DS_CONTA, VL_CONTA)
  
#Unindo as Demonstrações em um mesmo arquivo
lista_dfs <- list(BPA,BPP,DRE)#,DFC)
lista_dfs <- lista_dfs[sapply(lista_dfs, nrow) > 0]
DFP <- bind_rows(lista_dfs)
DFP <- DFP %>% select(DT_REFER, CD_CVM, DS_CONTA, VL_CONTA)
  
#Transformando linhas em colunas para melhor organização e leitura dos dados
DFP_wider <- DFP %>% pivot_wider(id_cols = c(DT_REFER, CD_CVM),names_from = DS_CONTA,values_from = VL_CONTA, values_fn = sum) %>%
    mutate(cia_ano = paste(CD_CVM,year(DT_REFER),sep = "_"),
           Liquidez_Geral = (`Ativo Circulante`+`Ativo Não Circulante`)/(`Passivo Circulante` + `Passivo Não Circulante`),
           Liquidez_Corrente = `Ativo Circulante`/`Passivo Circulante`,
           Prop_CapitalTerceiros = (`Passivo Circulante` + `Passivo Não Circulante`)/(`Passivo Circulante` + `Passivo Não Circulante` + `Patrimônio Líquido`),
           Endividamento_Geral =(`Passivo Circulante` + `Passivo Não Circulante`)/(`Ativo Circulante`+`Ativo Não Circulante`),
           Margem_Operacional = `Resultado Operacional`/`Receitas`,
           Margem_Liquida =`Lucro Líquido`/`Receitas`,
           ROE = `Lucro Líquido`/`Patrimônio Líquido`) %>% #,FluxoCaixa_Livre = `Caixa Líquido Atividades Operacionais` + `Caixa Líquido Atividades de Investimento`) %>%
    select(13,1:12,14:20) %>%
    filter_if(~is.numeric(.), all_vars(!is.infinite(.)))
  
#Convertendo os arquivos para dataframe
DFP_long <- as.data.frame(DFP)
DFP_wide <- as.data.frame(DFP_wider)
  
#Alterando os nomes das colunas
names(DFP_wide) <- c("cia_ano","ano","cd_cvm","ativo_total","ativo_circulante",
                       "ativo_nao_circulante","passivo_total","passivo_circulante",
                       "passivo_nao_circulante","patrimonio_liquido","receitas",
                       "resultado_operacional","lucro_liquido","liquidez_geral",
                       "liquidez_corrente","prop_capitalterceiros","endividamento_geral",
                       "margem_operacional","margem_liquida","roe")#,"fc_operacional","fc_investimento","fc_financiamento","fc_diferenca","fluxocaixa_livre")
  
DFP_wide <- DFP_wide %>% mutate(across(ativo_total:lucro_liquido,as.integer)) %>%
    mutate(across(liquidez_geral:roe, as.double)) %>%
    #mutate(fluxocaixa_livre = as.integer(fluxocaixa_livre)) %>%
    distinct(cia_ano, .keep_all = TRUE)
  
#Salvando os arquivo gerados e deletando os outros
write.csv(DFP_long,"dfp_long.csv")
write.csv(DFP_wide,"dfp_wide.csv")
f <- list.files(path = ".", pattern = "^dfp_cia_aberta", full.names = TRUE, recursive = TRUE)
file.remove(f)

#return(DFP_wide)
#}

#dados <- cvm_dfp()
