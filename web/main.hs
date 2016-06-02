{-# LANGUAGE OverloadedStrings     #-}--pragmas | diretivas de compilacao
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET POST--nome da rota HomeR 
/link LinkR GET
|]
--o TIPO HelloWorld representa sua pag
--pois eh uma instacia de Yesod
--todo site tem q ser instacia de instance Yesod HelloWorld
instance Yesod HelloWorld

--Site comeca aqui
--defaultLayout: mostra na tela o html/css/js
getHomeR :: Handler Html --handler vai inderiza a pag 
getHomeR = defaultLayout $ [whamlet| --whamlet: html , 
    <h1> Hello World!
    <button onclick="teste()"> OK
|] >> toWidget [lucius|
     h1{
         color: red;
     }
|] >> toWidgetHead [julius|
    function teste(){
        alert("ola mundo");
    }
|]

postHomeR :: Handler Html
postHomeR = defaultLayout $ [whamlet|
    <h2> Ola metodo POST
|]

getLinkR :: Handler Html
getLinkR = defaultLayout $ [whamlet|
    <a href=@{HomeR}> Pagina inicial --HomeR rota principal
|]
---------------------------
main :: IO ()
main = warp 8080 HelloWorld

--para executar a pag
--stack exec -- web
--clica em preview
--clica em preview running application

--para parar a aplicacao ctrl + c
--para compilar stack build
--para executar stack exec -- web

--curl -v -x POST htpps://.....