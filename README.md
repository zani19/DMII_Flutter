# DMII_Flutter
Repositório destinado às atividades de Dispositivos Móveis II

# Avaliação 01 - Filtragem de Notas

## Introdução
Este repositório contém um aplicativo Flutter desenvolvido para a disciplina de Dispositivos Móveis II. O aplicativo inclui  o consumo de informações do endpoint:
```sh
http://demo0152687.mockable.io/notasAlunos
```

## Pré-requisitos
Antes de começar, certifique-se de ter o seguinte instalado:
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) ou [Visual Studio Code](https://code.visualstudio.com/) com as extensões Flutter e Dart

## Clonar o Repositório
Clone o repositório para sua máquina local usando o seguinte comando:
```sh
git clone -b avaliacao01 https://github.com/zani19/DMII_Flutter.git
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
- [lib/main.dart](https://github.com/zani19/DMII_Flutter/blob/avaliacao01/lib/main.dart): Arquivo principal que inicia o aplicativo com suas respectivas rotas.
- [lib/pages/home_page.dart](https://github.com/zani19/DMII_Flutter/blob/avaliacao01/lib/home_page.dart): Home page do projeto.
- [lib/pages/login_page.dart](https://github.com/zani19/DMII_Flutter/blob/avaliacao01/lib/login_page.dart): Página de LOGIN do projeto.
- [lib/pages/notas_alunos_page.dart](https://github.com/zani19/DMII_Flutter/blob/avaliacao01/lib/notas_alunos_page.dart): Página responsável por exibir as notas dos alunos.