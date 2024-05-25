# Descrição do Projeto
## Fluxo do Projeto

![workflow](https://github.com/viniciusbelchior0/cvm_DFPs/blob/main/references/diagrama_cvm-dfps.png)

As demonstrações financeiras padronizadas (dfp) são disponibilizadas pela CVM em seu site. O propósito do 'projeto' é automatizar a consolidação desses dados, através de seu download, transformação, limpeza, cálculo de indicadores, união e armazenamento. Posteriormente, esses dados serão disponibilizados em um painel e para realização de análises ad-hoc.

# Descrição das Etapas
## 1. Obtenção, limpeza, agregação e armazenamento dos dados
Os dados são disponibilizados pela cvm em sua plataforma, em que demonstrações financeiras estão separadas em diversos arquivos .csv compactados em pastas .RAR. Sendo assim, é necessário que vários arquivos referentes aos diversos anos (2010-2023) sejam baixados, bem como os arquivos referentes às diferentes demonstrações sejam unidas; além disso, esses dados necessitam de limpeza e padronização de algumas informações, assim como do cálculo de medidas. Caso fosse feito manualmente, esse processo demandaria muito trabalho e poderia ocasionar em diversos erros. O próposito da construção do fluxo é automatizar esse processo, garantindo a rigidez e conformidade das informações, para simplificar as atividades de análise e consulta dessas informações. Para isso, será utilizada a linguagem `R` para automatização desse fluxo e do `PostgreSQL` para o posterior armazenamento desses dados.

Primeiro, os diferentes arquivos são baixados, descompactados e as demonstrações de interesse - balanço patrimonial, demonstração de resultado de exercícios e demonstração de fluxo de caixa - são carregadas em um arquivo único para cada demonstração. Então, os arquivos - referentes a cada demonstração - serão individualmente tratados, corrigindo irregularidades nos dados e padronizando informações. Após a correção, todos esses arquivos serão unidos em uma única tabela, que será reordenada através da transformação de linhas em colunas (*pivot*). Em sequência serão calculados os indicadores financeiros referentes a liquidez - corrente e geral, a estrutura de capital - capital de terceiros e endividamento geral - e a rentabilidade - margem líquida, margem operacional e ROE.

A descrição anterior se aplica para obtenção das demonstrações financeiras, bem como parcialmente para a obtenção das empresas listadas - que contêm menos etapas devido a simplicidade das informações a serem coletadas. Após a obtenção desses dados, eles serão inseridos em um banco de dados no PostgreSQL, com uma tabela para propósito - um para companhias e outro para as demonstrações. Inclusive, esse processo pode ser agendado para ser realizado em dias periódicos, através de ferramentas de orquestração.

## 2. Análises
Os dados que foram armazenados no banco de dados servirão como insumo para análise, seja ela através de relatório interativos ou de consultas específicas.

O relatório interativo (dashboard) disponibiliza as informações em tabela e gráficos, além da utilização de filtros, para facilitação da condução da análise e visualização das informações.

(Em desenvolvimento) Na análise ad-hoc, esses dados serão consultados para a elaboração de um report com o objetivo de elaborar um score, baseado nos indicadores financeiros, para classificar e organizar as empresas com os melhores resultados ao longo dos anos e, após a obtenção dessa listagem, serão calculadas as carteiras ótimas contendo as ações dessas empresas com base na Teoria de Markowitz.

(Em desenvolvimento) A elaboração de um sample de equity research, envolvendo a análise de demonstrações financeiras, tendências de mercado, desempenho histórico e projeções futuras, através do valuation, para determinar o valor intrínseco das ações de determinada companhia.
