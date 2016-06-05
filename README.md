# Academia_Haskell


Nosso trabalho é um projeto em WebService destinado a fornecer 
determinados subsídios ao administrador de uma pequena Academia (mainAcademia.hs).
Para isso temos três tabelas, uma com informações sobre os nossos clientes/alunos, 
chamada CadastroClientes;  a segunda com informações sobre os nossos funcionários, 
denominada CadastroFuncionarios; e uma terceira com a relação de despesas mensais, 
a tabela Despesas.

Para as tabelas CadastroClientes e CadastroFuncionarios temos meios de incluir 
novas pessoas, atualizar essas informações cada vez que houver um acréscimo nas 
mensalidades, nos salários dos funcionários, mudança de endereço etc. Podemos 
listar o cadastro completo de cada tabela.
Para a tabela Despesas, da mesma forma, podemos incluir novas despesas, deletar itens,
listar todos eles e podemos calcular a soma de todas as despesas  provenientes 
desta tabela.

Em seguida fornecemos o caminho para acessar todas as informações 
descritas acima:  


** entra na pasta web **

    --cd web
       --stack build 
       
    ** stack exec 
          -- web (nome da pasta) **

 
      
** -------------------- ACADEMIA HASKELL -------------------------------------**

**  ==>  DESPESAS  <==  **

** para inserir  Despesas **
 
    curl https://web-dinorachristovam.c9users.io/despesas \
      -v \
      -X POST \
      -H 'Content-Type: application/json' \
      -d '{"diaMesAno":"15/10/16"
          ,"encargosSociais": 1200.0
          ,"aluguel": 750.0
          ,"pagamentoDeTaxas": 250.0
          ,"energiaEAgua": 85.0
          ,"telefone": 102.0
          ,"materialDeEscritorio": 25.0
          ,"materialDeLimpeza": 32.0
          ,"manutencaoEConservacao": 45.0}'
          
          
** para listar despesas**

    curl https://web-dinorachristovam.c9users.io/despesas \
      -v \
      -X GET \
      -H 'Content-Type: application/json' 
      
      
** para listar Despesas na URL **

    https://web-dinorachristovam.c9users.io/despesas 
    
    
** para somar despesas**

    curl https://web-dinorachristovam.c9users.io/despesas/total \
      -v \
      -X GET \
      -H 'Content-Type: application/json'
      
      
** para somar despesas na URL**
    
    https://web-dinorachristovam.c9users.io/despesas/total 
    
    
** para deletar despesa **

    curl https://web-dinorachristovam.c9users.io/despesas/action/3 \
      -v \
      -X DELETE
      
      
**  ==>  FUNCIONARIOS  <==  **

** para inserir cadastro funcionario **

    curl https://web-dinorachristovam.c9users.io/cadastroFuncionarios \
      -v \
      -X POST \
      -H 'Content-Type: application/json' \
      -d '{ "nome": "Antonio"
          , "dataNascimento": "21/02/1990"
          , "funcao": "Administrador"
          , "rg": "987654321"
          , "cpf": "123456789"
          , "salario": 2000
          , "periodoDeFerias": "11/11/2016"
          , "endereco": "Av. Bartolomeu de Gusmão"
          , "telefone": "3333-33333" }'
          
          
** para listar funcionarios **

    curl https://web-dinorachristovam.c9users.io/cadastroFuncionarios \
      -v \
      -X GET \
      -H 'Content-Type: application/json' 
      
      
** para listar Funcionarios na URL **

    https://web-dinorachristovam.c9users.io/cadastroFuncionarios 