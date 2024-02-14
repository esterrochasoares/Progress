{crud.i}

INPUT FROM VALUE ("/Progress/ttEmpresa.csv")
    REPEAT:
        CREATE ttEmpresa.
        IMPORT DELIMITER ";" ttEmpresa.
    END
INPUT CLOSE.


INPUT FROM VALUE ("/Progress/ttVendedor.csv")
    REPEAT:
        CREATE ttVendedor.
        IMPORT DELIMITER ";" ttVendedor.
    END
INPUT CLOSE.

PROCEDURE pValidaCadastro :
    DEFINE INPUT PARAMETER cNome     AS CHARACTER.
    DEFINE INPUT PARAMETER cDescrPro AS CHARACTER.
    DEFINE INPUT PARAMETER iQuantid  AS INTEGER.
    DEFINE INPUT PARAMETER dValor    AS DECIMAL.
    DEFINE INPUT PARAMETER dtCadast  AS DATE.
    DEFINE INPUT PARAMETER cVendedor AS CHARACTER.
    DEFINE INPUT PARAMETER cNomeEmp  AS CHARACTER.
    DEFINE INPUT PARAMETER lAtivo    AS LOGICAL.

    FIND FIRST ttProduto WHERE ttProduto.cNome = cNome NO-LOCK NO-ERROR.
    IF AVAILABLE ttProduto THEN DO:
        MESSAGE "O NOME DO PRODUTO JA EXISTE. ESCOLHA OUTRO NOME" VIEW-AS ALERT-BOX.
        RETURN FALSE.
    END.
    IF dValor < 0 THEN DO:
        MESSAGE "O VALOR DO PRODUTO NAO PODE SER NEGATIVO" VIEW-AS ALERT-BOX.
        RETURN FALSE.
    END.
    IF cNome = "" OR cDescrPro = "" OR iQuantid = 0 OR dValor = 0 THEN DO:
        MESSAGE "TODOS OS CAMPOS DEVEM SER PREENCHIDOS" VIEW-AS ALERT-BOX.
        RETURN FALSE.
    END.
    FIND FIRST ttVendedor WHERE ttVendedor.cVendedor = cVendedor NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttVendedor THEN DO:
        MESSAGE "O VENDEDOR INFORMADO NAO EXISTE" VIEW-AS ALERT-BOX.
        RETURN FALSE.
    END.
    FIND FIRST ttEmpresa WHERE ttEmpresa.cNomeEmp = cNomeEmp NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttEmpresa THEN DO:
        MESSAGE "A EMPRESA INFORMADA NAO EXISTE" VIEW-AS ALERT-BOX.
        RETURN FALSE.
    END.
        RETURN TRUE.
END PROCEDURE.

PROCEDURE pSalvarDados:
    DEFINE INPUT PARAMETER cNome AS CHARACTER.
    DEFINE INPUT PARAMETER cDescrPro AS CHARACTER.
    DEFINE INPUT PARAMETER iQuantid AS INTEGER.
    DEFINE INPUT PARAMETER dValor AS DECIMAL.
    DEFINE INPUT PARAMETER dtCadast AS DATE.
    DEFINE INPUT PARAMETER cVendedor AS CHARACTER.
    DEFINE INPUT PARAMETER cNomeEmp AS CHARACTER.
    DEFINE INPUT PARAMETER lAtivo AS LOGICAL.

    DEFINE VARIABLE iIdProduto AS INTEGER.

    ASSIGN iIdProduto = RANDOM(999). 
    ASSIGN ttProduto.cNome     = cNome
            ttProduto.dtCadast  = TODAY
            ttProduto.cDescrPro = cDescrPro
            ttProduto.iQuantid  = iQuantid
            ttProduto.dValor    = dValor
            ttProduto.cVendedor = cVendedor
            ttProduto.cNomeEmp  = cNomeEmp
            ttProduto.cIdProduto = STRING (iIdProduto)
            ttProduto.lAtivo    = lAtivo.
    ENABLE ALL WITH FRAME fCadastro EXCEPT cIdProduto dtCadast.
END PROCEDURE.