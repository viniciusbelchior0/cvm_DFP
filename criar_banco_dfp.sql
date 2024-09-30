DROP TABLE IF EXISTS demonstracoes;
DROP TABLE IF EXISTS companhias;

CREATE TABLE companhias(
    cd_cvm character varying(10) NOT NULL,
    nome_companhia character varying(150) NOT NULL,
    PRIMARY KEY (cd_cvm)
);


CREATE TABLE demonstracoes(
    cia_ano character varying(12) NOT NULL,
    ano date NOT NULL,
    cd_cvm character varying(10) NOT NULL,
    ativo_total bigint,
    ativo_circulante bigint,
    ativo_nao_circulante bigint,
    passivo_total bigint,
    passivo_circulante bigint,
    passivo_nao_circulante bigint,
    patrimonio_liquido bigint,
    receitas bigint,
    resultado_operacional bigint,
    lucro_liquido bigint,
    fc_operacional bigint,
    fc_investimento bigint,
    fc_financiamento bigint,
    fc_diferenca bigint,
    liquidez_geral double precision,
    liquidez_corrente double precision,
    prop_capitalterceiros double precision,
    endividamento_geral double precision,
    margem_operacional double precision,
    margem_liquida double precision,
    roe double precision,
    fluxocaixa_livre bigint,
    PRIMARY KEY (cia_ano),
    CONSTRAINT fk_cd_cvm FOREIGN KEY (cd_cvm) REFERENCES companhias(cd_cvm)
);