// Definindo as tabelas temporárias que serão usadas ao longo do código//

DEFINE TEMP-TABLE ttProduto NO-UNDO
    FIELD cIdProduto AS INTEGER   FORMAT "99"
    FIELD cNome     AS CHARACTER FORMAT "X(6)"
    FIELD cDescrPro AS CHARACTER FORMAT "X(8)"
    FIELD iQuantid  AS INTEGER   FORMAT "99"
    FIELD dValor    AS DECIMAL   FORMAT "R$ Z,ZZZ,ZZZ,ZZ9.99"
    FIELD dtCadast  AS DATE      FORMAT
    FIELD cVendedor AS CHARACTER FORMAT "X(6)"
    FIELD cNomeEmp  AS CHARACTER FORMAT "X(6)"
    FIELD lAtivo    AS LOGICAL   FORMAT "YES/NO"
    INDEX idx_produto IS PRIMARY cIdProduto cNome cVendedor cNomeEmp.

DEFINE TEMP-TABLE ttEmpresa NO-UNDO 
    FIELD cCep     AS CHARACTER FORMAT "99999-999"
    FIELD cCnpj    AS CHARACTER FORMAT "99.999.999/9999-99"
    FIELD cNomeEmp AS CHARACTER FORMAT "X(6)"
    FIELD cCidade  AS CHARACTER FORMAT "X(8)".
    INDEX idx_empresa IS PRIMARY cNomeEmp cCnpj.

DEFINE TEMP-TABLE ttVendedor NO-UNDO
    FIELD cVendedor AS CHARACTER FORMAT "X(6)"
    FIELD cCep      AS CHARACTER FORMAT "99999-999"
    FIELD cNomeEmp  AS CHARACTER FORMAT "X(6)"
    FIELD cTelefone AS CHARACTER FORMAT "(99)99999-9999"
    INDEX idx_vendedor IS PRIMARY cVendedor cNomeEmp cTelefone.

 //Definindo variáveis que serão usadas ao longo do programa//
DEFINE VARIABLE cNome     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDescrPro AS CHARACTER NO-UNDO.
DEFINE VARIABLE iQuantid  AS INTEGER   NO-UNDO.
DEFINE VARIABLE dValor    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dtCadast  AS DATE      NO-UNDO.
DEFINE VARIABLE cVendedor AS CHARACTER NO-UNDO.
DEFINE VARIABLE lAtivo    AS CHARACTER NO-UNDO.

DEFINE VARIABLE cCep     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCnpj    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCidade  AS CHARACTER NO-UNDO.

DEFINE VARIABLE cCep      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNomeEmp  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTelefone AS CHARACTER NO-UNDO.