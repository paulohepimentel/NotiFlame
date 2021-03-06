<h1 align="center">
    <img alt="logo" title="NotiFlame" src="images/NotiFlame.svg" width="360px" />
</h1>

<p align="center">
  <a href="#-projeto">Projeto</a>
  &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-tecnologias">Tecnologias</a>
  &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-protótipo-do-hardware">Protótipo</a>
  &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-arquitetura-do-sistema">Arquitetura</a>
</p>

<p align="center">
    <img alt="Telas" title="App" src="images/Telas.svg" width="100%"/>
</p>

## ✦ Projeto
<p align="justify">
O módulo NotiFlame é composto por um sistema embarcado e um aplicativo que tem como função primordial empregar o papel de interface homem-máquina, ou seja, realizar a comunicação entre os sistemas de um modo mais simples e intuitivo. O módulo embarcado é composto por dois sensores e um buzzer. Os dois primeiros são responsáveis por detectar tanto incêndio quanto um gás no ambiente que possa provocar o mesmo. O buzzer consiste basicamente de um alarme físico caso o usuário não tome conhecimento do perigo através do aplicativo (notificação).
</p>

## ✦ Tecnologias
Esse projeto foi desenvolvido com as seguintes tecnologias:

**Hardware:**
- [ESP32](https://www.espressif.com/en/products/socs/esp32/overview)
- Sensores:
  - Sensor de Gás: MQ-7
  - Sensor de Chama/Fogo
  - Buzzer

**Software:**
- [PlatformIO](https://platformio.org/)
- [Flutter](https://flutter.dev/)
- [Google Cloud | IOT](https://cloud.google.com/solutions/iot?hl=pt-br)
- [Firebase | Cloud Firestore ](https://firebase.google.com/docs/firestore)

## ✦ Protótipo do Hardware
<p align="justify">
Segue abaixo uma representação simbólica dos sensores, jumpers e do microcontrolador ESP32 utilizados para a construção do módulo físico. O diagrama foi elaborado utilizando o software <a href="https://fritzing.org/home/">Fritzing</a>
</p>

<p align="center">
    <img alt="Protoboard" title="Esquema" src="images/Protoboard.png" width="45%" />
</p>

## ✦ Arquitetura do Sistema
<p align="justify">
A seguir, uma representação simbólica da arquitetura de comunicação entre o dispositivo mobile e a nuvem. Os dados interpretados pelo microcontrolador são enviados para o Google Cloud e esses por sua vez são armazenados no Cloud Firestore, um banco de dados NoSQL. O usuário com acesso pode consultar esses dados pelo aplicativo, na aba: Dashboard
</p>

<p align="center">
    <img alt="Arquitetura" title="Esquema" src="images/Esquema.svg" width="80%" />
</p>

---
<p align="justify">
O projeto foi desenvolvido, para fins didáticos, durante a disciplina de Sistemas Embarcados do curso de Bacharelado em Ciência da Computação da UFV – Campus Florestal
</p>
