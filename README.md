# DMII_Flutter
Repositório destinado às atividades de Dispositivos Móveis II

# SIMULADO - Pedidos com SQFlite

## Introdução
Este repositório contém um aplicativo Flutter desenvolvido para a disciplina de Dispositivos Móveis II. O aplicativo inclui  o consumo de informações dos endpoints abaixo e armazenamento interno no dispositivo utilizando o SQFLite:
```sh
http://demo0152687.mockable.io/clientes
```
```sh
http://demo0152687.mockable.io/produtos
```
```sh
http://demo0152687.mockable.io/pedidos
```

## Pré-requisitos
Antes de começar, certifique-se de ter o seguinte instalado:
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) ou [Visual Studio Code](https://code.visualstudio.com/) com as extensões Flutter e Dart

## Clonar o Repositório
Clone o repositório para sua máquina local usando o seguinte comando:
```sh
git clone -b simulado https://github.com/zani19/DMII_Flutter.git
```
## Instalar Dependências
```sh
cd DMII_Flutter
flutter pub get
```

## Rodar a Aplicação

```sh
flutter run
```

## Estrutura do Projeto
- [lib/main.dart](https://github.com/zani19/DMII_Flutter/blob/simulado/lib/main.dart): Arquivo principal que inicia o aplicativo com suas respectivas rotas e tela de login.
- [lib/pages/home.dart](https://github.com/zani19/DMII_Flutter/blob/simulado/lib/pages/home.dart): Home page do projeto com os botões Clientes, Produtos e Pedidos.
- [lib/pages/clients_page.dart](https://github.com/zani19/DMII_Flutter/blob/simulado/lib/pages/clients_page.dart): Página de exibição dos Clientes.
- [lib/pages/products_page.dart](https://github.com/zani19/DMII_Flutter/blob/simulado/lib/pages/products_page.dart): Página de exibição dos Produtos.
- [lib/pages/orders_page.dart](https://github.com/zani19/DMII_Flutter/blob/simulado/lib/pages/orders_page.dart): Página de exibição dos Pedidos e sincronização dos pedidos.
- [lib/pages/create_order_page.dart](https://github.com/zani19/DMII_Flutter/blob/simulado/lib/pages/create_order_page.dart): Página de criação dos Pedidos.
- [lib/utils/database_helper.dart](https://github.com/zani19/DMII_Flutter/blob/simulado/lib/utils/database_helper.dart): Página destinada ao Banco de Dados SQFLite.