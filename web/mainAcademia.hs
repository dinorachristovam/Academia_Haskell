{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleInstances,
             MultiParamTypeClasses, DeriveDataTypeable,
             GeneralizedNewtypeDeriving, ViewPatterns, EmptyDataDecls #-}
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Control.Monad.Logger (runStdoutLoggingT)

data Pagina = Pagina{connPool :: ConnectionPool}

instance Yesod Pagina

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|

-- Criacao das tabelas do Banco de Dados
CadastroClientes json
   nome Text
   turma Text
   idade Text
   sexo Text
   telefone Text
   endereco Text
   mensalidade Double
   deriving Show
   
CadastroFuncionarios json
   nome Text
   dataNascimento Text
   funcao Text
   rg Text
   cpf Text
   salario Double
   periodoDeFerias Text
   endereco Text
   telefone Text
   deriving Show

Despesas json
    diaMesAno Text
    encargosSociais Double
    aluguel Double
    pagamentoDeTaxas Double
    energiaEAgua 
    telefone Double
    materialDeEscritorio Double
    materialDeLimpeza Double
    manutencaoEConservacao Double
    deriving Show
|]

mkYesod "Pagina" [parseRoutes|

/cadastroClientes UserR GET POST   -- cadastroClientes
/cadastroFuncionarios FuncR POST GET  --cadastroFuncionarios
/despesas DespesasR GET POST           --cadastroDespesas
/despesas/total TotalDespesasR GET
/cadastroClientes/action/#CadastroClientesId ActionClienteR GET PUT DELETE
/cadastroFuncionarios/action/#CadastroFuncionariosId ActionFuncionarioR GET PUT DELETE
/despesas/action/#DespesasId ActionDespesasR GET DELETE


|]


instance YesodPersist Pagina where
   type YesodPersistBackend Pagina = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

----------------- USUARIO ------------------------------------------------------ 

getUserR :: Handler ()
getUserR = do
    allClientes <- runDB $ selectList [] [Asc CadastroClientesNome]
    sendResponse (object [pack "data" .= fmap toJSON allClientes])       

postUserR :: Handler ()
postUserR = do
    clientes <- requireJsonBody :: Handler CadastroClientes
    runDB $ insert clientes
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
getActionClienteR :: CadastroClientesId -> Handler ()
getActionClienteR pid = do
    cli <- runDB $ get404 pid --se nao encontrar nada retorna 404
    sendResponse $ toJSON cli -- se achar
    
putActionClienteR :: CadastroClientesId -> Handler ()
putActionClienteR pid = do
    cli <- requireJsonBody :: Handler CadastroClientes
    runDB $ update pid [CadastroClientesNome =. cadastroClientesNome cli]
    sendResponse (object [pack "resp" .= pack "UPDATED"])
    
deleteActionClienteR :: CadastroClientesId -> Handler ()
deleteActionClienteR pid = do
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "DELETED"])


----------------- FUNCIONARIO --------------------------------------------------

getFuncR :: Handler ()
getFuncR = do
    allFuncionarios <- runDB $ selectList [] [Asc CadastroFuncionariosNome]
    sendResponse (object [pack "resp" .= fmap toJSON allFuncionarios])
    
postFuncR :: Handler ()   
postFuncR = do
    funcionarios <- requireJsonBody :: Handler CadastroFuncionarios
    runDB $ insert funcionarios
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
getActionFuncionarioR :: CadastroFuncionariosId -> Handler ()
getActionFuncionarioR fuid = do
    allFuncionarios <- runDB $ selectList [] [Asc CadastroFuncionariosNome]
    sendResponse (object [pack "data" .= fmap toJSON allFuncionarios])
    
putActionFuncionarioR :: CadastroFuncionariosId -> Handler ()
putActionFuncionarioR fuid = do
    cli <- requireJsonBody :: Handler CadastroFuncionarios
    runDB $ update fuid [CadastroFuncionariosNome =. cadastroFuncionariosNome cli]
    sendResponse (object [pack "resp" .= pack "UPDATED"])
    
deleteActionFuncionarioR :: CadastroFuncionariosId -> Handler ()
deleteActionFuncionarioR fuid = do
    runDB $ delete fuid
    sendResponse (object [pack "resp" .= pack "DELETED"])



------------------ DESPESAS ---------------------------------------------------   

getDespesasR :: Handler ()
getDespesasR = do
    allDespesas <- runDB $ selectList [] [Asc DespesasDiaMesAno]
    sendResponse (object [pack "data" .= allDespesas])
    
getTotalDespesasR :: Handler ()
getTotalDespesasR = do
    allDespesas <- runDB $ selectList [] [Asc DespesasDiaMesAno]
    let total = Prelude.foldl (\acumulador despesa -> acumulador + (calcularTotalPorDespesa ( despesa))) 0 allDespesas
        calcularTotalPorDespesa (Entity _ (Despesas _ es a p ea t me ml mc)) = es + a + p + ea + t + me + ml + mc
    sendResponse (object [pack "data" .= total])
    
postDespesasR :: Handler ()
postDespesasR = do
    desp <- requireJsonBody :: Handler Despesas
    runDB $ insert desp
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
getActionDespesasR :: DespesasId -> Handler ()
getActionDespesasR pid = do
    cli <- runDB $ get404 pid
    sendResponse $ toJSON cli

deleteActionDespesasR :: DespesasId -> Handler ()
deleteActionDespesasR pid = do
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "DELETED"])


connStr = "dbname=dco2uk5ioda5q2 host=ec2-23-21-167-249.compute-1.amazonaws.com user=herlhdsndxdiiu password=aNhBPPs7a3RVnfg1slcxG5q12K port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool
       warp 8080 (Pagina pool)