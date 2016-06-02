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

Despesas json
    diaMesAno Text
    encargosSociais Double
    aluguel Double
    pagamentoDeTaxas Double
    energiaEAgua 
    telefone Double
    
    
    
    deriving Show
|]

mkYesod "Pagina" [parseRoutes|

/despesas DespesasR GET POST


|]






connStr = "dbname=dco2uk5ioda5q2 host=ec2-23-21-167-249.compute-1.amazonaws.com user=herlhdsndxdiiu password=aNhBPPs7a3RVnfg1slcxG5q12K port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool
       warp 8080 (Pagina pool)