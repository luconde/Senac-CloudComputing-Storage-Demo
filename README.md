# Visão Geral
Este projeto web baseado em ASPNET Core realiza upload de um arquivo no serviço de storage dos principais provedores de nuvem. Bem como, permite listar os objetos armazenados; os quais os registros foram feitos em Azure Table.

Projeto construído para a disciplina **Cloud Computing e Internet das Coisas** do curso **Tecnologia em Sistemas para Internet (TSI) do Senac-SP**.

# Autor
**Luciano Condé de Souza (luconde@gmail.com)**  
**Data da criação do projeto**: 2022-05-26  
**Data da última atualização**: 2023-09-07  
**Versão**: 1.0.30

## Disclaimer
O seguinte material foi construído a partir de referências publicadas na Internet, livros e artigos acadêmicos. As referências foram utilizadas de sites e posts na Internet, não há qualquer propósito de plagiar os autores, em caso de pedidos de adição do autor, pode encontrar em contato pelo email luconde@gmail.com. A simplificação de certos conteúdos tem o único propósito didático para facilitar o entendimento dos mesmos para os alunos.

# Notas da versão 
## Versão 1.0.31
1. Adição do mecanismo de exibição de versão a partir do assembly (DLL) gerado
2. Ajustes na tela Sobre
3. Melhorias de código

# Detalhes técnicos

## Funcionalidades
1. Realiza o upload para os storages
2. Lista os arquivos listados, os quais os registros foram armazenados em Azure Table
3. Scripts em Powershell para criar os repositórios nos provedores de cloud

## Pré-requisitos
1. Subscription Ativa do Microsoft Azure, Amazon Web Services, Oracle Cloud Infrastructure, Google Cloud
2. Visual Studio 2022 Community para executar o código-fonte

# Informações adicionais
Utilize o arquivo appsettings.json.template para criar o próprio appsettings.json. Adicione as configurações de acesso para os serviços de storage dos provedores de nuvem. 

Para utilização dos scripts é necessário a configuração das credenciais em cada serviço. 