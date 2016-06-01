** entra na pasta web **
   cd web
** stack build **
** stack exec -- web (nome da pasta) **

 
 ** para inserir  **
curl https://hask2-romefeller.c9users.io/cadastro \
  -v \
  -X POST \
  -H 'Content-Type: application/json' \
  -d '{"nome":"EU"}'

** cadastrar produto **

curl https://aula1haskell-dinorachristovam.c9users.io/produto \
  -v \
  -X POST \
  -H 'Content-Type: application/json' \
  -d '{"nome":"Sabonete","valor":18}'
  
** para listar **
https://ide.c9.io/dinorachristovam/aula1haskell/listar


** para alterar **

curl https://hask2-romefeller.c9users.io/cadastro/update/26 \
  -v \
  -X PUT \
  -H 'Content-Type: application/json' \
  -d '{"nome":"mari"}'


** para deletar **
  
curl https://aula1haskell-dinorachristovam.c9users.io/action/1 \
  -v \
  -X DELETE
# Academia_Haskell
