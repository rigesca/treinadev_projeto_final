# Projeto Final TreinaDev - Sistema de vagas

Projeto criado para desenvolver um sistema web para busca de vagas de emprego. Nesse sistema ira existir dois perfis, um de candidato que acessa e se inscreve nas vagas e outro de headhunter, que cadastra as vagas seleciona os candidatos. 

## Índice 
### *Gems
### *Versões 
### *Preparação do ambiente 
### *Sistema
### *Utilização

## Gems
Além das gems automáticas criadas pelo projeto, foram adicionadas as seguintes gem:
* Devise - Utilizado para autenticação dos usuários no sistema. 
* Twitter bootstrap rails - Utilizado para estilizar os códigos do from-end do projeto com os padrões bootstrap.
* Simplecov - Verifica cobertura dos testes criado no sistema, apresentando estimativas para tomada de decisões (utilizada apenas no ambiente de teste).
* Shoulda-Matchers - Gem utilizada para criar teste de validação e associações no projeto (utilizada apenas no ambiente de teste).
* Rack – A gem foi colocada e atualizada no projeto para corrigir um erro de vulnerabilidade detectado pelo github.
* FactoryBot - Utilizada para criação de objetos (utilizada apenas no ambiente de teste).
* FFaker - Utilizada para gerar valores aleatorios em alguns objetos criados pela gem FactoryBot (utilizada apenas no ambiente de teste). 

## Versões
Para esse projeto foram usados as seguintes versões: 
* Ruby ver.: 2.6.5
* Rails ver.: 5.2.3 ou maior

## Preparação do ambiente 
Apos clonar o projeto, executar o comando 'bundle install' para ser instalado\atualizado todas as gens e dependências do projeto. O próximo passo é executar o comando 'rails db:migrate' para criação das estruturas do banco de dados. 

Para executar o projeto, basta executar o comando 'rails s' dentro da pasta do projeto, para que o servidor seja criado e executado. 

## Sistema
O conceito do sistema é criar um programa de criação e candidatura de vagas de emprego, permitindo que headhunter identifiquem e selecionem o(s) melhore(s) candidato(s) para a vaga cadastrada. 

No sistema ira existir dois perfis, um headhunter e um candidato. 

O headhunter poderá:
* Criar uma vaga.
* Ver a lista de candidatos inscritos em uma vaga.
* Enviar uma mensagem para um candidato inscrito em uma vaga.
* Caso o candidato não tenha o perfil indicado para a vaga, o headhunter pode cancelar a inscrição do candidato, apresentando um feadback para o mesmo.
* Enviar uma proposta a um candidato.
* Verificar o feadback de uma proposta (sendo essa positivo ou negativo).
* Encerrar o processo seletivo de uma vaga.

Já o candidato poderá:
* Criar ou editar seu perfil.
* Verificar as vagas disponíveis naquele período em que foi acessado o sistema.
* Inscrever-se em uma vaga.
* Verificar em quais ou quantas vagas ele esta inscrito.
* Verificar as mensagens dos headhunters.
* Verificar o status da inscrição.
* Aceitar ou recusar uma proposta enviada por um headhunter referente a uma vaga. 

## Utilização
Ao acessar o sistema o visitante poderá escolher qual tipo de perfil ele deseja criar, se um headhunter ou um candidato, assim também como escolher qual perfil ira realizar seu login. 

Ao logar como headhunter, o usuario poderá escolher entre duas opções, “vagas” ou “propostas”. Na opção “vagas”, um headhunter pode cadastrar uma vaga ou ver as vagas previamente cadastradas por ele, clicando no titulo da vaga. Atualmente não é possível alterar os dados da vaga. Na criação da vaga o headhunter ira determinar uma data limite para inscrições. 

No perfil da vaga o headhunter pode acessar a lista de candidatos inscritos nela ate a data limite. Nessa tela o headhunter pode marcar perfis como favoritos para a vaga, cancelar a inscrição do candidato e por fim fazer uma proposta caso tenha achado o perfil adequado para a vaga. 

O headhunter também pode deixar uma mensagem particular para o candidato, acessando seu perfil e clicando no botão "enviar comentário". Nessa tela sera exibido apenas os comentários do headhunter que estiver acessando a mensagem no momento. 

Ao fazer uma proposta o headhunter devera informar a data de inicio das atividades, benefícios, o valor do salario (que deverá estar dentro da faixa informada no perfil da vaga), alguma observação caso ache necessário, e uma data limite para a resposta do candidato. Caso a data limite seja atingida sem um feedback do candidato, a proposta é automaticamente cancelada. 

Já o candidato possui cinco opções no menu inicial, "perfil", "mensagens" "busca vagas", "minhas vagas" e “minhas propostas”.

Ao se cadastrar no sistema o candidato é obrigado a preencher seu perfil para se candidatar a qualquer vaga ou acessar as opções na homepage, sendo que todos os campos são obrigatórios para validação do perfil. 

A opção perfil permite que o candidato consulte seus dados e realize alguma alteração caso seja necessário. Nessa tela também é possível verificar todas as mensagens enviadas a ele clicando no botão "comentários". A opção "mensagens" é apenas um atalho na home para essa opção. 

Na opção "Buscar Vagas" o candidato pode ver todas as vagas que ainda estão com as inscrições abertas. Ao acessar a vaga o candidato pode ver os requisitos e pode se escrever em uma ou mais vagas, sendo obrigado apenas a apresentar uma justificativa no momento da inscrição. Essa justificativa fica disponível apenas para o headhunter que criou a vaga, como um auxilio no avaliação e eliminatória de possíveis candidatos. 

Na opção "Minhas vagas" o candidato pode ver todas as vagas em que já se encontra escrito e seus status. Clicando novamente no titulo da vaga ele tem acesso a todos os dados da vaga novamente caso precise rever alguma informação.

E por ultimo, na opção “propostas” ele pode ver as propostas que recebeu das vagas em que se inscreveu. O candidato tem duas opções, rejeitar ou aceitar a proposta, enviando um feedback ao headhunter. 

Ao ter uma ou mais propostas aceitas, o headhunter pode encerrar a vaga dentro da tela de consulta da vaga. Ao fazer isso, todas as propostas são finalizadas e as demais inscrições canceladas.

