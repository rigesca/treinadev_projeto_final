# Projeto Final TreinaDev - Sistema de vagas

Projeto criado para desenvolver um sistema web para de um sistema de vagas de emprego. Nesse sistema ira existir dois perfis de usuário, o headhunter que cadastra as vagas e o candidato que poderá se inscrever em vagas de emprego. 

## Índice 
### *Gems 
### *Sistema
### *Utilização

## Gems
Além das gems automáticas criadas pelo projeto, foram adicionadas as seguintes gem:
* Devise - Utilizado para autenticação dos usuários no sistema. 
* Twitter bootstrap rails - Utilizado para estilizar os códigos do from-end do projeto com os padrões bootstrap.
* Rack - Atualizado a gem para corrigir um erro de vulnerabilidade detectado pelo github.

## Sistema

O conceito do sistema é criar um programa de criação e candidatura de vagas de emprego, permitindo que headhunter identifique e selecione o(s) melhore(s) candidato(s) para a vaga cadastrada. 

No sistema ira existir dois perfis, um headhunter e um candidato. 

O headhunter poderá:
* Criar uma vaga.
* Ver a lista de candidatos inscritos em uma vaga.
* Enviar uma mensagem para um candidato inscrito em uma vaga.
* Caso o candidato não tenha o perfil indicado para a vaga, o headhunter pode cancelar a inscrição do candidato apresentando um feadback.
* Enviar uma proposta a um candidato.
* Verificar o feadback de uma proposta.
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

Ao acessar o sistema o visitante poderá escolher qual tipo de perfil ele deseja criar, se um headhunter ou um candidato, assim também como escolher entre login. 

Ao logar como headhunter, por enquanto, a única opção a ser utilizada por ele é a de vagas. Nela o headhunter pode cadastrar uma vaga ou ver as vagas cadastradas por ele, clicando no titulo da vaga. Atualmente não é possível alterar os dados da vaga. Na criação da vaga o headhunter ira determinar uma data limite para inscrições. 

No perfil da vaga o headhunter pode acessar a lista de candidatos inscritos nela ate a data limite. Nessa tela o headhunter pode marcar perfis como favoritos para a vaga, cancelar a inscrição do candidato e por fim fazer uma proposta caso tenha achado o perfil adequado para a vaga. 

O headhunter também pode deixar uma mensagem particular para o candidato, acessando seu perfil e clicando no botão "enviar comentário". Nessa tela sera exibido apenas os comentários do headhunter que estiver acessando a mensagem no momento. 

Já o candidato possui quatro opções no menu inicial, "perfil", "mensagens" "busca vagas" e "minhas vagas". 

Ao se cadastrar no sistema o candidato é obrigado a preencher seu perfil para se candidatar a qualquer vaga ou acessar as opções na homepage, sendo que todos os campos são obrigatórios para validação do perfil. 

A opção perfil permite que o candidato consulte seus dados e realize alguma alteração caso seja necessário. Nessa tela também é possível verificar todas as mensagens enviadas a ele clicando no botão "comentários". A opção "mensagens" é apenas um atalho na home para essa opção. 

Na opção "Buscar Vagas" o candidato pode ver todas as vagas que ainda estão com as inscrições abertas. Ao acessar a vaga o candidato pode ver os requisitos e pode se escrever em uma ou mais vagas, sendo obrigado apenas a apresentar uma justificativa no momento da inscrição. Essa justificativa fica disponível apenas para o headhunter que criou a vaga, como um auxilio no avaliação e eliminatória de possíveis candidatos. 

Na opção "Minhas vagas" o candidato pode ver todas as vagas em que já se encontra escrito. Clicando novamente no titulo da vaga ele tem acesso a todos os dados da vaga novamente caso precise rever alguma informação.
