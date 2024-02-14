{crud.i}

//Definições//

DEFINE VARIABLE cArquivo   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iFileSize  AS INTEGER   NO-UNDO.
DEFINE VARIABLE dHoje      AS DATE      NO-UNDO.
DEFINE VARIABLE iIdProduto AS INTEGER   NO-UNDO.
DEFINE VARIABLE lValido    AS LOGICAL   NO-UNDO.

DEFINE BUTTON btNovo      LABEL "NOVO".
DEFINE BUTTON btRelatorio LABEL "RELATORIO".
DEFINE BUTTON btSalvar    LABEL "SALVAR".


// Importando os valores para a tabela temporária//
INPUT FROM VALUE ("/Progress/ttProduto.csv")
    REPEAT:
        CREATE ttProduto.
        IMPORT DELIMITER ";" ttProduto.
    END
INPUT CLOSE.

//Definindo a Query e a Browse//
DEFINE QUERY qrProduto FOR ttProduto.
DEFINE BROWSE brProduto QUERY qrProduto
    DISPLAY ttProduto.cIdProduto LABEL "ID"
            ttProduto.cNome      LABEL "NOME"
            ttProduto.cDescrPro  LABEL "DESC"
            ttProduto.iQuantid   LABEL "QUANT"
            ttProduto.dValor     LABEL "VALOR"
            ttProduto.dtCadast   LABEL "DT.CAD"
            ttProduto.cVendedor  LABEL "VENDE"
            ttProduto.cNomeEmp   LABEL "EMPR"
            ttProduto.lAtivo     LABEL "ATV"
    WITH 10 DOWN COLUMN 3.

//Definindo o Frame inicial 
DEFINE FRAME frMain
        btNovo
        brProduto
        WITH 1 COLUMN SIDE-LABELS.

//Frame da tela de cadastro
DEFINE FRAME fCadastro 
    brProduto 
    btSalvar
    WITH SIDE-LABELS TITLE "CADASTRO DE PRODUTOS".

DEFINE FRAME frDetalhes
    ttProduto.cIdProduto
    ttProduto.cNome
    ttProduto.cDescrPro
    ttProduto.iQuantid
    ttProduto.dValor
    ttProduto.dtCadast
    ttProduto.cVendedor
    ttProduto.cNomeEmp
    ttProduto.lAtivo
    btSalvar
    HELP "F4-PARA SAIR"
    WITH 1 COLUMN SIDE-LABELS TITLE "ALTERACAO DE PRODUTOS"

//Evento para quando clicar no botao novo abrir a tela de cadastro//
ON CHOOSE OF btNovo DO:
    RUN pNovoRegsitro.
END.

ON CHOOSE OF brProduto IN FRAME frMain ANYWHERE DO:
    RUN pAbrirTelaAlteracao.
END.
//Quando a pessoa clica no botao salvar e todas as validacoes no arquivo m estao corretas
//ele atualiza
ON CHOOSE OF btSalvar IN FRAME fCadastro  DO:
     RUN {crudm.p}  pValidaCadastro (cNome,cDescrPro, iQuantid, dValor, dtCadast, cVendedor, cNomeEmp, lAtivo) 
     RETURN lValido.
    IF lValido THEN DO:
        RUN pSalvarDados (cNome, cDescrPro, iQuantid, dValor, dtCadast, cVendedor, cNomeEmp, lAtivo).
        brProduto:QUERY-PREPARE FOR EACH ttProduto NO-LOCK BY ttProduto.cIdProduto DESCENDING.
        brProduto:QUERY-OPEN().
        brProduto:REFRESH().
    HIDE FRAME fCadastro.
    DISPLAY frMain WITH FRAME frMain.
    END.
    ELSE DO:
        MESSAGE "ERRO. OS DADOS DO CADASTRO NAO SAO VALIDOS" VIEW-AS ALERT-BOX
    END.
END.

ON CHOOSE OF brProduto IN FRAME frMain ANYWHERE DO:
    IF LAST-EVENT:KEY = "ENTER" THEN DO: 
        RUN pTelaAlteracao.
    END.
END.

ON CHOOSE OF btSalvar IN FRAME frDetalhes DO:
    ON KEY LABEL "F1" OF FRAME frDetalhes DO:
        CLOSE FRAME frDetalhes.
    END.
    RUN {crudm.p} pValidaCadastro (cNome,cDescrPro, iQuantid, dValor, dtCadast, cVendedor, cNomeEmp, lAtivo) 
    RETURN lValido.
    IF lValido THEN DO:
        RUN pSalvarDados (cNome, cDescrPro, iQuantid, dValor, dtCadast, cVendedor, cNomeEmp, lAtivo).
        brProduto:QUERY-PREPARE FOR EACH ttProduto NO-LOCK BY ttProduto.cIdProduto DESCENDING.
        brProduto:QUERY-OPEN().
        brProduto:REFRESH().
    HIDE FRAME frDetalhes.
    DISPLAY frMain WITH FRAME frMain.
    END.
    ELSE DO:
        MESSAGE "ERRO. OS DADOS DO CADASTRO NAO SAO VALIDOS" VIEW-AS ALERT-BOX
    END.
END.

//Quando abre a aplicacao a procedure inicializa comeca e faz a verificacao se tem 
// algo na ttProdutos se sim chama o frame main e se nao abre uma mensagem
// perguntando se deseja criar um novo registro, se sim abre a procedure que inlui 
// um novo registro e se nao fecha o sistema // 
PROCEDURE pInicializa:
    FIND FIRST ttProduto NO-LOCK NO-ERROR.
    IF AVAILABLE ttProduto THEN DO:
        RUN pAbrirTela.
    END.
    ELSE IF:
        MESSAGE "NAO EXISTEM DADOS CADASTRADOS. DESEJA INCLUIR UM NOVO REGISTRO"
        VIEW-AS QUESTION BUTTONS YES-NO ALERT-BOX.
    END.
    INPUT THROUGH LAST-EVENT.
    IF LAST-EVENT-KEY = KEYCODE("ENTER") THEN DO:
        IF LAST-EVENT-CHOICE = "YES" THEN DO:
            RUN pNovoRegsitro.
        END.
        ELSE IF LAST-EVENT-CHOICE = "NO" THEN DO:  
            QUIT.
        END.
    END.    
END PROCEDURE.

PROCEDURE pAbrirTela:
    ON KEY OF btNovo IN FRAME frMain ANYWHERE DO:
        IF KEYFUNCTION(LAST-EVENT) = "ENTER" THEN DO:
            RUN pNovoRegsitro.
            ELSE IF KEYFUNCTION(LAST-EVENT) = "UP-ARROW" THEN DO:
                IF brProduto:CURR-ITEM > 1 THEN 
                    brProduto:CURR-ITEM = brProduto:CURR-ITEM - 1. 
            END.
            ELSE IF KEYFUNCTION(LAST-EVENT) = "DOWN-ARROW" THEN DO:
                IF brProduto:CURR-ITEM < NUM-ENTRIES(brProduto:QUERY) THEN 
                    brProduto:CURR-ITEM = brProduto:CURR-ITEM + 1. 
            END.
        END.
    DISPLAY frMain WITH FRAME frMain.

END PROCEDURE.

PROCEDURE pNovoRegsitro:
    DISPLAY fCadastro WITH FRAME fCadastro.
END PROCEDURE.

PROCEDURE pTelaAlteracao:
    DEFINE VARIABLE iSelectedRow AS INTEGER.
    iSelectedRow = INTEGER(brProduto:GET-SELECTED-ROW(1)).
    IF iSelectedRow > 0 THEN DO:
        FIND ttProduto WHERE ttProduto.RowId = iSelectedRow NO-LOCK NO-ERROR.
        IF AVAILABLE ttProduto THEN DO:
            UPDATE ttProduto.
            DISPLAY ttProduto WITH FRAME frDetalhes SIDE-LABELS.
        END.
    END.
END PROCEDURE.


